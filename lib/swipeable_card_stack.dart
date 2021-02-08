library swipeable_card_stack;

import 'package:flutter/material.dart';
import 'package:swipeable_card_stack/models/card_item.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import './profile_card_alignment.dart';
import 'dart:math';

export 'models/card_item.dart';
export './swipe_controller.dart';

List<Alignment> cardsAlign = [
  Alignment(0.0, 1.0),
  Alignment(0.0, 0.8),
  Alignment(0.0, 0.0)
];
List<Size> cardsSize = List(3);

class SwipeableCardsSection extends StatefulWidget {
  final CardController cardController;
  final List<CardItem> items;
  final Function onLeftSwipe;
  final Function onRightSwipe;
  final double cardWidthTopMul;
  final double cardWidthMiddleMul;
  final double cardWidthBottomMul;
  final double cardHeightTopMul;
  final double cardHeightMiddleMul;
  final double cardHeightBottomMul;
  final Function onLastCardLoaded;
  final Function onLastCardSwiped;

  SwipeableCardsSection({
    Key key,
    this.cardController,
    @required BuildContext context,
    @required this.items,
    this.onLeftSwipe,
    this.onRightSwipe,
    this.cardWidthTopMul = 0.9,
    this.cardWidthMiddleMul = 0.85,
    this.cardWidthBottomMul = 0.8,
    this.cardHeightTopMul = 0.6,
    this.cardHeightMiddleMul = 0.55,
    this.cardHeightBottomMul = 0.5,
    this.onLastCardSwiped,
    this.onLastCardLoaded,
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

  List<ProfileCardAlignment> cards = List();
  AnimationController _controller;
  bool enableSwipe = true;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  void _triggerSwipe(Direction dir) {
    if (dir == Direction.left) {
      print('Triggered LEFT -> ${cards[0].item.description}');
      widget.onLeftSwipe != null ? widget.onLeftSwipe(cards[0].item) : () {};
    } else {
      print('Triggered RIGHT -> ${cards[0].item.description}');
      widget.onRightSwipe != null ? widget.onRightSwipe(cards[0].item) : () {};
      frontCardAlign = Alignment(0.001, 0.001);
    }
    if (cards[0].item == widget.items.last) {
      widget.onLastCardSwiped();
    }
    animateCards();
  }

   void _appendItems(List<CardItem> moreItems) {
    widget.items.addAll(moreItems);
  }

  void _enableSwipe(bool isSwipeEnabled) {
    this.enableSwipe = isSwipeEnabled;
  }

  @override
  void initState() {
    super.initState();

    widget.cardController.listener = _triggerSwipe;
    widget.cardController.addItems = _appendItems;
    widget.cardController.enableSwipeListener = _enableSwipe;

    // Init cards
    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      if (widget.items.isNotEmpty && cardsCounter < widget.items.length) {
        cards.add(
          ProfileCardAlignment(cardsCounter, widget.items[cardsCounter]),
        );
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
                            40 *
                                details.delta.dy /
                                MediaQuery.of(context).size.height);

                    frontCardRot = frontCardAlign.x; // * rotation speed;
                  });
                },
                // When releasing the first card
                onPanEnd: (_) {
                  // If the front card was swiped far enough to count as swiped
                  if (frontCardAlign.x > 3.0) {
                    print('Swiped RIGHT -> ${cards[0].item.description}');
                    widget.onRightSwipe != null
                        ? widget.onRightSwipe(cards[0].item)
                        : () {};
                    if (cards[0].item == widget.items.last) {
                      widget.onLastCardSwiped();
                    }
                    animateCards();
                  } else if (frontCardAlign.x < -3.0) {
                    print('Swiped LEFT -> ${cards[0].item.description}');
                    widget.onLeftSwipe != null
                        ? widget.onLeftSwipe(cards[0].item)
                        : () {};
                    if (cards[0].item == widget.items.last) {
                      widget.onLastCardSwiped();
                    }
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
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a  bottom card)
      var temp = cards[0];
      cards[0] = cards[1];
      cards[1] = cards[2];
      cards[2] = temp;

      cards[2] = (cardsCounter < widget.items.length)
          ? ProfileCardAlignment(cardsCounter, widget.items[cardsCounter])
          : null;

      print('${widget.items.length}   $cardsCounter');
      if (widget.items.length == cardsCounter + 1) {
        widget.onLastCardLoaded();
      }

      cardsCounter++;

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;

      if (cardsCounter < widget.items.length &&
          (cards[0] == null || cards[1] == null || cards[2] != null)) {
            changeCardsOrder();
          }
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
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
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
