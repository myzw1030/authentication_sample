import 'package:authentication_sample/common/validation.dart';
import 'package:authentication_sample/pages/components/animated_error_message.dart';
import 'package:authentication_sample/pages/components/auth_text_form_field.dart';
import 'package:authentication_sample/pages/components/submit_button.dart';
import 'package:authentication_sample/pages/home_page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
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

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _setErrorMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _setErrorMessage('Wrong password provided for that user.');
      } else {
        _setErrorMessage('Unidentified error occurred while signing in.');
      }
    }
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // サインイン処理
      final UserCredential? user = await signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // 画面が破棄されている場合後続処理を行わない
      if (!mounted) return;

      // サインイン後ホームページへ
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
            'Sign In',
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
            onChanged: (value) => _clearErrorMessage(),
            labelText: 'Email',
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          AuthTextFormField(
            controller: _passwordController,
            onChanged: (value) => _clearErrorMessage(),
            labelText: 'Password',
            validator: validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          SubmitButton(
            labelName: 'サインイン',
            onTap: () => _submit(context),
          ),
        ],
      ),
    );
  }
}
