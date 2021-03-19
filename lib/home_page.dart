import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplenoteapp/model/note_model.dart';
import 'package:simplenoteapp/pages/description page.dart';
import 'package:simplenoteapp/database_helper/db_provider.dart';
import 'package:simplenoteapp/pages/recycle_bin_page.dart';
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
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff8e44ad)),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff8e44ad),
            title: Text("All notes",style: TextStyle(color: Colors.white),),
            elevation: 0,
          ),
          drawer: SafeArea(
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 50.0,),
                  ListTile(
                    title: Text('All notes',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),),
                    leading: Icon(Icons.book,size: 25.0,),
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text('Recycle bin',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),),
                    leading: Icon(Icons.delete,size: 25.0,),
                    onTap: (){
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> RecycleBinPage(_notes.length)));
                    },
                  ),
                  Divider(height: 2.0,),

                ],
              ),
            ),
          ),
          body: Container(
            color: Color(0xffecf0f1),
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
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          note.title,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5.0,),
            Text(getSubtitle(note.description),
            style: TextStyle(
              fontSize: 16.0,
            ),),
            SizedBox(height: 10.0,),
            Text(getSubtitle(note.createdDate??''),
            style: TextStyle(
              fontSize: 12.0,
            ),),
          ],
        ),
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(builder: (context)=> new DescriptionPage(note_id:note.id,notetitle: note.title,description: note.description,isNewNote: false,createdDate: note.createdDate,) )).then((value){
            _updateUI();
          });
        },
      ),
    );
  }


  String getSubtitle(String description){
    int strlen = description.length;
    if(description != ''){
      if(strlen>20){
        return description.substring(0,20);
      }else{
        return description.substring(0,strlen);
      }
    }else{
      return ' ';
    }
  }
  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        Navigator.push(context, new MaterialPageRoute(builder: (context)=> new DescriptionPage(notetitle: 'Title',description: 'Description',isNewNote: true,createdDate: '',) )).then((value){
          _updateUI();
        });
      },
      child: const Icon(Icons.add,size:35.0,color: Colors.white,),
      backgroundColor: Color(0xff8e44ad),
    );
  }

}
