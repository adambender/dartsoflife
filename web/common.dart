import 'dart:async';
import 'package:logging/logging.dart';

class LifeEvent{
  static const int NEXT = 2;
  static const int PREVIOUS = 3;
  final int type;

  LifeEvent.next(): type = LifeEvent.NEXT;
  LifeEvent.previous(): type = LifeEvent.PREVIOUS;
  LifeEvent(this.type);

  bool operator == (var other) {
    if (other is !LifeEvent) return false;
    return type == other.type;
  }

  int get hashCode {
    int result = 17;
    result = 37 * result + type;
    return result;
  }
}

class LifeService{
  static final Logger _logger = new Logger("LifeService");
  StreamController<LifeEvent> _eventStreamController = new StreamController<LifeEvent>();

  Stream<LifeEvent> get stream => _eventStreamController.stream;

  void nextStep() {
    _eventStreamController.add(new LifeEvent.next());
  }

  void previousStep() {
    _eventStreamController.add(new LifeEvent.previous());
  }
}

