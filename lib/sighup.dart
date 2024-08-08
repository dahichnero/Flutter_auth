import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google/allcolors.dart';
import 'package:flutter_google/firebase_stream.dart';
import 'package:flutter_google/home.dart';
import 'package:flutter_google/signin.dart';
import 'package:flutter_google/snacks.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SighupMain extends StatefulWidget{
  const SighupMain({super.key});

  @override
  State<SighupMain> createState()=>_SighUpState();
}

class _SighUpState extends State<SighupMain>{
  bool isHidden=true;
  TextEditingController emailInput=TextEditingController();
  TextEditingController passInput=TextEditingController();
  TextEditingController repeatpasswordInput=TextEditingController();
  final formKey=GlobalKey<FormState>();

  @override
  void dispose(){
    emailInput.dispose();
    passInput.dispose();
    repeatpasswordInput.dispose();
    super.dispose();
  }

  void togglePassView(){
    setState(() {
      isHidden=!isHidden;
    });
  }

  Future<void> signInWithGoogle() async{
    try{
      final GoogleSignInAccount? googleSignInAccount=await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? auth=await googleSignInAccount?.authentication;
      final credential =GoogleAuthProvider.credential(accessToken: auth?.accessToken,
      idToken: auth?.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e){
      print('exception->$e');
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home()));
  }

  Future<void> signUp() async{
    final isValid=formKey.currentState!.validate();
    if (!isValid)  return;
    if (passInput.text!=repeatpasswordInput.text){
      Snacks.itSnack(context, 'Passwords are not the same!', true);
      return;
    }
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailInput.text.trim(), password: passInput.text.trim());
    } on FirebaseAuthException catch (q){
      print(q.code);
      if (q.code=='user-already-in-use'){
        Snacks.itSnack(context, 'This user already exist', true);
        return;
      }
      else{
        Snacks.itSnack(context, 'Sorry dont know', true);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const FirebaseStream()));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Allcolors.indi,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Sign Up", style: TextStyle(color: Allcolors.whity, fontSize: 20, fontWeight: FontWeight.bold),),
            Form(key: formKey,child: Column(children: [
              TextFormField(keyboardType: TextInputType.emailAddress, autocorrect: false, controller: emailInput, validator: (email)=>email!=null && !EmailValidator.validate(email) ? 'Enter right email' : null, decoration: const InputDecoration(hintText: "Email"), style: const TextStyle(fontSize: 17, color: Allcolors.whity),),
            TextFormField(autocorrect: false, controller: passInput, obscureText: isHidden, autovalidateMode: AutovalidateMode.onUserInteraction, validator: (value) => 
            value!=null && value.length<6 ? 'Min 6 chars' : null, decoration: InputDecoration(hintText: "Password", suffix: InkWell(
              onTap: togglePassView,
              child: Icon(isHidden ? Icons.visibility_off : Icons.visibility, color: Allcolors.blacky,),
            )), style: const TextStyle(fontSize: 17, color: Allcolors.whity),),
            TextFormField(autocorrect: false, controller: repeatpasswordInput, obscureText: isHidden, autovalidateMode: AutovalidateMode.onUserInteraction, validator: (value) => 
            value!=null && value.length<6 ? 'Min 6 chars' : null, decoration: InputDecoration(hintText: " Repeat password", suffix: InkWell(
              onTap: togglePassView,
              child: Icon(isHidden ? Icons.visibility_off : Icons.visibility, color: Allcolors.blacky,),
            )), style: const TextStyle(fontSize: 17, color: Allcolors.whity),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an account?", style: TextStyle(fontSize: 12, color: Allcolors.misty),),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInMy()));
                }, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,), child: const Text("Sign In", style: TextStyle(fontSize: 12, color: Allcolors.misty),))
              ],
            ),
            ElevatedButton(onPressed: signUp, style: ElevatedButton.styleFrom(backgroundColor: Allcolors.misty), child: const Text("Sign up", style: TextStyle(color: Allcolors.grey, fontSize: 17)),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Or use", style: TextStyle(fontSize: 12, color: Allcolors.misty),),
                ElevatedButton(onPressed: signInWithGoogle, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent), child: const Text("Google", style: TextStyle(fontSize: 12, color: Allcolors.misty),))
              ],
            ),
            ],),
            ),
            
          ],
        ),
      ),
    );
  }
}