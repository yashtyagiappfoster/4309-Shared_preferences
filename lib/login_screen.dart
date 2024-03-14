import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app_shared_prefrences/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static const String LOGINKEY = "Login";

  late bool userLoggedIn;

  getLoggedInState() async {
    var prefs = await SharedPreferences.getInstance();
    var value = prefs.getBool(LOGINKEY);

    if (value != null) {
      if (value) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  bool passwordVisible = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  void login(String email, String password) async {
    try {
      var response = await http.post(Uri.parse('https://reqres.in/api/login'),
          body: {'email': 'eve.holt@reqres.in', 'password': 'cityslicka'});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print('Login successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged in Successfully'),
          ),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(LOGINKEY, true);
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void resetFields() {
    emailController.text = '';
    passwordController.text = '';
    _formkey = GlobalKey<FormState>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: resetFields,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 25, right: 25),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset(
                    'assets/images/login.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Welcome to Login Screen',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Email',
                    hintText: 'Enter your email address...',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !(value.contains('@'))) {
                      return 'Please enter the valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: passwordVisible,
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      icon: Icon(passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter your password...',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty || (value.length < 6)) {
                      return 'Please enter the valid or atleast 6 digit long password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formkey.currentState!.validate()) {
                      login(emailController.text.toString(),
                          passwordController.text.toString());
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController nameController = TextEditingController();

//   static const String KEYNAME = "name";
//   var nameValue = "No Value is Saved";

//   @override
//   void initState() {
//     super.initState();
//     getValue();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shared Preferences'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding:
//               const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     borderSide: const BorderSide(color: Colors.blueGrey),
//                   ),
//                   labelText: 'Enter input data',
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   var name = nameController.text.toString();
//                   var prefs = await SharedPreferences.getInstance();

//                   prefs.setString(KEYNAME, name);
//                 },
//                 child: const Text('Save'),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Text(nameValue),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void getValue() async {
//     var prefs = await SharedPreferences.getInstance();

//     var getName = prefs.getString(KEYNAME);
//     nameValue = getName ?? "";
//     setState(() {});
//   }
// }
