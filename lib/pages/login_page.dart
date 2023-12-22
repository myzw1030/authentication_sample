import 'package:authentication_sample/pages/components/sign_in_form.dart';
import 'package:authentication_sample/pages/components/sign_up_form.dart';
import 'package:flutter/material.dart';

enum AuthLoginType {
  signIn,
  signUp;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthLoginType loginType = AuthLoginType.signIn;
  String buttonLabel = '新規登録へ';

  void switchLoginType() {
    setState(() {
      loginType = loginType == AuthLoginType.signIn
          ? AuthLoginType.signUp
          : AuthLoginType.signIn;

      buttonLabel = loginType == AuthLoginType.signIn ? '新規登録へ' : 'サインイン';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loginType == AuthLoginType.signIn
                  ? const SignInForm()
                  : const SignUpForm(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: switchLoginType,
                child: Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
