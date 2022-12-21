import 'package:flutter/material.dart';
import 'detil_makanan.dart';
import 'db_helper.dart';
import 'makanan_favorit.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  var db = new DBHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.getRecord(),
      builder: (context, snapshot){
        if (snapshot.hasError) print (snapshot.error);

        var data = snapshot.data;

        return snapshot.hasData ?
        new FavoritList(data!) : Center(child: Text("No Data"),);
      }
    );
  }
}

class FavoritList extends StatelessWidget {
  final List<MakananFavorit> makananFavorit;

  FavoritList(this.makananFavorit);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery
                  .of(context)
                  .orientation == Orientation.portrait ? 2 : 4
          ),
          itemCount: makananFavorit.length == null ? 0 : makananFavorit.length,
          itemBuilder: (BuildContext context, int i) {
            return GestureDetector(
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: makananFavorit[i].strMeal,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetilMakanan(
                                          id: makananFavorit[i].idMeal!, isExist: true,)
                                )
                            );
                          },
                          child: Image.network(
                            makananFavorit[i].strMealThumb!,
                            width: 160.0,
                            height: 120.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(makananFavorit[i].strMeal,),
                    ),
                  ],
                )
            );
          }
      ),
    );
  }
}

