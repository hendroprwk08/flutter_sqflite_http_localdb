import 'dart:async';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'makanan_favorit.dart';

class DBHelper{

  static final DBHelper _instance = new DBHelper.internal();
  DBHelper.internal();

  factory DBHelper() => _instance;

  static late Database _db;

  Future<Database> get db async{
    if(_db != null ) return _db; //DB ada.

    _db = await setDB(); //membuat DB
    return _db;
  }

  setDB() async {
    String path = join(await getDatabasesPath(), "MakananDB");
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute("create table makanan(id text primary key, meal text, category text, instructions text, thumb text)");
    print("DB Created");
  }

  Future<int> saveRecord(MakananFavorit makananFavorit) async{
    var dbClient = await db;
    int res = await dbClient.insert("makanan", makananFavorit.toMap());
    print("Data Inserted");
    return res;
  }

  Future<bool> updateRecord(MakananFavorit makananFavorit) async{
    var dbClient = await db;
    int res = await dbClient.update("makanan",
        makananFavorit.toMap(),
        where: "id=?",
        whereArgs: [makananFavorit.idMeal]);
    print("Data Updated");
    return res > 0 ? true: false ;
  }

  Future<int> deleteRecord(MakananFavorit makananFavorit) async{
    var dbClient = await db;
    int res = await dbClient.rawDelete("delete from makanan where id=?", [makananFavorit.idMeal]);
    print("Data Deleted");
    return res;
  }

  Future<String> getIDWhere(String id) async {
    late String res;
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("select * from makanan where id = '" + id + "'");

    print ("hasil :" +list.length.toString());

    if (list.length > 0 ) res = list[0]["id"];

    print("result: "+ res);
    return res;
  }

  Future<List<MakananFavorit>> getRecord() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("select * from makanan order by id desc");
    List<MakananFavorit> makananFavorit = [];

    for (int i=0; i < list.length; i++){
      var note = new MakananFavorit(
          list[i]["id"],
          list[i]["meal"],
          list[i]["category"],
          list[i]["instructions"],
          list[i]["thumb"]);
      makananFavorit.add(note);
    }

    return makananFavorit;
  }
}