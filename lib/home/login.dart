// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, avoid_print, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'student/student_home.dart';
import 'teacher/teacher_home.dart';

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return SignIn();
          }
          return userRoleBasedPage(user);
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Center(
              child: SpinKitWave(
                color: Colors.cyan,
                size: 25,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget userRoleBasedPage(User user) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('User').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic>? userData =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (userData != null && userData.containsKey('role')) {
              String role = userData['role'];

              if (role == 'student') {
                return StudentHomePage();
              } else if (role == 'teacher') {
                return TeacherHomePage();
              }
            }
          }
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Center(
              child: SpinKitWave(
                color: Colors.cyan,
                size: 25,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _showLogin = true;

  void _toggleForm() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(
          height: double.infinity,
          width: double.infinity,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboarding.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: BlurryContainer(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            width: 300,
            height: 500,
            blur: 5,
            child: Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _showLogin
                    ? LoginForm(_toggleForm)
                    : RegisterForm(_toggleForm),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  final Function _toggleForm;
  LoginForm(this._toggleForm);

  Future<void> _loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("User logged in successfully!");
    } catch (e) {
      print("Error during login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: loginEmailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: loginPasswordController,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _loginUser(
                    loginEmailController.text, loginPasswordController.text),
                child: const Text("Login"),
              ),
            ],
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            _toggleForm();
          },
          child: Text('Don\'t have an account? Register here'),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  final Function _toggleForm;
  RegisterForm(this._toggleForm);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  String selectedSex = "Male";

  Future<void> _registerUser(
    String email,
    String password,
    String role,
    String name,
    String sex,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store role information in Firestore
      await FirebaseFirestore.instance
          .collection('User')
          .doc(userCredential.user?.uid)
          .set({
        'uid': userCredential.user?.uid,
        'email': email,
        'role': role,
        'name': name,
        'sex': sex,
      });

      print("User registered successfully!");
    } catch (e) {
      print("Error during registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: roleController,
                decoration:
                    const InputDecoration(labelText: "Role (student/teacher)"),
              ),
              DropdownButton<String>(
                value: selectedSex,
                onChanged: (value) => setState(() => selectedSex = value!),
                items: ["Male", "Female"].map((sex) {
                  return DropdownMenuItem<String>(
                    value: sex,
                    child: Text(sex),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _registerUser(
                    emailController.text,
                    passwordController.text,
                    roleController.text,
                    nameController.text,
                    selectedSex,
                  );

                  // Reset the registration form fields after registration
                  emailController.clear();
                  passwordController.clear();
                  nameController.clear();
                  roleController.clear();
                  setState(() {
                    selectedSex = "Male";
                  });
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            widget._toggleForm();
          },
          child: Text('Already have an account? Login here'),
        ),
      ],
    );
  }
}
