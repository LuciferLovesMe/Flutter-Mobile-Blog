// BASE URL
import 'package:flutter/material.dart';

const baseURL = 'http://192.168.1.195:8000/api';

// AUTH URL
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURl = baseURL + '/logout';
const userURL = baseURL + '/user';

// POSTS URL
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';

// STRINGS
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something Went Wrong';

InputDecoration inputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1)));
}

TextButton textButton(String text, Function onPressed) {
  return TextButton(
    child: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
  );
}

Row loginRegisterHint(String label, String text, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text, ),
      GestureDetector(
        child: Text(label, style: TextStyle(color: Colors.blue),),
        onTap: () => onTap(),
      )
    ],
  );
}
