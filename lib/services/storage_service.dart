import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService { //локальная бд
  static const String _keyName = 'full_name';
  static const String _keyPhone = 'phone_number';
  static const String _keyEmail = 'email';
  static const String _keyStory = 'life_story';

//ассинхронность записей
   Future saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, user.fullName);
    await prefs.setString(_keyPhone, user.phone);
    await prefs.setString(_keyEmail, user.email);
    return await prefs.setString(_keyStory, user.story);
  }

   Future getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName);
    if (name == null) return null;

    return UserModel(
      fullName: name,
      phone: prefs.getString(_keyPhone) ?? '',
      email: prefs.getString(_keyEmail) ?? '',
      story: prefs.getString(_keyStory) ?? '',
    );
  }
}