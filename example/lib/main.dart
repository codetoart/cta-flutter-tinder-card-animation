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
  List<CardItem> items = [
    CardItem(title: 'Colors.red', description: "First card"),
    CardItem(title: 'Colors.blue', description: "Second card"),
    CardItem(title: 'Colors.orange', description: "Third card"),
    CardItem(title: 'Colors.indigo', description: "Fourth card"),
    CardItem(title: 'Colors.green', description: "The next card is the last"),
    CardItem(title: 'Colors.purple', description: "This is the last card"),
  ];

  List<CardItem> moreItems = [
        CardItem(title: 'red', description: "First card"),
        CardItem(title: 'blue', description: "Second card"),
        CardItem(title: 'orange', description: "Third card"),
        CardItem(title: 'indigo', description: "Fourth card"),
        CardItem(title: 'green', description: "The next card is the last"),
        CardItem(title: 'purple', description: "This is the last card"),
      ];

  void _reload() {
    setState(() {
      moreItems = [
        CardItem(title: 'red', description: "First card"),
        CardItem(title: 'blue', description: "Second card"),
        CardItem(title: 'orange', description: "Third card"),
        CardItem(title: 'indigo', description: "Fourth card"),
        CardItem(title: 'green', description: "The next card is the last"),
        CardItem(title: 'purple', description: "This is the last card"),
      ];
    });
  }

  void _onLiked(CardItem item) {
    print('onLiked ${item.title}');
  }

  // void _onDisliked(CardItem item) {
  // print('onDisliked ${item.title}');
  // }

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
          Container(
            width: double.infinity,
            height: 500,
            color: Colors.amber,
            child: SwipeableCardsSection(
              cardController: _cardController,
              context: context,
              items: items,
              onLeftSwipe: (item) {
                print('onDisliked ${item.title}');
              },
              onRightSwipe: _onLiked,
              onLastCardSwiped: () {
                print('onLastCardSwiped');
              },
              onLastCardLoaded: () {
                // _cardController.appendItems(moreItems);
                // _cardController.enableSwipe(false);
                print('onLastCardLoaded');
              },
              // cardHeightTopMul: 0.3,
              // cardHeightMiddleMul: 0.25,
              // cardHeightBottomMul: 0.2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                  child: Icon(Icons.chevron_left), onPressed: () => _cardController.triggerSwipeLeft()),
              FloatingActionButton(
                  child: Icon(Icons.chevron_right), onPressed: () => _cardController.triggerSwipeRight()),
              FloatingActionButton(
                  child: Icon(Icons.replay_outlined), onPressed: () => _cardController.appendItems(moreItems))
            ],
          )
        ],
      ),
    );
  }
}
