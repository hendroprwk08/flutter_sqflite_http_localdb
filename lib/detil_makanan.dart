import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'detil.dart';
import 'makanan_favorit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'db_helper.dart';

class DetilMakanan extends StatefulWidget {
  DetilMakanan({Key? key, required this.id, required this.isExist}): super(key: key);

  final String id;
  bool isExist;

  @override
  _DetilMakananState createState() => _DetilMakananState(id);
}

class _DetilMakananState extends State<DetilMakanan> {
  String? id, gambar, nama, kategori, instruksi;

  // IconData iData;

  _DetilMakananState(this.id);

  var db = new DBHelper();

  List<Detil> makanans = [];
  List<MakananFavorit> makananFavorit = [];

  loadDataDetail() async {
    String dataURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=" +
        id!;

    http.Response response = await http.get(Uri.parse(dataURL));
    var responseJson = JSON.jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        makanans = (responseJson['meals'] as List)
            .map((p) => Detil.fromJson(p))
            .toList();
      });
    } else {
      throw Exception('Gagal terhubung');
    }
  }

  getBody() {
    if (makanans.length == 0) {
      return new Center(child: new CircularProgressIndicator());
    } else {
      gambar = makanans[0].strMealThumb;
      nama = makanans[0].strMeal;
      kategori = makanans[0].strCategory;
      instruksi = makanans[0].strInstructions;

      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: nama!,
                    child: Material(
                      child: InkWell(
                        child: Image.network(
                          gambar!, width: 1000, height: 300, fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(nama!, style: Theme
                              .of(context)
                              .textTheme
                              .headline4),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 8.0),
                            child: Text("Kategori " + kategori!),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 8.0),
                            child: Text(instruksi!),
                          ),
                        ],
                      )
                  ),
                ],
              )
          )
        ],
      );
    }
  }

  @override
  void initState() {
    loadDataDetail();
    setFavButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Detil Makanan"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false)
        ),
        actions: <Widget>[
          IconButton(
            icon: widget.isExist ? Icon(Icons.favorite) : Icon (Icons.favorite_border),
            onPressed: () {
                _saveData();
            },
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Future _saveData() async {
    var db = DBHelper();

    if (id == null || nama == null || kategori == null || instruksi == null || gambar == null){
      print("null");

      Fluttertoast.showToast(
          msg: "Tak ada data disimpan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 13.0
      );

      return;
    }

    if (widget.isExist) {
      await db.deleteRecord(new MakananFavorit(id, nama, kategori, instruksi, gambar));

      print("deleted");

      Fluttertoast.showToast(
          msg: nama! + " dihapus",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 13.0
      );

      setState(() {
        widget.isExist = false;
      });
    } else {
      await db.saveRecord(new MakananFavorit(id, nama, kategori, instruksi, gambar));

      print("saved");

      Fluttertoast.showToast(
          msg: nama! + " tersimpan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 13.0
      );

      setState(() {
        widget.isExist = true;
      });
    }

    //Navigator.pop(context);
  }

  setFavButton() {
    if(!widget.isExist){
      var db = DBHelper();
      var res = db.getIDWhere(id!);

      res.then((val) { //ngambil nilai dari instance of future<String>
        print("value : " + val.toString());

        setState(() {
          widget.isExist = true;
        });
      });
    }
  }
}