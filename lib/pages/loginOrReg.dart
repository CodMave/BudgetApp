import 'package:budgettrack/pages/LoginPage.dart';
import 'package:budgettrack/pages/registerPage.dart';
import 'package:flutter/widgets.dart';

class LoginOrRegiter extends StatefulWidget {
  const LoginOrRegiter({super.key});

  @override
  State<StatefulWidget> createState() => _LoginOrRegiterState();
}

class _LoginOrRegiterState extends State<LoginOrRegiter> {
  // initals show login page
  bool showLoginPage = true;

  // switch between login and register
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
