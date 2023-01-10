import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organ_temperature_monitoring/views/dashboardMain.dart';

import 'newuser.dart';

class loginPage extends StatelessWidget {
  const loginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = TextEditingController();
    final pass = TextEditingController();
    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    void login() async {
      try {
        //to dismiss keyboard when button pressed
        FocusScope.of(context).requestFocus(new FocusNode());
        await FirebaseFirestore.instance
            .collection("users")
            .where("userId", isEqualTo: user.text)
            .limit(1)
            .get()
            .then(
          (value) async {
            if (value.docs.isEmpty) {
              throw Exception("Login Error");
            } else {
              String email = value.docs[0]['emailID'];

              await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email, password: pass.text);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DashboardMain(),
                ),
              );
            }
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

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
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/splash.png'),
            const Text(
              'ORGAN TRANSPORT MONITORING SYSTEM',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: user,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: Colors.white,
                        hintText: 'Username:',
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: pass,
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: Colors.white,
                        hintText: 'Password:',
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18)),
                      onPressed: () {
                        login();
                      },
                      child: const Text('LOGIN'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an Account..?",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      newUser()));
                        },
                        child: const Text('Register Here!'),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            primary: Color.fromARGB(255, 66, 24, 233)),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        // backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_error1(BuildContext context, String s) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: const EdgeInsets.all(25),
        height: 110,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 194, 65, 65),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "FAILED",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    s,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
