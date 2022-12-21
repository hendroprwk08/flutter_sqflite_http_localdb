import 'package:flutter/material.dart';
import 'detil_makanan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'makanan.dart';

class SearchPage extends StatefulWidget {
  bool isTap = false;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final cFind = TextEditingController();

  List<Makanan> makanans = [];

  void _find() async{
       String dataURL = "https://www.themealdb.com/api/json/v1/1/search.php?s=" +
          cFind.text;

      http.Response response = await http.get(Uri.parse(dataURL));
      var responseJson = JSON.jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          makanans = (responseJson['meals'] as List)
              .map((p) => Makanan.fromJson(p))
              .toList();
        });
      } else {
        throw Exception('Gagal terhubung');
      }
  }

  @override
  void initState() {
    super.initState();

    if(widget.isTap){
      getBody();
    }
  }

  getBody() {
    if (cFind.text == null || cFind.text == "") return new Center(child: Text("Belum ada pencarian"));

    if (widget.isTap) {
      widget.isTap = false;
      return new Center(child: new CircularProgressIndicator());
    }

    if (makanans.length == 0) {
      return new Center(child: new CircularProgressIndicator());
    } else {
      return getListView();
    }
  }

  Widget getListView(){
    return ListView.builder(
        itemCount: makanans.length,
        itemBuilder: (context, i){
          return ListTile(
            title: Text(makanans[i].strMeal),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetilMakanan(id: makanans[i].idMeal,isExist: false,)
                  )
              );
            },
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Temukan!"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false)
          ),
        ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(16.0),
            child: TextFormField(
              controller: cFind,
              decoration: InputDecoration(
                  hintText: 'Ketik...',
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          widget.isTap = true;
                        });
                        _find();
                      })),
            ),
          ),
          Expanded(
            child: getBody(),
          )
        ],
      )
    );
  }

  GridView getGridView() =>
      GridView.count(
          crossAxisCount: MediaQuery
              .of(context)
              .orientation == Orientation.portrait ? 2 : 4,
          children: List.generate(makanans.length, (index) {
            print (index);
            return getRow(index);
          },
          )
      );

  Widget getRow(int i) {
    return GestureDetector(
        child: Column(
          children: <Widget>[
            Hero(
              tag: makanans[i].strMeal,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetilMakanan(id: makanans[i].idMeal, isExist: true,)
                        )
                    );
                  },
                  child: Image.network(
                    makanans[i].strMealThumb,
                    width: 160.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text(makanans[i].strMeal,),
            ),
          ],
        )
    );
  }
}
