class UserModel {
  final String fullName;
  final String phone;
  final String email;
  final String story;

  UserModel({ //обязательные поля
    required this.fullName,
    required this.phone,
    required this.email,
    required this.story,
  });

   Map toMap() {
    return {
      'full_name': fullName,
      'phone_number': phone,
      'email': email,
      'life_story': story,
    };
  }

   factory UserModel.fromMap(Map map) {
    return UserModel(
      fullName: map['full_name'] ?? '',
      phone: map['phone_number'] ?? '',
      email: map['email'] ?? '',
      story: map['life_story'] ?? '',
    );
  }
}