import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  File? pickedImage;

  showAlertBox(){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Pick Image From"),
        content: Column(mainAxisSize: MainAxisSize.min,
          children: [
          ListTile(leading: Icon(Icons.camera_alt),title: Text("Camera"),
            onTap: (){PickImage(ImageSource.camera);
            Navigator.pop(context);},),
          ListTile(leading: Icon(Icons.image),title: Text("Gallery"),
              onTap: (){PickImage(ImageSource.gallery);
              Navigator.pop(context);}),
        ],
        ),
      );
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body:Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){showAlertBox();},
              child: pickedImage==null? CircleAvatar(
                radius: 80,
                child: Icon(Icons.person,size: 80,)):
                  CircleAvatar(radius: 80,
                  backgroundImage: FileImage(pickedImage!),)
            ),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller:emailController ,
              decoration: InputDecoration(
                hintText: 'Email',
                suffixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                )
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.text,
              controller:passwordController ,
              decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  )
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              Signup(emailController.text.toString(), passwordController.text.toString());
            }, child: Text("Sign Up"),)
          ],
        ),
      )
    );
  }

  PickImage(ImageSource imagesource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imagesource);
      if (photo == null) return;
      final tempimage = File(photo.path);
      setState(() {
        pickedImage=tempimage;
      });
    }
    catch(ex){
      print(ex.toString());
    }
  }

  Signup(String Email, String Password) async{
    if(Email==''|| Password==''|| pickedImage==null){
     return showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Enter required fields"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);}, child: Text("Ok"))
          ],
        );
      });
    }
    else{
      UserCredential? usercredential;
      try{
        usercredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value){
          uploadData(Email,Password);
        });
      }
      on FirebaseAuthException catch(ex){
        print(emailController.text);
        print(ex.code.toString());
      }
    }
  }

  uploadData(String Email,String Password) async {
    FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: "phone-authentication-558cb.appspot.com");
    TaskSnapshot taskSnapshot=await storage.ref("Profile pics").child(Email).putFile(pickedImage!);
    String url= await taskSnapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection("Users").doc(Email).set({
      "Email": Email,
      "Password": Password,
      "Image": url
    }).then((value){
      print("user uploaded");
    });

  }
}
