class UserModel {
  final String name;
  final String church;
  final String email;
  String password;
  final String role; // 'admin' ou 'recepcionista'

  UserModel({
    required this.name,
    required this.church,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'church': church,
        'email': email,
        'password': password,
        'role': role,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      church: json['church'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'recepcionista',
    );
  }
}
