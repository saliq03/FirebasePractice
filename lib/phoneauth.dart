import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:phone_authentication_firebase/otpscreen.dart';

class Phoneauth extends StatefulWidget{
  @override
  State<Phoneauth> createState()=>PhoneauthState();
}
class PhoneauthState extends State<Phoneauth>{
  TextEditingController phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Authentication"),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter phone Number",
                suffix: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                )),
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: () async{
            await FirebaseAuth.instance.verifyPhoneNumber(
                verificationCompleted: (PhoneAuthCredential credential){},
                verificationFailed: (FirebaseException ex){},
                codeSent: (String verificationid,int? resendtoken){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Otpscreen(verificationId: verificationid,)));
                },
                codeAutoRetrievalTimeout: (String verificationid){},
              phoneNumber: phoneController.text.toString());

          }, child: Text("Verify Phone"))
        ],
      ),
    );
  }

}