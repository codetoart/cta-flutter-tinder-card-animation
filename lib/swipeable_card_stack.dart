library swipeable_card_stack;

import 'package:flutter/material.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import 'dart:math';

export './swipe_controller.dart';

List<Alignment> cardsAlign = [
  Alignment(0.0, 1.0),
  Alignment(0.0, 0.8),
  Alignment(0.0, 0.0)
];
List<Size> cardsSize = List(3);

class SwipeableCardsSection extends StatefulWidget {
  final CardController cardController;
  //First 3 widgets
  final List<Widget> items;
  final Function onCardSwiped;
  final double cardWidthTopMul;
  final double cardWidthMiddleMul;
  final double cardWidthBottomMul;
  final double cardHeightTopMul;
  final double cardHeightMiddleMul;
  final double cardHeightBottomMul;
  // final Function onLastCardLoaded;
  final Function onLastCardSwiped;
  final Function appendItemCallback;
  final bool enableSwipeUp;
  final bool enableSwipeDown;

  SwipeableCardsSection({
    Key key,
    this.cardController,
    @required BuildContext context,
    @required this.items,
    this.onCardSwiped,
    this.cardWidthTopMul = 0.9,
    this.cardWidthMiddleMul = 0.85,
    this.cardWidthBottomMul = 0.8,
    this.cardHeightTopMul = 0.6,
    this.cardHeightMiddleMul = 0.55,
    this.cardHeightBottomMul = 0.5,
    this.onLastCardSwiped,
    // this.onLastCardLoaded,
    this.appendItemCallback,
    this.enableSwipeUp = true,
    this.enableSwipeDown = true,
  }) {
    cardsSize[0] = Size(MediaQuery.of(context).size.width * cardWidthTopMul,
        MediaQuery.of(context).size.height * cardHeightTopMul);
    cardsSize[1] = Size(MediaQuery.of(context).size.width * cardWidthMiddleMul,
        MediaQuery.of(context).size.height * cardHeightMiddleMul);
    cardsSize[2] = Size(MediaQuery.of(context).size.width * cardWidthBottomMul,
        MediaQuery.of(context).size.height * cardHeightBottomMul);
  }

  @override
  _CardsSectionState createState() => _CardsSectionState();
}

class _CardsSectionState extends State<SwipeableCardsSection>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 0;
  Widget appendCard;

  List<Widget> cards = List();
  AnimationController _controller;
  bool enableSwipe = true;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  void _triggerSwipe(Direction dir) {
    if (dir == Direction.left) {
      widget.onCardSwiped != null ? widget.onCardSwiped(Direction.left) : () {};
      frontCardAlign = Alignment(-0.001, 0.0);
    } else if (dir == Direction.right) {
      widget.onCardSwiped != null ? widget.onCardSwiped(Direction.right) : () {};
      frontCardAlign = Alignment(0.001, 0.0);
    } else if (dir == Direction.up) {
      widget.onCardSwiped != null ? widget.onCardSwiped(Direction.up) : () {};
      frontCardAlign = Alignment(0.0, -0.001);
    } else if (dir == Direction.down) {
      widget.onCardSwiped != null ? widget.onCardSwiped(Direction.down) : () {};
      frontCardAlign = Alignment(0.0, 0.001);
    }

    // if (cards[0].item == widget.items.last) {
    //   widget.onLastCardSwiped();
    // }
    animateCards();
  }

  void _appendItem(Widget newCard) {
    appendCard = newCard;
  }

  void _enableSwipe(bool isSwipeEnabled) {
    this.enableSwipe = isSwipeEnabled;
  }

  @override
  void initState() {
    super.initState();

    widget.cardController.listener = _triggerSwipe;
    widget.cardController.addItem = _appendItem;
    widget.cardController.enableSwipeListener = _enableSwipe;

    // Init cards
    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      if (widget.items.isNotEmpty && cardsCounter < widget.items.length) {
        cards.add(widget.items[cardsCounter]);
      } else {
        cards.add(null);
      }
    }

    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: <Widget>[
        if (cards[2] != null) backCard(),
        if (cards[1] != null) middleCard(),
        if (cards[0] != null) frontCard(),
        // Prevent swiping if the cards are animating
        ((_controller.status != AnimationStatus.forward) && enableSwipe)
            ? SizedBox.expand(
                child: GestureDetector(
                // While dragging the first card
                onPanUpdate: (DragUpdateDetails details) {
                  // Add what the user swiped in the last frame to the alignment of the card
                  setState(() {
                    // 20 is the "speed" at which moves the card
                    frontCardAlign = Alignment(
                        frontCardAlign.x +
                            20 *
                                details.delta.dx /
                                MediaQuery.of(context).size.width,
                        frontCardAlign.y +
                            20 *
                                details.delta.dy /
                                MediaQuery.of(context).size.height);

                    frontCardRot = frontCardAlign.x; // * rotation speed;
                  });
                },
                // When releasing the first card
                onPanEnd: (_) {
                  print("x = ${frontCardAlign.x}, y = ${frontCardAlign.y}");

                  // If the front card was swiped far enough to count as swiped
                  if (frontCardAlign.x > 3.0) {
                    print('Swiped RIGHT');
                    widget.onCardSwiped != null
                        ? widget.onCardSwiped(Direction.right)
                        : () {};
                    animateCards();
                  } else if (frontCardAlign.x < -3.0) {
                    print('Swiped LEFT');
                    widget.onCardSwiped != null
                        ? widget.onCardSwiped(Direction.left)
                        : () {};
                    animateCards();
                  } else if (frontCardAlign.y < -3.0 && widget.enableSwipeUp) {
                    print('Swiped UP');
                    widget.onCardSwiped != null
                        ? widget.onCardSwiped(Direction.up)
                        : () {};
                    animateCards();
                  } else if (frontCardAlign.y > 3.0 && widget.enableSwipeDown) {
                    print('Swiped DOWN');
                    widget.onCardSwiped != null
                        ? widget.onCardSwiped(Direction.down)
                        : () {};
                    animateCards();
                  } else {
                    // Return to the initial rotation and alignment
                    setState(() {
                      frontCardAlign = defaultFrontCardAlign;
                      frontCardRot = 0.0;
                    });
                  }
                },
              ))
            : Container(),
      ],
    ));
  }

  Widget backCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget frontCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(size: cardsSize[0], child: cards[0]),
        ));
  }

  void changeCardsOrder() {
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card)
      cards[0] = cards[1];
      cards[1] = cards[2];
      cards[2] = appendCard;
      appendCard = null;

      // cards[2] = (cardsCounter < widget.items.length)
      //     ? widget.items[cardsCounter]
      //     : null;

      print('${widget.items.length}   $cardsCounter');
      // if (widget.items.length == cardsCounter + 1) {
      //   widget.onLastCardLoaded();
      // }

      cardsCounter++;

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;

    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }

  void resetCards(int diff) {
    cardsCounter = cardsCounter - diff;
    cards[0] = widget.items[cardsCounter];
    cards[1] = widget.items[cardsCounter + 1];
    cards[2] = widget.items[cardsCounter + 2];

    cardsCounter = cardsCounter + 3;
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    if (beginAlign.x == -0.001 ||
        beginAlign.x == 0.001 ||
        beginAlign.x > 3.0 ||
        beginAlign.x < -3.0) {
      return AlignmentTween(
              begin: beginAlign,
              end: Alignment(
                  beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                  0.0) // Has swiped to the left or right?
              )
          .animate(CurvedAnimation(
              parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
    } else {
      return AlignmentTween(
              begin: beginAlign,
              end: Alignment(
                  0.0,
                  beginAlign.y > 0
                      ? beginAlign.y + 30.0
                      : beginAlign.y - 30.0) // Has swiped to the left or right?
              )
          .animate(CurvedAnimation(
              parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
    }
  }
}
