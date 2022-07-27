import 'package:blog_mobile_app/constant.dart';
import 'package:blog_mobile_app/models/apiResponse.dart';
import 'package:blog_mobile_app/screens/Home.dart';
import 'package:blog_mobile_app/screens/register.dart';
import 'package:blog_mobile_app/services/userServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void loginUser() async {
    ApiResponse apiResponse = await login(txtEmail.text, txtPassword.text);
    if (apiResponse.error == null) {
      saveAndRedirectToHome(apiResponse.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
    }
  }

  void saveAndRedirectToHome(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token ?? '');
    await prefs.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Title(
              color: Colors.white,
              child: Center(
                child: Text("Login"),
              )),
        ),
        body: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: txtEmail,
                  validator: (val) =>
                      val!.isEmpty ? 'Invalid Email Address' : null,
                  decoration: inputDecoration('Email')),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: txtPassword,
                  obscureText: true,
                  validator: (val) =>
                      val!.isEmpty ? 'Password at Least has 8 Characters' : null,
                  decoration: inputDecoration('Password')),
              SizedBox(
                height: 10,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : textButton('Login', () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          loginUser();
                        });
                      }
                    }),
              SizedBox(
                height: 10,
              ),
              loginRegisterHint('Register', 'Dont Have an Account? ', () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Register()),
                    (route) => false);
              })
            ],
        )));
  }
}
