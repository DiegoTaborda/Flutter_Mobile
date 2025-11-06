class AppUser {
  final String id;
  final String nome;
  final String email;
  final int idade;

  AppUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.idade,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      idade: map['idade'],
    );
  }
}