typedef TriggerListener = void Function(Direction dir);

class SwipeController {
  TriggerListener listener;

  void triggerSwipeLeft() {
    return listener.call(Direction.left);
  }

  void triggerSwipeRight() {
    return listener.call(Direction.right);
  }
}

enum Direction {
  left,
  right,
}
