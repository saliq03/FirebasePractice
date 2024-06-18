import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Showdata extends StatefulWidget{
  State<Showdata> createState()=> _ShowdataState();
}
class _ShowdataState extends State<Showdata>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Showing Data"),
       centerTitle: true,
       backgroundColor: Colors.purpleAccent,
     ),
     body: StreamBuilder(
         stream: FirebaseFirestore.instance.collection("Users").snapshots(),
         builder: (context,snapshot){
           if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                  return ListView.builder(
                      itemBuilder: (context,index){
                        return ListTile(
                          leading: CircleAvatar(child: Text("${index+1}"),),
                          title: Text("${snapshot.data!.docs[index]["Name"]}"),
                          subtitle: Text("${snapshot.data!.docs[index]["Phone"]}"),
                        );
                      },
                      itemCount:snapshot.data!.docs.length,
                  );
                }
              else if(snapshot.hasError){
                print("\n\nError");
                print(snapshot.error);
                  return Center(child: Text("ERROR: ${snapshot.error}"),);
                  }
              else{
                 return Center(child: Text("No data Found"),);
                  }
           }
           else{
             return Center(child: CircularProgressIndicator(),);
           }
         }
         ),
   );
  }

}