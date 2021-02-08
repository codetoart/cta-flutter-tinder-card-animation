import 'models/card_item.dart';

typedef TriggerListener = void Function(Direction dir);
typedef AppendItems = void Function(List<CardItem> moreItems);
typedef EnableSwipe = void Function(bool dir);

class CardController {
  TriggerListener listener;
  AppendItems addItems;
  EnableSwipe enableSwipeListener;

  void triggerSwipeLeft() {
    return listener.call(Direction.left);
  }

  void triggerSwipeRight() {
    return listener.call(Direction.right);
  }

  void appendItems(List<CardItem> moreItems) {
    return addItems.call(moreItems);
  }

  void enableSwipe(bool isSwipeEnabled) {
    return enableSwipeListener.call(isSwipeEnabled);
  }
}

enum Direction {
  left,
  right,
}
