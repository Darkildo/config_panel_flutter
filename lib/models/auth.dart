class LoginRequest {
  final String login;
  final String password;

  const LoginRequest({required this.login, required this.password});
}

class RegisterRequest {
  final String login;
  final String password;

  const RegisterRequest({required this.login, required this.password});
}

class AuthResponse {
  final String token;

  const AuthResponse({required this.token});
}

class User {
  final int id;
  final String login;
  final DateTime createdAt;

  const User({required this.id, required this.login, required this.createdAt});
}

class GetUserRequest {
  final int id;

  const GetUserRequest({required this.id});
}

class ListUsersRequest {
  final String loginSearch;

  const ListUsersRequest({this.loginSearch = ''});
}

class ListUsersResponse {
  final List<User> users;

  const ListUsersResponse({required this.users});
}

class UpdateUserRequest {
  final int id;
  final String? login;
  final String? password;

  const UpdateUserRequest({required this.id, this.login, this.password});
}

class DeleteUserRequest {
  final int id;

  const DeleteUserRequest({required this.id});
}
