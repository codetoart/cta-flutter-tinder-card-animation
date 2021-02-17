import 'package:example/card_example.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 4;
  List<CardExample> items = [
    CardExample(color: Colors.red, text: "First card"),
    CardExample(color: Colors.blue, text: "Second card"),
    CardExample(color: Colors.orange, text: "Third card"),
    CardExample(color: Colors.indigo, text: "Fourth card"),
    CardExample(color: Colors.green, text: "The next card is the last"),
    CardExample(color: Colors.purple, text: "This is the last card"),
  ];

  @override
  Widget build(BuildContext context) {
    CardController _cardController = CardController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SwipeableCardsSection(
            cardController: _cardController,
            context: context,
            //add the first 3 cards
            items: [
              CardExample(color: Colors.red, text: "First card"),
              CardExample(color: Colors.blue, text: "Second card"),
              CardExample(color: Colors.orange, text: "Third card"),
            ],
            onCardSwiped: (dir) {
              //Add the next item if available
              if (counter <= 20) {
                _cardController.addItem(CardExample(
                    color: Colors.greenAccent, text: "card $counter"));
                counter++;
              }

              if (dir == Direction.left) {
                print('onDisliked');
              } else if (dir == Direction.right) {
                print('onLiked');
              } else if (dir == Direction.up) {
                print('onUp');
              } else if (dir == Direction.down) {
                print('onDown');
              }
            },
            onLastCardSwiped: () {
              print('onLastCardSwiped');
            },
            enableSwipeUp: true,
            enableSwipeDown: true,
            // cardHeightTopMul: 0.3,
            // cardHeightMiddleMul: 0.25,
            // cardHeightBottomMul: 0.2,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                    child: Icon(Icons.chevron_left),
                    onPressed: () => _cardController.triggerSwipeLeft()),
                FloatingActionButton(
                    child: Icon(Icons.chevron_right),
                    onPressed: () => _cardController.triggerSwipeRight()),
                FloatingActionButton(
                    child: Icon(Icons.arrow_upward),
                    onPressed: () => _cardController.triggerSwipeUp()),
                FloatingActionButton(
                    child: Icon(Icons.arrow_downward),
                    onPressed: () => _cardController.triggerSwipeDown()),
                // FloatingActionButton(
                //     child: Icon(Icons.replay_outlined),
                //     onPressed: () => _cardController.appendItems(moreItems))
              ],
            ),
          )
        ],
      ),
    );
  }
}
