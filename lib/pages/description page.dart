import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplenoteapp/database_helper/db_provider.dart';
import 'package:simplenoteapp/model/note_model.dart';

class DescriptionPage extends StatefulWidget {
  int note_id;
  String notetitle,description;
  bool isNewNote;
  DescriptionPage({this.note_id,this.notetitle,this.description,this.isNewNote});

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final db = DBProvider();
  bool _isEditingText = false;
  TextEditingController _noteEditingController,_descriptionEditingController;
  @override
  void initState(){
    super.initState();
    _noteEditingController = TextEditingController(text: widget.notetitle);
    _descriptionEditingController = TextEditingController(text: widget.description);
  }
  @override
  void dispose(){
    _noteEditingController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }
  bool editable = false;
  bool newsaveButton = false;
  bool updateButton = false;
  bool askforaction = false;
  bool showEditButton = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(editable){
          popupBack();
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.deepOrangeAccent,),
            onPressed: (){
              if(askforaction){
                popupBack();
              }else{
                Navigator.of(context).pop();
              }
            },
          ),
          actions: <Widget>[
            _saveButton(),
            _editButton(),
            IconButton(
                icon: Icon(Icons.delete,color: Colors.black,),
                onPressed: (){
                  popupDelete();
                }
            ),
          ],
          elevation: 0.3,
          backgroundColor: Colors.white,
        ),
        body:SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(20),
              child: _editTitleTextField()
          ),
        ),
      ),
    );
  }

  Widget _editButton(){
   if(showEditButton){
     if(widget.isNewNote){
       return IconButton(
           icon: Icon(Icons.edit,color: Colors.black,),
           onPressed: (){
             setState(() {
               showEditButton = false;
               _noteEditingController.text = '';
               _descriptionEditingController.text = '';
               editable = true;
               newsaveButton = true;
               askforaction = true;
             });
           }
       );
     }else if(!widget.isNewNote){
       return IconButton(
           icon: Icon(Icons.edit,color: Colors.black,),
           onPressed: (){
             setState(() {
               showEditButton = false;
               editable = true;
               updateButton = true;
               askforaction = true;
             });
           }
       );
     }
   }else{
     return Text(' ');
   }
  }
  Widget _saveButton(){
    Color saveButtonColor;
    if(editable){
      saveButtonColor = Colors.deepOrangeAccent;
    }else{
      saveButtonColor = Colors.black;
    }
    if(!showEditButton){
      if(newsaveButton){
        return IconButton(
            icon: Icon(Icons.save,color: saveButtonColor,),
            onPressed: ()async{
              setState(() {
                widget.notetitle = _noteEditingController.text;
                widget.description = _descriptionEditingController.text;
                editable = false;
                newsaveButton = false;
                saveButtonColor = Colors.black;
                showEditButton = true;
              });
              await db.addNote(
                  NoteModel(
                      title: _noteEditingController.text,
                      description: _descriptionEditingController.text,
                      date: getDateTime(),
                  )
              );
            }
        );
      }else if(updateButton){
        return IconButton(
            icon: Icon(Icons.save,color: saveButtonColor,),
            onPressed: ()async{
              setState(() {
                widget.notetitle = _noteEditingController.text;
                widget.description = _descriptionEditingController.text;
                editable = false;
                newsaveButton = false;
                saveButtonColor = Colors.black;
                showEditButton = true;
              });
              await db.updateNote(
                  id: widget.note_id,
                  title: _noteEditingController.text,
                  description: _descriptionEditingController.text,
                date: getDateTime(),
              );
            }
        );
      }
    }
    return Text("hiden text");
  }

  getDateTime(){
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted;
  }

  Widget _editTitleTextField() {

    if(editable){
      if(_isEditingText){
        return Column(
          children: <Widget>[
            Container(
              child: TextField(
                maxLength: 50,
                style: TextStyle(
                  fontSize: 18.0,
                ),
                onSubmitted:(newValue){
                  setState(() {
                    widget.notetitle = newValue;
                    _isEditingText = false;
                    editable = false;
                  });
                },
                autofocus: true,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Title",
                ),
                controller: _noteEditingController,
                textInputAction: TextInputAction.next,

              ),
            ),
            Container(
              child: TextField(
                style: TextStyle(
                  fontSize: 18.0,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted:(newValue){
                  setState(() {
                    widget.description = newValue;
                    _isEditingText = false;
                    editable = false;
                  });
                },
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Description",
                ),
                controller: _descriptionEditingController,
              ),
            ),
          ],
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: (){
              setState(() {
                _isEditingText = true;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.notetitle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),

          ),
          SizedBox(height: 15,),
          InkWell(
            onTap: (){
              setState(() {
                _isEditingText = true;
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.description,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),

          )
        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.notetitle,style: TextStyle(fontSize: 18.0),),
          SizedBox(height: 15,),
          Text(widget.description,style: TextStyle(fontSize: 18.0),),
        ],
      );
    }
  }


  Future<bool> popupBack(){
    if(editable){
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
                    width: width/1.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: ()async{
                            if(newsaveButton){
                              setState(() {
                                editable = false;
                                newsaveButton = false;
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                              await db.addNote(
                                  NoteModel(
                                      title: _noteEditingController.text,
                                      description: _descriptionEditingController.text
                                  )
                              );
                            }else if(updateButton){
                              setState(() {
                                editable = false;
                                newsaveButton = false;
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                              await db.updateNote(
                                  id: widget.note_id,
                                  title: _noteEditingController.text,
                                  description: _descriptionEditingController.text
                              );
                            }
                          },
                          child: Text('Save',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Container(height: 50, child: VerticalDivider(color: Colors.grey)),
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('Discard',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Container(height: 50, child: VerticalDivider(color: Colors.grey)),
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
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
    }else if(!editable){
      Navigator.of(context).pop();
    }
  }
  Future popupDelete(){
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
                  width: width/1.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      TextButton(
                        onPressed: ()async{
                        await db.deleteNote(widget.note_id);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        },
                        child: Text('Delete',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
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
