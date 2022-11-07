import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkbuddy/Screens/Welcome/register_page.dart';
import 'package:parkbuddy/Screens/main_page.dart';
import 'package:parkbuddy/Screens/qr_page.dart';
import 'package:local_auth/local_auth.dart';
import '../../helpers/biometric_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    //await FirebaseAuth.instance.signInWithEmailAndPassword(
    //email: _emailController.text.trim(),
    //password: _passwordController.text.trim(),
    //);
  }

  bool showBiometric = false;
  bool isAuthenticated = false;

  @override
  void initState() {
    isBiometricsAvailable();
    super.initState();
  }

  isBiometricsAvailable() async {
    showBiometric = await BiometricHelper().hasEnrolledBiometrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Transform.scale(
                scale: 0.75,
                child: Image(
                  image: AssetImage(
                    'assets/images/logo-no-background.png',
                  ),
                ),
              ),
              SizedBox(
                height: 75,
              ),

              // text
              Text(
                "Welcome",
                //style: GoogleFonts.bebasNeue(
                //  fontSize: 52,
                //),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Park with us!",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 50,
              ),

              // sign in button
              if (showBiometric)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () async {
                      isAuthenticated = await BiometricHelper().authenticate();
                      setState(() {});
                      if (isAuthenticated) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => MainPage())));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(160, 5, 10, 40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            isAuthenticated =
                                await BiometricHelper().authenticate();
                            setState(() {});
                            if (isAuthenticated) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => MainPage())));
                            }
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (!showBiometric)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MainPage())));
                    },
                    child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(160, 5, 10, 40),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => MainPage())));
                          },
                          child: Text('Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ))),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
