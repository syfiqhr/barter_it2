import 'dart:async';
import 'dart:convert';
import 'package:barter_it2/screens/profilescreen/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../main/myconfig.dart';
import '../../models/user.dart';
import '../../main/mainscreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailEC = TextEditingController();
  final TextEditingController passEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [

          SizedBox(
              height: screenHeight * 0.40,
              width: screenWidth,
              child: Image.asset(
                "assets/images/login.png",
                fit: BoxFit.cover,
              )),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          controller: emailEC,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "enter a valid email"
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: passEC,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.red,
                            value: _isChecked,
                            onChanged: (bool? value) {
                              saveremovepref(value!);
                              setState(() {
                                _isChecked = value;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: null,
                              child: const Text('Remember Me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: screenWidth / 3,
                            height: 50,
                            elevation: 10,
                            onPressed: onLogin,
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onError,
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ]),
                  )
                ]),
              ),
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: _goToRegister,
            child: const Text(
              "New User? Register here",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: _forgotDialog,
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      )),
    );
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    String email = emailEC.text;
    String pass = passEC.text;
    //print(pass);
    try {
      http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/login_user.php"),
          body: {
            "email": email,
            "password": pass,
          }).then((response) {
        //print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(user: user)
                      ));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Failed")));
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {
        // Time has run out, do what you wanted to do.
      });
    } on TimeoutException catch (_) {
      //print("Time out");
    }
  }

  void _forgotDialog() {}

  void _goToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const Register()));
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = emailEC.text;
    String password = passEC.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool("checkbox", value);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        emailEC.text = '';
        passEC.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      setState(() {
        emailEC.text = email;
        passEC.text = password;
      });
    }
  }
}