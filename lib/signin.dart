import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google/allcolors.dart';
import 'package:flutter_google/home.dart';
import 'package:flutter_google/new_pass.dart';
import 'package:flutter_google/sighup.dart';
import 'package:flutter_google/snacks.dart';

class SignInMy extends StatefulWidget{
  const SignInMy({super.key});

  @override
  State<SignInMy> createState()=>_SignInState();
}

class _SignInState extends State<SignInMy>{

  bool isHideen=true;
  TextEditingController emailInput=TextEditingController();
  TextEditingController passInput=TextEditingController();
  final formKey=GlobalKey<FormState>();

  @override
  void dispose(){
    emailInput.dispose();
    passInput.dispose();
    super.dispose();
  }

  void togglePassView(){
    setState(() {
      isHideen=!isHideen;
    });
  }

  Future<void> login() async{
    final isValid=formKey.currentState!.validate();
    if (!isValid) return;

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailInput.text.trim(), password: passInput.text.trim());
    } on FirebaseAuthException catch (q){
      print(q.code);
      if (q.code=='user-not-found' || q.code=='wrong-password'){
        Snacks.itSnack(
          context, 'Wrong email or password', true);
          return;
          
      }
      else{
        Snacks.itSnack(context, 'Dont know what', true);
        return;
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home()));
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Allcolors.indi,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Sign In", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Allcolors.whity),),
            Form(key: formKey, child: Column(
              children: [
                TextFormField(keyboardType: TextInputType.emailAddress, autocorrect: false, controller: emailInput, validator: (email)=>
                email!=null && !EmailValidator.validate(email) ? 'Enter the email' : null, decoration: const InputDecoration(hintText: "Email"), style: const TextStyle(fontSize: 17, color: Allcolors.whity),
                ),
                TextFormField(autocorrect: false, controller: passInput, obscureText: isHideen, validator: (value)=> value!=null && value.length<6 ? 'Too small' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction, decoration: InputDecoration(hintText: "Password", suffix: InkWell(
                  onTap: togglePassView,
                  child: Icon(isHideen ? Icons.visibility_off : Icons.visibility, color: Allcolors.blacky,),
                )), style: const TextStyle(fontSize: 17, color: Allcolors.whity),
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont have account?", style: TextStyle(color: Allcolors.misty, fontSize: 12),),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SighupMain()));
                  }, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent), child: const Text("Sign Up", style: TextStyle(fontSize: 12, color: Allcolors.misty),))
                ],
              ),
              ElevatedButton(onPressed: login, style: ElevatedButton.styleFrom(backgroundColor: Allcolors.misty), child: const Text("Sign In", style: TextStyle(fontSize: 17, color: Allcolors.grey),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("You can sign in with", style: TextStyle(fontSize: 12, color: Allcolors.misty),),
                  ElevatedButton(onPressed: (){

                  }, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent), child: const Text("Google", style: TextStyle(fontSize: 12, color: Allcolors.misty),))
                ],
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewPass()));
            }, child: const Text('Reset password',style: TextStyle(fontSize: 12, color: Allcolors.misty),))
              ],
            )),
          ],
        ),
      ),
    );
  }
}