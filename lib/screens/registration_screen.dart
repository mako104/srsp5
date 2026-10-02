import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../widgets/custom_text_field.dart';
import 'user_info_screen.dart';

class RegistrationScreen extends StatefulWidget { //динамичный виджет
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>(); //объединение полей ввода и запрос на валидность
  final StorageService _storageService = StorageService();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() { //очистка локальной памяти
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _storyFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) { //передача через ентер
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _submitForm() async {
     if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = UserModel( //удаление пробелов
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        story: _storyController.text.trim(),
      );

      await _storageService.saveUser(user);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(user: user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Full Name
              CustomTextField(
                controller: _nameController,
                focusNode: _nameFocus,
                labelText: 'Имя *',
                prefixIcon: Icons.person,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.pinkAccent),
                  onPressed: () => _nameController.clear(),
                ),
                onFieldSubmitted: (_) => _fieldFocusChange(context, _nameFocus, _phoneFocus),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Имя не может быть пустым' : null,
              ),
              const SizedBox(height: 16),

              // 2. Phone Number
              CustomTextField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                labelText: 'Номер телефона *',
                helperText: 'Формат ввода: XXXXXXXXXX',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.pinkAccent),
                  onPressed: () => _phoneController.clear(),
                ),
                onFieldSubmitted: (_) => _fieldFocusChange(context, _phoneFocus, _emailFocus),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Введите номер телефона' : null,
              ),
              const SizedBox(height: 16),

              // 3. Email Address
              CustomTextField(
                controller: _emailController,
                focusNode: _emailFocus,
                labelText: 'Почта',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) => _fieldFocusChange(context, _emailFocus, _storyFocus),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Email не может быть пустым';
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(val.trim())) return 'Введите корректный email адрес';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Life Story
              CustomTextField(
                controller: _storyController,
                focusNode: _storyFocus,
                labelText: 'О себе',
                helperText: 'Кратко, но по делу.',
                maxLines: 3,
                maxLength: 100,
                onFieldSubmitted: (_) => _fieldFocusChange(context, _storyFocus, _passwordFocus),
              ),
              const SizedBox(height: 16),

              // 5. Password
              CustomTextField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                labelText: 'Пароль *',
                prefixIcon: Icons.security,
                obscureText: _hidePassword,
                maxLength: 8,
                suffixIcon: IconButton(
                  icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off, color: Colors.pinkAccent),
                  onPressed: () => setState(() => _hidePassword = !_hidePassword),
                ),
                onFieldSubmitted: (_) => _fieldFocusChange(context, _passwordFocus, _confirmPasswordFocus),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Пароль не может быть пустым';
                  if (val.length < 6) return 'Длина пароля должна быть не менее 6 символов';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 6. Confirm Password
              CustomTextField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                labelText: 'Повторите пароль *',
                prefixIcon: Icons.edit,
                obscureText: _hideConfirmPassword,
                maxLength: 8,
                textInputAction: TextInputAction.done,
                suffixIcon: IconButton(
                  icon: Icon(_hideConfirmPassword ? Icons.visibility : Icons.visibility_off, color: Colors.pinkAccent),
                  onPressed: () => setState(() => _hideConfirmPassword = !_hideConfirmPassword),
                ),
                onFieldSubmitted: (_) => _submitForm(),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Подтвердите пароль';
                  if (val != _passwordController.text) return 'Пароли не совпадают';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Зарегистрироваться', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}