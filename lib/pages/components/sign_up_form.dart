import 'package:authentication_sample/common/validation.dart';
import 'package:authentication_sample/pages/components/animated_error_message.dart';
import 'package:authentication_sample/pages/components/auth_text_form_field.dart';
import 'package:authentication_sample/pages/components/submit_button.dart';
import 'package:authentication_sample/pages/home_page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  void _setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _setErrorMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _setErrorMessage('The account already exists for that email.');
      } else {
        _setErrorMessage('Unidentified error occurred while signing up.');
      }
    }
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // サインアップ処理
      final UserCredential? user = await signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (user != null) {
        Future.delayed(
          const Duration(milliseconds: 300),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedErrorMessage(errorMessage: errorMessage),
          const SizedBox(height: 16),
          AuthTextFormField(
            controller: _emailController,
            labelText: 'Email',
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          AuthTextFormField(
            controller: _passwordController,
            labelText: 'Password',
            validator: validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AuthTextFormField(
            obscureText: true,
            validator: (value) => validateConfirmPassword(
              value,
              _passwordController.text,
            ),
            labelText: 'Confirm Password',
          ),
          const SizedBox(height: 16),
          SubmitButton(
            labelName: '新規登録',
            onTap: () => _submit(context),
          ),
        ],
      ),
    );
  }
}
