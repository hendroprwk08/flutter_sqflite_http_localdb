import 'package:flutter/material.dart';
import 'desert_page.dart' as desert;
import 'seafood_page.dart' as seafood;
import 'favorite_page.dart' as favorite;
import 'search_page.dart' as search;
import 'db_helper.dart';

void main() => runApp(MaterialApp(
  title: "SQFLITE + API",
  home: MyApp(),
  debugShowCheckedModeBanner: false,
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  late TabController tabController;

  var db = new DBHelper();

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Submission 04"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context)  =>
                            search.SearchPage()
                    )
                );
              },
            )
          ],
        ),

        body: TabBarView(
            controller: tabController,
            children: <Widget>[
              seafood.SeafoodPage(),
              desert.DesertPage(),
              favorite.FavoritePage(),
            ]),

        bottomNavigationBar: SizedBox(
          height: 58,
          child: Material(
            color: Colors.blueGrey[300],
            child: TabBar(
              controller: tabController,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.fastfood)),
                Tab(icon: Icon(Icons.cake)),
                Tab(icon: Icon(Icons.favorite)),
              ],
            ),
          ),
        )
    );
  }
}