import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:simplenoteapp/database_helper/db_provider.dart';
import 'package:simplenoteapp/home_page.dart';
import 'package:simplenoteapp/model/note_model.dart';
class RecycleBinPage extends StatefulWidget {
  @override
  _RecycleBinPageState createState() => _RecycleBinPageState();
}

class _RecycleBinPageState extends State<RecycleBinPage> {
  final AsyncMemoizer _memorizer = AsyncMemoizer();

  final db = DBProvider();

  List<NoteModel> _notes = [];
  Future<bool> _asyncInit()async{
    await _memorizer.runOnce(()async{
      await db.initDb();
      _notes = await db.getRecycleNotes();
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
            title: Text("Recycle bin",style: TextStyle(color: Colors.white),),
            elevation: 0,
          ),
          drawer: SafeArea(
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    trailing: Icon(Icons.settings,size: 30.0,),
                  ),
                  ListTile(
                    title: Text('All notes',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),),
                    leading: Icon(Icons.book,size: 25.0,),
                    onTap: (){
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomePage()));
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
                      Navigator.of(context).pop();
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
        );
      },
    );
  }

  Future<void> _updateUI()async{
    _notes = await db.getRecycleNotes();
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
          popupAsk(note);
          _updateUI();
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

  Future popupAsk(NoteModel note){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            elevation: 0,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: width/1.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: ()async{
                          db.restoreDeletedNote(note.id,note.title,note.description,note.createdDate);
                          db.deleteFromRecycleBin(note.id);
                          Navigator.of(context).pop();
                          _updateUI();
                        },
                        child: Text('Restore',
                          style: TextStyle(
                            color: Color(0xff8e44ad),
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Container(height: 50, child: VerticalDivider(color: Colors.grey)),
                      TextButton(
                        onPressed: ()async{
                          db.deleteFromRecycleBin(note.id);
                          Navigator.of(context).pop();
                          _updateUI();
                        },
                        child: Text('Delete',
                          style: TextStyle(
                            color: Color(0xff8e44ad),
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

}
