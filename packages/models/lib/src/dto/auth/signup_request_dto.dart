import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'signup_request_dto.g.dart';

@CopyWith()
class SignupRequestDTO extends Equatable {
  const SignupRequestDTO({
    required this.email,
    required this.username,
    required this.password,
  });

  final String email;
  final String username;
  final String password;

  @override
  List<Object?> get props => [email, username, password];
}
