import 'dart:typed_data';

/// Minimal reader for Microsoft OLE2 / Compound File Binary containers
/// (the container format used by Wilcom `.EMB` files).
///
/// Supports regular + mini streams, DIFAT chains and both 512/4096 sectors.
class OleCompoundFile {
  OleCompoundFile._(this._bytes, this._sectorSize,
      this._miniSectorSize, this._miniCutoff, this._fat, this._miniFat,
      this._entries);

  static const List<int> signature = [
    0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1,
  ];

  static const int _maxRegular = 0xFFFFFFFA;

  final Uint8List _bytes;
  final int _sectorSize;
  final int _miniSectorSize;
  final int _miniCutoff;
  final List<int> _fat;
  final List<int> _miniFat;
  final List<OleEntry> _entries;
  Uint8List? _miniStream;

  static bool hasSignature(Uint8List bytes) {
    if (bytes.length < 512) return false;
    for (var i = 0; i < signature.length; i++) {
      if (bytes[i] != signature[i]) return false;
    }
    return true;
  }

  /// Throws [FormatException] when [bytes] is not a valid compound file.
  factory OleCompoundFile.parse(Uint8List bytes) {
    if (!hasSignature(bytes)) {
      throw const FormatException('Not an OLE compound file');
    }
    final data = ByteData.sublistView(bytes);
    final sectorShift = data.getUint16(30, Endian.little);
    final miniShift = data.getUint16(32, Endian.little);
    if (sectorShift < 7 || sectorShift > 16 || miniShift > sectorShift) {
      throw const FormatException('Corrupt OLE header');
    }
    final sectorSize = 1 << sectorShift;
    final miniSectorSize = 1 << miniShift;
    final dirStart = data.getUint32(48, Endian.little);
    final miniCutoff = data.getUint32(56, Endian.little);
    final miniFatStart = data.getUint32(60, Endian.little);
    var difatSector = data.getUint32(68, Endian.little);
    final difatCount = data.getUint32(72, Endian.little);

    int sectorOffset(int sector) => (sector + 1) * sectorSize;

    // Collect FAT sector numbers from the header DIFAT + DIFAT chain.
    final fatSectors = <int>[];
    for (var i = 0; i < 109; i++) {
      final s = data.getUint32(76 + 4 * i, Endian.little);
      if (s < _maxRegular) fatSectors.add(s);
    }
    var guard = 0;
    while (difatSector < _maxRegular && guard++ <= difatCount) {
      final base = sectorOffset(difatSector);
      if (base + sectorSize > bytes.length) break;
      final perSector = sectorSize ~/ 4 - 1;
      for (var i = 0; i < perSector; i++) {
        final s = data.getUint32(base + 4 * i, Endian.little);
        if (s < _maxRegular) fatSectors.add(s);
      }
      difatSector = data.getUint32(base + 4 * perSector, Endian.little);
    }

    final fat = <int>[];
    for (final s in fatSectors) {
      final base = sectorOffset(s);
      if (base + sectorSize > bytes.length) continue;
      for (var j = 0; j < sectorSize; j += 4) {
        fat.add(data.getUint32(base + j, Endian.little));
      }
    }

    List<int> chain(int start) {
      final out = <int>[];
      var s = start;
      while (s < _maxRegular && s < fat.length && out.length <= fat.length) {
        out.add(s);
        s = fat[s];
      }
      return out;
    }

    Uint8List readChain(int start, int? size) {
      final builder = BytesBuilder(copy: false);
      for (final s in chain(start)) {
        final base = sectorOffset(s);
        if (base >= bytes.length) break;
        final end = base + sectorSize;
        builder.add(Uint8List.sublistView(
            bytes, base, end > bytes.length ? bytes.length : end));
        if (size != null && builder.length >= size) break;
      }
      final out = builder.toBytes();
      return size != null && out.length > size
          ? Uint8List.sublistView(out, 0, size)
          : out;
    }

    final miniFat = <int>[];
    if (miniFatStart < _maxRegular) {
      final mf = readChain(miniFatStart, null);
      final mfData = ByteData.sublistView(mf);
      for (var j = 0; j + 4 <= mf.length; j += 4) {
        miniFat.add(mfData.getUint32(j, Endian.little));
      }
    }

    final dirBytes = readChain(dirStart, null);
    final dirData = ByteData.sublistView(dirBytes);
    final entries = <OleEntry>[];
    for (var i = 0; i + 128 <= dirBytes.length; i += 128) {
      final nameLen = dirData.getUint16(i + 64, Endian.little);
      final type = dirBytes[i + 66];
      if (type == 0 || nameLen < 2 || nameLen > 64) {
        entries.add(const OleEntry(name: '', type: 0, start: 0, size: 0));
        continue;
      }
      final chars = <int>[];
      for (var c = 0; c < nameLen - 2; c += 2) {
        chars.add(dirData.getUint16(i + c, Endian.little));
      }
      entries.add(OleEntry(
        name: String.fromCharCodes(chars),
        type: type,
        start: dirData.getUint32(i + 116, Endian.little),
        size: dirData.getUint32(i + 120, Endian.little),
      ));
    }
    if (entries.isEmpty || entries.first.type != 5) {
      throw const FormatException('OLE root entry missing');
    }

    return OleCompoundFile._(bytes, sectorSize, miniSectorSize,
        miniCutoff, fat, miniFat, entries);
  }

  List<String> get streamNames =>
      [for (final e in _entries) if (e.type == 2) e.name];

  /// Returns the stream content, or null if no stream has that name.
  Uint8List? stream(String name) {
    for (final e in _entries) {
      if (e.type == 2 && e.name == name) return _readEntry(e);
    }
    return null;
  }

  Uint8List _readEntry(OleEntry e) {
    if (e.size < _miniCutoff) {
      _miniStream ??= _readRegular(_entries.first.start, _entries.first.size);
      final mini = _miniStream!;
      final builder = BytesBuilder(copy: false);
      var s = e.start;
      var guard = 0;
      while (s < _maxRegular &&
          s < _miniFat.length &&
          builder.length < e.size &&
          guard++ <= _miniFat.length) {
        final base = s * _miniSectorSize;
        if (base >= mini.length) break;
        final end = base + _miniSectorSize;
        builder.add(Uint8List.sublistView(
            mini, base, end > mini.length ? mini.length : end));
        s = _miniFat[s];
      }
      final out = builder.toBytes();
      return out.length > e.size ? Uint8List.sublistView(out, 0, e.size) : out;
    }
    return _readRegular(e.start, e.size);
  }

  Uint8List _readRegular(int start, int size) {
    final builder = BytesBuilder(copy: false);
    var s = start;
    var guard = 0;
    while (s < _maxRegular &&
        s < _fat.length &&
        builder.length < size &&
        guard++ <= _fat.length) {
      final base = (s + 1) * _sectorSize;
      if (base >= _bytes.length) break;
      final end = base + _sectorSize;
      builder.add(Uint8List.sublistView(
          _bytes, base, end > _bytes.length ? _bytes.length : end));
      s = _fat[s];
    }
    final out = builder.toBytes();
    return out.length > size ? Uint8List.sublistView(out, 0, size) : out;
  }
}

class OleEntry {
  const OleEntry({
    required this.name,
    required this.type,
    required this.start,
    required this.size,
  });

  final String name;
  final int type; // 1 storage, 2 stream, 5 root
  final int start;
  final int size;
}
