class NoteModel{
  int id;
  String title;
  String description;
  String date;

  NoteModel({this.title,this.description,this.date});

  NoteModel.fromJsonMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.date = map['date'];
  }

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'title': title,
      'description':description,
      'date':date,
    };
  }
}
List<NoteModel> dummyData = [
  new NoteModel(title: 'natsu',description: '''
  Natsu Dragneel (ナツ・ドラグニル Natsu Doraguniru) is a 
  Mage of the Fairy Tail Guild, 
  wherein he is a member of Team Natsu. 
  He is the younger brother of Zeref Dragneel, having originally 
  died 400 years ago, being subsequently revived as his brother's most 
  powerful Etherious
  '''),
  new NoteModel(title: "fairy tail",description: '''
  
Fairy Tail - Wikipedia
en.wikipedia.org › wiki › Fairy_Tail
Fairy Tail (stylized as FAIRY TAIL) is a Japanese manga series written and illustrated by Hiro Mashima. It was serialized in Kodansha's Weekly Shōnen Magazine from August 2006 to July 2017, with the individual chapters collected and published into 63 tankōbon volumes
'''),
  new NoteModel(title: 'pokemon',description: "v4retbf"),
  new NoteModel(title: "spiderman",description: "trbwef tbt   twe"),
  new NoteModel(title: 'hunterxhunter',description: "wtrh trghr yry"),
  new NoteModel(title: "dbz",description: "hyr rtj ytm n"),
  new NoteModel(title: 'death note',description: "thw rhwyjw yj y j"),
  new NoteModel(title: "The seven deadly sins",description: "trj  fhr ghre g ergh reg "),
];