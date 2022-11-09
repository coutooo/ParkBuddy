import 'package:flutter/material.dart';
import 'package:parkbuddy/Screens/main_page.dart';
import '../../helpers/biometric_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
