import 'package:equatable/equatable.dart';

class CountryCodeModel extends Equatable {
  const CountryCodeModel({
    required this.countryName,
    required this.code,
    required this.flagEmoji,
    required this.phoneLength,
  });

  final String countryName;
  final String code;
  final String flagEmoji;
  final int phoneLength;

  @override
  List<Object?> get props => [countryName, code, flagEmoji, phoneLength];
}
