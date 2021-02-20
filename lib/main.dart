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

  String title = 'Refresh Indicator';

  Future<Null> refreshScreen() async{
    await Future.delayed(Duration(seconds: 2));
    return  ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pairs = getPairs();
    pairs.shuffle();

    visiblePairs = pairs;
    selected = true;

    Future.delayed(const Duration(seconds: 7), (){
    setState(() {
      visiblePairs = getQuestions();
      selected = false;

    });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        leading: IconButton(
          icon: Icon(Icons.info_outline),
          tooltip: 'Information',
          color: Colors.white,

          onPressed: (){
            _showDialog();

          },

        ),
        title: Text("Memory Game",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,

            ),
        ),
        centerTitle: true,
      ),
      body:RefreshIndicator(
        onRefresh: refreshScreen,
        backgroundColor: Colors.yellow[800],
        child: Container(
          color: Colors.yellow[100],
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: <Widget>[
              SizedBox(height: 3,),
              points != 1000 ? GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 0.0, maxCrossAxisExtent: 100
                ),
                children: List.generate(visiblePairs.length, (index) {
                  return Tile(
                    imageAssetPath: visiblePairs[index].getImageAssetPath(),
                    parent: this,
                    tileIndex: index,
                  );

                }),

              )
                  : Container(),

              SizedBox(height: 20,),
              points != 1000 ? Column(
                children: <Widget> [
                  Text("$points/1000", style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 37,
                    fontWeight: FontWeight.w400,
                  ),),
                  Text("Points", style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),

                ],
              )
                  : Container(

                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 34),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(14)
                ),
                child: FlatButton(
                  child: new Text("Replay"),
                  onPressed: (){


                  },

                )),

            ],
          ),
        ),
      ),
    );
  }

  _showDialog(){
    showDialog(
        context: context,

         barrierDismissible: false,

         builder: (BuildContext context){

          return AlertDialog(

            shape: RoundedRectangleBorder(
              borderRadius: 
                BorderRadius.circular(20)
            ),


            title: Text("\n\n-Observe the cards shown for 7 seconds.\n\n-Match the same ones after the cards are reversed.\n\n-Try to reach 1000 points.\n\n\n            Good Luck!", style: TextStyle(
              fontSize: 25,

            )),
            content: Text(""),

            actions: <Widget>[

              Padding(
                padding: const EdgeInsets.only(right: 15.0, bottom: 20.0),
                child: MaterialButton(
                  child: Text("GOT IT!", style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ), ),

                  shape: StadiumBorder(),

                  minWidth: 100,
                  height: 50,


                  color: Colors.red[900],

                  onPressed: (){
                    Navigator.of(context).pop();
                  },

                ),
              )

            ],
          );

         }

    );

  }

}

class Tile extends StatefulWidget {

  String imageAssetPath;

  int tileIndex;

  _HomePageState parent;
  Tile({this.imageAssetPath,this.parent, this.tileIndex});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(!selected) {
          if(selectedImageAssetPath != ""){
            
            if(selectedImageAssetPath == pairs[widget.tileIndex].getImageAssetPath()){
              //correct
              print("correct");
              selected = true;
              
              Future.delayed(const Duration(milliseconds: 500),(){
                points = points + 100;
                setState(() {
                });
                selected = false;
                widget.parent.setState(() {
                  pairs[widget.tileIndex].setImageAssetPath("");
                  visiblePairs[selectedTileIndex].setImageAssetPath("");
                });

                selectedImageAssetPath = "";

              });
              
            } else{
              //wrong choice
              print("wrong choice");
              selected = true;
              Future.delayed(const Duration(milliseconds: 500),(){
                selected = false;
                widget.parent.setState(() {
                  pairs[widget.tileIndex].setIsSelected(false);
                  pairs[selectedTileIndex].setIsSelected(false);
                });

                selectedImageAssetPath = "";

              });
            }

          }else{
            selectedTileIndex = widget.tileIndex;
            selectedImageAssetPath = pairs[widget.tileIndex].getImageAssetPath();
          }
          setState(() {
            pairs[widget.tileIndex].setIsSelected(true);
          });

          print("Clicked");

        }
      },
      child: Container(
      margin: EdgeInsets.all(5),
      child: pairs[widget.tileIndex].getImageAssetPath() !="" ? Image.asset(pairs[widget.tileIndex].getIsSelected() ? pairs[widget.tileIndex].getImageAssetPath(): widget.imageAssetPath) : Image.asset("assets/right.png")
      ),
    );
  }
}




