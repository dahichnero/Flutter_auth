import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google/main.dart';
import 'package:flutter_google/signin.dart';

class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context){
    final user=FirebaseAuth.instance.currentUser;
    if (user==null){
      return const SignInMy();
    }
    return const MyHomePage();
  }
}