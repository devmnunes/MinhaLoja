import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loja/components/auth_form.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromRGBO(0, 0, 0, 0.878),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 70,
                  ),
                  // cascade operator
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 0, 0, 0),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(7, 7),
                      ),
                    ],
                  ),
                  child: const Text(
                    'HIGH DROP',
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(4, 4),
                          blurRadius: 2,
                        ),
                      ],
                      fontSize: 45,
                      fontFamily: 'Anton',
                      color: Colors.white,
                    ),
                  ),
                ),
                const AuthForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


