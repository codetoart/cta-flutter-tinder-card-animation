# swipeable_card_stack

**This is Tinder like swipeable cards package. You can add your own widgets to the stack, receive all four events, left, right, up and down. You can define your own business logic for each direction.**

<img alt="Demo" src="https://raw.githubusercontent.com/codetoart/cta-flutter-tinder-card-animation/dev/readme-assets/swipe-card.gif" height="500">

## Documentation

### Installation
Add `swipeable_card_stack` to your `pubspec.yaml`:

```
dependencies:
  flutter:
    sdk: flutter

  # added below
  swipeable_card_stack: <latest version>
```
### Adding to app
Use the `SwipeableCardsSection` widget provided by the package

```
@override
  Widget build(BuildContext context) {
    //create a SwipeableCardSectionController
    SwipeableCardSectionController _cardController = SwipeableCardSectionController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SwipeableCardSectionController(
            cardController: _cardController,
            context: context,
            //add the first 3 cards (widgets)
            items: [
              CardView(text: "First card"),
              CardView(text: "Second card"),
              CardView(text: "Third card"),
            ],
            //Get card swipe event callbacks
            onCardSwiped: (dir, index, widget) {
              //Add the next card using _cardController
              _cardController.addItem(CardView(text: "Next card"));
              
              //Take action on the swiped widget based on the direction of swipe
              //Return false to not animate cards
            },
            //
            enableSwipeUp: true,
            enableSwipeDown: false,
          ),
          //other children
        )
    }
          
```

### Author
[**CodeToArt Technology**](https://github.com/codetoart)

- Follow us on **Twitter**: [**@codetoart**](https://twitter.com/codetoart)
- Contact us on **Website**: [**codetoart**](http://www.codetoart.com)
