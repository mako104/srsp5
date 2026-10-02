import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class UserInfoScreen extends StatefulWidget {
  final UserModel user;

  const UserInfoScreen({super.key, required this.user});

@override
State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final StorageService _storageService = StorageService();
 
  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future _loadStoredData() async {
    final savedUser = await _storageService.getUser();
    if (savedUser != null) {
      setState(() {
       });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.pinkAccent),
                  title: const Text('Имя'),
                  subtitle: Text(widget.user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.pinkAccent),
                  title: const Text('Номер телефона'),
                  subtitle: Text(widget.user.phone, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.pinkAccent),
                  title: const Text('Почта'),
                  subtitle: Text(widget.user.email, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                if (widget.user.story.isNotEmpty) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.history_edu, color: Colors.pinkAccent),
                    title: const Text('О себе'),
                    subtitle: Text(widget.user.story),
                  ),
                ],

              ],
            ),
          ),
        ),
      ),
    );
  }
}