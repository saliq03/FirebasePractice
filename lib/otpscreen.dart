
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_authentication_firebase/main.dart';

class Otpscreen extends StatefulWidget{
  String verificationId;
  Otpscreen({required this.verificationId});
  @override
  State<Otpscreen> createState()=>OtpscreenState();
}
class OtpscreenState extends State<Otpscreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController otpController=TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verfication"),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
          controller: otpController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Enter OTP",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              )),
                ),
        ),
        SizedBox(height: 40,),
        ElevatedButton(onPressed: ()async{
          try{
            PhoneAuthCredential credential= await PhoneAuthProvider.credential(
                verificationId: widget.verificationId,
                smsCode: otpController.text.toString());
            FirebaseAuth.instance.signInWithCredential(credential).then((onValue){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>MyHomePage(title: "Home Screen")));
            });
          }
          catch(ex){
           print('Exception: ${ex.toString()}');
          }



        }, child: Text("Verify OTP"))
      ],
    ),
    );
  }
}