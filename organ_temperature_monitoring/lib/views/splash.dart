import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organ_temperature_monitoring/views/dashboardMain.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool isLoggedIn;
  @override
  void initState() {
    isLoggedIn = false;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() => isLoggedIn = true);
    });
    // FirebaseAuth.instance.currentUser.then((user) => user != null
    //     ? setState(() {
    //         isLoggedIn = true;
    //       })
    //     : null);
    gologin();
    super.initState();
    // new Future.delayed(const Duration(seconds: 2));
  }

  gologin() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            (isLoggedIn == true) ? const DashboardMain() : const loginPage(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.black,
              Colors.black87,
              Color.fromARGB(255, 21, 101, 192)
            ])),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/splash.png'),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'ORGAN TRANSPORT MONITORING SYSTEM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
