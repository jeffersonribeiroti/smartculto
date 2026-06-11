class UserModel {
  final String name;
  final String church;
  final String email;
  final String password;
  final String role; // 'admin' ou 'recepcionista'

  UserModel({
    required this.name,
    required this.church,
    required this.email,
    required this.password,
    required this.role,
  });
}
