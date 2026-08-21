import 'package:equatable/equatable.dart';

class AuthResultModel extends Equatable {
  const AuthResultModel({
    required this.success,
    this.token,
    this.userId,
    this.errorMessage,
  });

  final bool success;
  final String? token;
  final String? userId;
  final String? errorMessage;

  @override
  List<Object?> get props => [success, token, userId, errorMessage];
}
