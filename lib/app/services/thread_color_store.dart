import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers the colours and draw styles a user picked for a design, keyed
/// by [ThreadBlock.colorKey] (needle/device for DHP, block for DST).
class ThreadColorStore {
  ThreadColorStore(this._prefs);

  final SharedPreferences _prefs;

  // File pickers copy files to temp paths, so identify designs by name and
  // stitch count rather than path.
  String _key(EmbroideryDesign d) =>
      'thread_colors|${d.extension}|${d.fileName}|${d.totalStitches}';

  EmbroideryDesign applySaved(EmbroideryDesign design) {
    final raw = _prefs.getString(_key(design));
    if (raw == null) return design;
    try {
      final saved = (jsonDecode(raw) as Map<String, dynamic>)
          .map((k, v) => MapEntry(int.parse(k), v as Map<String, dynamic>));
      return design.copyWith(threads: [
        for (final t in design.threads)
          if (saved[t.colorKey] case final v?)
            t.copyWith(
              color: Color(v['c'] as int),
              style: ThreadStyle.values[(v['s'] as int)
                  .clamp(0, ThreadStyle.values.length - 1)],
            )
          else
            t,
      ]);
    } catch (_) {
      return design;
    }
  }

  Future<void> save(EmbroideryDesign design) async {
    final map = {
      for (final t in design.threads)
        '${t.colorKey}': {'c': t.color.toARGB32(), 's': t.style.index},
    };
    await _prefs.setString(_key(design), jsonEncode(map));
  }

  Future<void> clear(EmbroideryDesign design) => _prefs.remove(_key(design));
}
