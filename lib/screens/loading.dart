import 'package:blog_mobile_app/constant.dart';
import 'package:blog_mobile_app/models/apiResponse.dart';
import 'package:blog_mobile_app/services/userServices.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadInfoUser() async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
      ApiResponse apiResponse = await getUserDetail();
      if (apiResponse.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else if (apiResponse.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
      }
    }
  }

  @override
  void initState() {
    _loadInfoUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
