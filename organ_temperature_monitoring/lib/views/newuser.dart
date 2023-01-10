import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class newUser extends StatefulWidget {
  const newUser({super.key});

  @override
  State<newUser> createState() => _newUserState();
}

class _newUserState extends State<newUser> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final emailiD = TextEditingController();
  final userId = TextEditingController();
  final password = TextEditingController();
  var registeredNodes = ['Node 1', 'Node 2'];
  String dropDownValue = 'Node 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          title: const Text('Create Account'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent),
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
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Create your new account here...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20, bottom: 8, right: 8, left: 8),
              child: TextField(
                controller: firstName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'First Name',
                  fillColor: Colors.white,
                  filled: true,
                  // errorText: 'Enter First Name!!',

                  //focusedBorder:
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: lastName,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Last Name',
                  // errorText: 'Enter Last Name!!',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: userId,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'user ID',
                  border: OutlineInputBorder(),
                  // errorText: 'Enter proper EmailId!!!',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailiD,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email ID',
                  border: OutlineInputBorder(),
                  // errorText: 'Enter proper EmailId!!!',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: password,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Password',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  // errorText: 'Enter Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Node',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Oswald'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: DropdownButton(
                      value: dropDownValue,

                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: registeredNodes.map((String registeredNodes) {
                        return DropdownMenuItem(
                          value: registeredNodes,
                          child: Text(
                            registeredNodes,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      style: const TextStyle(
                        color: Colors.lightBlue,
                      ),
                      focusColor: Colors.black87,
                      dropdownColor: Colors.black87,
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (password.text.length < 8) {
                    _error1(
                        context, 'Password should be more than 8 characters');
                  } else {
                    if (firstName.text != '' &&
                        lastName.text != '' &&
                        emailiD.text != '' &&
                        userId.text != '' &&
                        password.text != '') {
                      createUser(
                          firstName: firstName.text,
                          lastName: lastName.text,
                          emailiD: emailiD.text,
                          userId: userId.text,
                          dropDownValue: dropDownValue);
                      final FirebaseAuth _auth = FirebaseAuth.instance;

                      try {
                        await _auth.createUserWithEmailAndPassword(
                          email: emailiD.text,
                          password: password.text,
                        );
                        return null;
                      } on FirebaseAuthException catch (e) {
                        _error1(context, e.toString());
                        // print(e.message);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const loginPage()));
                    } else {
                      _error1(context, 'Fields can\'t have null value...!');
                    }
                  }
                  firstName.clear();
                  lastName.clear();
                  emailiD.clear();
                  password.clear();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

createUser(
    {required String firstName,
    required String lastName,
    required String emailiD,
    required String userId,
    required dropDownValue}) async {
  final docuser = FirebaseFirestore.instance.collection('users').doc();
  final json = {
    'id': docuser.id,
    'emailID': emailiD,
    'firstName': firstName,
    'lastName': lastName,
    'userId': userId,
    'node': dropDownValue
  };
  await docuser.set(json);
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
