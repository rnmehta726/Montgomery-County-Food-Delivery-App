import 'package:flutter/material.dart';
import 'clientList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String username = '';
  String password = '';
  String message = '';
  bool value = false;
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final Map _login = getData();

    final emailField = TextField(
      controller: _usernameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onChanged: (value) => username = value,
    );

    final passwordField = TextField(
      controller: _passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onChanged: (value) => password = value,
    );

    void clearTextInput() {
      passwordField.controller.clear();
      emailField.controller.clear();
    }

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_login.keys.toList().contains(username) && _login[username]['password'] == password) {// Checking for password
              if (value == true) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('username', username);
                prefs.setString('password', _login[username]['password']);
                prefs.setString('name', _login[username]['name']);
                prefs.setInt('id', _login[username]['id']);
              }

              clearTextInput();
              _pushList(_login[username]['name'], _login[username]['id']); // sending name and id of volunteer
              username = '';
              password = '';

              if (message != "") {
                setState(() {
                  message = '';
                });
              }
          }
          else {
            setState(() {
              message = "Invalid Login Credentials!";
            });
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: true,
          title: Text("MCFB")
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: new ListView(
              children: <Widget> [
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/mcfb_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 75.0),
                emailField,
                SizedBox(height: 20.0),
                passwordField,
                SizedBox(height: 5.0),
                Row(children: [
                  Text("Remember Me"),
                  Checkbox(
                    value: value,
                    onChanged: (bool val){
                      setState(() {
                        value = val;
                      });
                    },
                  )],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 5.0),
                loginButton,
                SizedBox(height:20.0),
                Center(child: Text(message,
                    style: TextStyle(color: Colors.red))
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map getData() {
    var info = {};
    Firestore.instance.collection('volunteers').getDocuments().then((QuerySnapshot querySnapshot) {
      querySnapshot.documents.forEach((result) {
        info[result.data['username']] = {'id' : result.data['id'], 'name': result.data['name'], 'password': result.data['password']};
      });
    });
    return info;
  }

  _pushList(String user, int id) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return ClientList(volName: user, volId: id);
            }
        )
    );
  }
}