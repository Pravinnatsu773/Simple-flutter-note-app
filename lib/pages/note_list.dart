// import 'package:flutter/material.dart';
// import 'package:simplenoteapp/model/note_model.dart';
// import 'package:simplenoteapp/pages/description page.dart';
// class NoteList extends StatefulWidget {
//   @override
//   _NoteListState createState() => _NoteListState();
// }
//
// class _NoteListState extends State<NoteList> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.blueGrey,
//       padding: EdgeInsets.only(top: 20),
//       child: new ListView.builder(
//         itemCount: dummyData.length,
//         itemBuilder: (context,i){
//           return Container(
//             margin: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.white,
//             ),
//             height: 60,
//             child: new ListTile(
//               title: new Text(dummyData[i].title,
//               style: TextStyle(
//                 fontSize: 20.0
//               ),),
//               onTap: (){
//                 Navigator.push(context, new MaterialPageRoute(builder: (context)=> new DescriptionPage(notetitle: dummyData[i].title,description: dummyData[i].description,) ));
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
