import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../main/myconfig.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}


class _RegisterState extends State<Register> {

final TextEditingController _nameEditingController = TextEditingController();
final TextEditingController _phoneEditingController = TextEditingController();
final TextEditingController _emailEditingController = TextEditingController();
final TextEditingController _passEditingController = TextEditingController();
final TextEditingController _pass2EditingController = TextEditingController();
bool  _isChecked = false;
final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
         backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(height: 250,color: Colors.transparent, 
          child : Image.asset('assets/images/register.png'),
              // to insert image
          ),
          Card(
            elevation: 8,
            child: Container(
               margin: const EdgeInsets.all(16),
                child: Column(children: [
                  const Text("Registration Form"),
                Form(
                  key : _formKey,
                  child: Column(children: [
                  TextFormField(
                     controller: _nameEditingController,
                     validator: (val) => val!.isEmpty || (val.length < 3)
                     ? "name must be longer than 3"
                     : null,
                     keyboardType: TextInputType.text,
                     decoration: const InputDecoration(
                     labelText: 'Name',
                     labelStyle: TextStyle(
                     ),
                     icon: Icon(Icons.person),
                     focusedBorder: OutlineInputBorder(
                     borderSide:BorderSide( width: 2.0),
                    ))),
                    
                  TextFormField(
                    controller: _phoneEditingController,
                     validator: (val) => val!.isEmpty || (val.length < 10)
                     ? "name must be longer or equal to 10"
                     : null,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                     labelText: 'Phone Number',
                     labelStyle: TextStyle(
                     ),
                     icon: Icon(Icons.phone),
                     focusedBorder: OutlineInputBorder(
                     borderSide:BorderSide( width: 2.0),
                    ))),
                  
                  TextFormField(
                    controller: _emailEditingController,
                    validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")  //! means should 
                    ? "enter a valid email"
                    : null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                     labelText: 'Email',
                     labelStyle: TextStyle(
                     ),
                     icon: Icon(Icons.email),
                     focusedBorder: OutlineInputBorder(
                     borderSide:BorderSide( width: 2.0),
                    ))),
                  
                  TextFormField(
                    controller: _passEditingController,
                     validator: (val) => val!.isEmpty || (val.length < 5)
                     ? "password must be longer 5"
                     : null,
                    obscureText: true,  //to hide password
                    decoration: const InputDecoration(
                     labelText: 'Password',
                     labelStyle: TextStyle(
                     ),
                     icon: Icon(Icons.lock),
                     focusedBorder: OutlineInputBorder(
                     borderSide:BorderSide( width: 2.0),
                    ))),
                  
                  TextFormField(
                    controller: _pass2EditingController,
                     validator: (val) => val!.isEmpty || (val.length < 5)
                     ? "password must be longer 5"
                     : null,
                    obscureText: true,
                    decoration: const InputDecoration(
                     labelText: 'Re-enter Password',
                     labelStyle: TextStyle(
                     ),
                     icon: Icon(Icons.lock),
                     focusedBorder: OutlineInputBorder(
                     borderSide:BorderSide( width: 2.0),
                    ))),
                    const SizedBox(height : 16,
                    ),
               Row(children: [
                Checkbox(
                 value: _isChecked,
                 onChanged: (bool? value) {
                   if (!_isChecked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Terms have been read and accepted.")));
                              }

                 setState(() {
                 _isChecked = value!;
                });
                },
                ),
                GestureDetector(
                  onTap: null, 
                  child: const Text('Agree with terms', 
                  style: TextStyle( 
                    fontSize: 16,
                  fontWeight: FontWeight.bold,
                    )),
                 ),
                  const SizedBox(width : 16, ),
                  Expanded(
                    child: ElevatedButton(
                    onPressed: onRegisterDialog, 
                    child: const Text("Register")))],
                        
                      )
                ]),           
          )
          ]),
          ),
          ),
        
   
        ]),
      ),  
    
    );
  }
  void onRegisterDialog() {
  if (!_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Check you input")));
    return;
   }

  if (!_isChecked) {
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please agree with the terms and condition")));
      return;
  }

  String password = _passEditingController.text;
  String pass2 = _pass2EditingController.text;
  if ( password != pass2 ) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please check your password")));
      return;
  }


   showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",

            style: TextStyle(),
          ),
          content: const Text("Are you sure?",
              style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(
                   
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void registerUser() {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    ); 

   String name  = _nameEditingController.text;
   String email = _emailEditingController.text;
   String phone = _phoneEditingController.text;
   String password  = _passEditingController.text;

   print("Name: " +name+ "\nEmail: " +email+ "\nPhone: " +phone+ "\nPassword: " +password);
   //http.post(Uri.parse("http://172.20.10.3/barter_it/php/register.php"),
   http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/register.php"),

  
        body: {
          "name": name, 
          "email": email, 
          "phone": phone, 
          "password": password,
     
          }).then((response) {
     print(response.body);
 if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
              
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pop(context);
      } 
    });
  }
  

  
 
}