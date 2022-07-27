import 'package:blog_mobile_app/constant.dart';
import 'package:blog_mobile_app/models/apiResponse.dart';
import 'package:blog_mobile_app/models/user.dart';
import 'package:blog_mobile_app/screens/Home.dart';
import 'package:blog_mobile_app/screens/login.dart';
import 'package:blog_mobile_app/services/userServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtConfPassword = TextEditingController();

  void _registerUser() async {
    ApiResponse response =
        await registerUser(txtName.text, txtEmail.text, txtPassword.text);

    if (response.error == null) {
      saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
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
              child: Text('Register'),
            )),
      ),
      body: Form(
          child: ListView(
        padding: EdgeInsets.all(32),
        children: [
          TextFormField(
            controller: txtName,
            validator: (val) => val!.isEmpty ? 'Name Must not be Null' : null,
            decoration: inputDecoration('Name'),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: txtEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (val) => val!.isEmpty ? 'Email Must not be Null' : null,
            decoration: inputDecoration('Email'),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: txtPassword,
            obscureText: true,
            validator: (val) =>
                val!.length < 8 ? 'Password must be at least 8 characters' : null,
            decoration: inputDecoration('Password'),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: txtConfPassword,
            obscureText: true,
            validator: (val) => val != txtPassword.text
                ? 'Confirm Password doesnt correct'
                : null,
            decoration: inputDecoration('Confirmation Password'),
          ),
          SizedBox(
            height: 10,
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : textButton('Register', () {
                  setState(() {
                    loading = false;
                    _registerUser();
                  });
                }),
          loginRegisterHint('Login', 'Already Have an Account? ', () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false);
          })
        ],
      )),
    );
  }
}
