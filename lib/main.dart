import 'package:flutter/material.dart';
import 'package:gameapp/data/data.dart';
import 'package:gameapp/model/tile_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<TileModel> visiblePairs = new List<TileModel>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pairs = getPairs();
    pairs.shuffle();

    visiblePairs = pairs;
    selected = true;

    Future.delayed(const Duration(seconds: 5), (){
    setState(() {
      visiblePairs = getQuestions();
      selected = false;

    });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 60,),
            Text("$points/800", style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
            ),),
            Text("Points"),
            SizedBox(height: 40,),
            GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 0.0, maxCrossAxisExtent: 100
              ),
              children: List.generate(visiblePairs.length, (index) {
                return Tile(
                  imageAssetPath: visiblePairs[index].getImageAssetPath(),
                  selected: visiblePairs[index].getIsSelected(),
                  parent: this,
                  tileIndex: index,
                );

              }),

            )
          ],
        ),
      ),
    );
  }
}
class Tile extends StatefulWidget {

  String imageAssetPath;
  bool selected;
  int tileIndex;

  _HomePageState parent;
  Tile({this.imageAssetPath,this.selected,this.parent, this.tileIndex});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(!selected) {
          selected = true;
          setState(() {

          });
          print("You clicked me");

        }
      },
      child: Container(
      margin: EdgeInsets.all(5),
      child: Image.asset(widget.selected ? pairs[widget.tileIndex].getImageAssetPath(): widget.imageAssetPath)

      ),
    );
  }
}


