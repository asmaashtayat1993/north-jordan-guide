import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';
import '../services/user_server.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isChecked = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---- Validators ----
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال $fieldName';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final requiredError = _validateRequired(value, 'البريد الإلكتروني');
    if (requiredError != null) return requiredError;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'كلمة المرور 8 أحرف على الأقل';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    return value != _passwordController.text ? 'الكلمتان غير متطابقتين' : null;
  }

  // ---- Dialog ----
  void _showResultDialog(String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final statusColor =
            isSuccess ? context.color.secondary : context.color.error;
        return AlertDialog(
          backgroundColor: context.color.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: statusColor, width: 2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSuccess ? '✓ نجاح' : '✗ تنبيه',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.color.onSurface,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (isSuccess) {
                    // Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Text(
                  'حسناً',
                  style: TextStyle(
                    color: isSuccess
                        ? context.color.onSecondary
                        : context.color.onError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ---- Submit logic ----
  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isChecked) {
      _showResultDialog('يرجى الموافقة على الشروط أولاً', false);
      return;
    }

    setState(() => _isLoading = true);

    final UserModel? newUser = await _userService.signUpWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      role: 'user',
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (newUser != null) {
      _showResultDialog('تم إنشاء الحساب بنجاح!', true);
    } else {
      _showResultDialog(
        'حدث خطأ! قد يكون البريد مستخدماً أو كلمة المرور ضعيفة.',
        false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryContainer,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: context.color.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _nameController,
                  label: 'الاسم الكامل',
                  hint: 'أدخل الاسم الكامل',
                  prefixIcon: Icons.person_outline,
                  validator: (v) => _validateRequired(v, 'الاسم الكامل'),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  hint: 'أدخل البريد الإلكتروني',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _phoneController,
                  label: 'رقم الهاتف',
                  hint: 'أدخل رقم الهاتف',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => _validateRequired(v, 'رقم الهاتف'),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  hint: '********',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'تأكيد كلمة المرور',
                  hint: '********',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'أوافق على شروط الاستخدام وسياسة الخصوصية',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: context.color.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: _isChecked,
                      activeColor: context.color.primary,
                      onChanged: (value) {
                        setState(() => _isChecked = value ?? false);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: _isLoading
                      ? CircularProgressIndicator(color: context.color.primary)
                      : CustomButton(
                          text: 'إنشاء حساب',
                          onPressed: _createAccount,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}