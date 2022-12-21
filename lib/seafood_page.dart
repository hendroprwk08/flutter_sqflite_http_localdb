import 'package:flutter/material.dart';
import 'makanan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'detil_makanan.dart';

class SeafoodPage extends StatefulWidget {
  @override
  _SeafoodPageState createState() => _SeafoodPageState();
}

class _SeafoodPageState extends State<SeafoodPage> {

  List<Makanan> makanans = [];

  loadData() async {
    String dataURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood";

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
    loadData();
  }

  getBody() {
    if (makanans.length == 0) {
      return new Center(child: new CircularProgressIndicator());
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: getGridView(),
      );
    }
  }

  GridView getGridView() => GridView.count(
      crossAxisCount:  MediaQuery.of(context).orientation == Orientation.portrait? 2: 4,
      children: List.generate(makanans.length, (index){
        return getRow(index);
      },
      )
  );

  Widget getRow(int i) {
    return new GestureDetector(
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
                                DetilMakanan( id: makanans[i].idMeal, isExist: false,)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getBody()
    );
  }
}


