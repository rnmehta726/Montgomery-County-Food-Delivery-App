import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'mainNav.dart';
import 'package:flutter/services.dart';
import 'login_ui/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  String _username = '';
  String _password = '';
  String _message = '';
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  Widget _buildEmailTF() {
    final _emailField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _usernameController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) => _username = value,
          ),
        ),
      ],
    );
    return _emailField;
  }

  Widget _buildPasswordTF() {
    final _passwordField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) => _password = value,
          ),
        ),
      ],
    );
    return _passwordField;
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    Map _login = getData();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_login.keys.toList().contains(_username) && _login[_username]['password'] == _password) {// Checking for password
            if (_rememberMe == true) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('username', _username);
              prefs.setString('password', _login[_username]['password']);
              prefs.setString('name', _login[_username]['name']);
              prefs.setInt('id', _login[_username]['id']);
            }

            _pushList(_login[_username]['name'], _login[_username]['id']); // sending name and id of volunteer
            _username = '';
            _password = '';

            if (_message != "") {
              setState(() {
                _message = '';
              });
            }
          }
          else {
            setState(() {
              _message = "Invalid Login Credentials!";
            });
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF689F38),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Map getData() {
    var info = {};
    Firestore.instance.collection('volunteers').getDocuments().then((
        QuerySnapshot querySnapshot) {
      querySnapshot.documents.forEach((result) {
        info[result.data['username']] = {
          'id': result.data['id'],
          'name': result.data['name'],
          'password': result.data['password']
        };
      });
    });
    return info;
  }

  _pushList(String user, int id) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return J(vName: user, vid: id);
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF9CCC65),
                      Color(0xFF8BC34A),
                      Color(0xFF689F38),
                      Color(0xFF33691E),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(height: 14.0,),
                      _buildPasswordTF(),
                      _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      SizedBox(height: 14.0,),
                      RichText(
                        text: TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans', fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('sign up');
                              }),
                      ),
                      SizedBox(height: 14.0,),
                      Text(_message, style: TextStyle(color: Colors.redAccent),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
