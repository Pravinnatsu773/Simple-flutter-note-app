import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:simplenoteapp/model/note_model.dart';
import 'package:simplenoteapp/pages/note_list.dart';
import 'package:simplenoteapp/pages/description page.dart';
import 'package:simplenoteapp/database_helper/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AsyncMemoizer _memorizer = AsyncMemoizer();

  final db = DBProvider();

  List<NoteModel> _notes = [];
  Future<bool> _asyncInit()async{
    await _memorizer.runOnce(()async{
      await db.initDb();
      _notes = await db.getNotes();
    });
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Note app",style: TextStyle(color: Colors.black),),
            elevation: 0,
          ),
          body: Container(
            color: Colors.white,
            child: ListView(
              children: this._notes.reversed.map(_itemToListTitle).toList(),
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(),
        );
      },
    );
  }

  Future<void> _updateUI()async{
    _notes = await db.getNotes();
    setState(() {
    });
  }

  Widget _itemToListTitle(NoteModel note){
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12))
      ),
      child: ListTile(
        title: Text(
          note.title,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: getSubtitle(note.description),
        trailing: Text(note.date??''),
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(builder: (context)=> new DescriptionPage(note_id:note.id,notetitle: note.title,description: note.description,isNewNote: false,) )).then((value){
            _updateUI();
          });
        },
      ),
    );
  }


  Widget getSubtitle(String description){
    int strlen = description.length;
    if(description != ''){
      if(strlen>20){
        return Text(description.substring(0,20));
      }else{
        return Text(description.substring(0,strlen));
      }
    }else{
      return Text(' ',);
    }
  }
  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        Navigator.push(context, new MaterialPageRoute(builder: (context)=> new DescriptionPage(notetitle: 'Title',description: 'Description',isNewNote: true,) )).then((value){
          _updateUI();
        });
      },
      child: const Icon(Icons.add,size:35.0,color: Colors.white,),
      backgroundColor: Colors.deepOrangeAccent,
    );
  }

}
