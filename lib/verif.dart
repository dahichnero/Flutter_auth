import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google/home.dart';
import 'package:flutter_google/snacks.dart';

class Verify extends StatefulWidget{
  const Verify({super.key});

  @override
  State<Verify> createState()=>_VarifyState();
}

class _VarifyState extends State<Verify> {
  bool isEmailVerify=false;
  bool canResendEmail=false;
  Timer? timer;

  @override
  void initState(){
    super.initState();
    isEmailVerify=FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerify){
      sendVerify();
      timer=Timer.periodic(const Duration(seconds: 3), (_)=>checkVerify());
    }
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkVerify() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerify=FirebaseAuth.instance.currentUser!.emailVerified;
    });
    print(isEmailVerify);
    if (isEmailVerify) timer?.cancel();
  }

  Future<void> sendVerify() async{
    try{
      final user=FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail=false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail=true;
      });
    } catch (q){
      print(q);
      if (mounted){
        Snacks.itSnack(context, '$q', true);
      }
    }
  }

  Widget build(BuildContext context)=>isEmailVerify ? const Home() :Scaffold(
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Почтааааааа"),
        const SizedBox(height: 20,),
        ElevatedButton.icon(onPressed: canResendEmail ? sendVerify : null, label: const Text('Отправить заново'), icon: const Icon(Icons.email),),
        TextButton(onPressed: () async {
          timer?.cancel();
          await FirebaseAuth.instance.currentUser!.delete();
        }, child: const Text('Отменить'))
      ],
    ),),),
  );
  
}