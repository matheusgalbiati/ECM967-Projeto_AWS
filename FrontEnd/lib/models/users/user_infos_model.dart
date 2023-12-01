class UserInfos {
  String userEmail;
  String senha;
  String userPhoto;

  UserInfos({
    required this.userEmail,
    required this.senha,
    required this.userPhoto,
  });

  factory UserInfos.fromJson(Map<String, dynamic> json) {
    return UserInfos(
      userEmail: json['PK'].replaceAll('USERS#', ''),
      senha: json['senha'],
      userPhoto: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_email': userEmail,
      'senha': senha,
    };
  }
}
