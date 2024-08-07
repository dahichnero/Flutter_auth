
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google/main.dart';
import 'package:flutter_google/snacks.dart';

class NewPass extends StatefulWidget{
  const NewPass({super.key});

  @override
  State<NewPass> createState()=>_NewPassState();
}

class _NewPassState extends State<NewPass> {
  TextEditingController emailText=TextEditingController();
  final formKey=GlobalKey<FormState>();

  @override
  void dispose(){
    emailText.dispose();
    super.dispose();
  }

  Future<void> newPassPost() async{
    final scaffoldMessenger=ScaffoldMessenger.of(context);
    final isValid=formKey.currentState!.validate();
    if (!isValid) return;
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailText.text.trim());
    } on FirebaseAuthException catch (q){
      print(q.code);
      if (q.code=='user-not-found'){
        Snacks.itSnack(
          context,
          'Такого пользователя нет в бд',
          true
        );
        return;
      }
      else{
        Snacks.itSnack(context, 'Сложный вопрос... Не знаем как решить', true);
        return;
      }
    }
    const snacks=SnackBar(content: Text('Сброс пароля осуществлён'), backgroundColor: Colors.lightGreen,);
    scaffoldMessenger.showSnackBar(snacks);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(key: formKey, child: Column(children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            controller: emailText,
            validator: (em)=>
            em!=null && !EmailValidator.validate(em) ? 'Неверно указана почта' : null,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(onPressed: newPassPost, child: const Text("New password"))
        ],)),
      ),
    );
  }
}