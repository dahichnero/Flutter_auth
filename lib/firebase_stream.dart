
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google/home.dart';
import 'package:flutter_google/verif.dart';

class FirebaseStream extends StatelessWidget{
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context,snapshot){
        if (snapshot.hasError){//ощибки
          return const Scaffold(
            body: Center(
              child: Text("Oh something gets wrong"),
            ),
          );
        }
        else if (snapshot.hasData){
          if (!snapshot.data!.emailVerified){//верификация не удалась
            return const Verify();//тут должен быть экран с верификацией
          }
          return const Home();//тут должен быть домашний экран
        }
        else{//верификация удалась
          return const Home();//тут должен быть домашний экран
        }
      }
    );
  }
}