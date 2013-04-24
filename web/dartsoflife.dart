import 'dart:html' hide Point;
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:logging/logging.dart';
import 'package:web_ui/watcher.dart' as watcher;
import 'gameengine.dart';
import 'common.dart';

/**
 * Learn about the Web UI package by visiting
 * http://www.dartlang.org/articles/dart-web-components/.
 */

@observable
bool running = false;

@observable
bool hasHistory = false;

Timer _timer;

final LifeService lifeService = new LifeService();
final GameEngine gameEngine = new GameEngine(
                      new Set.from([new Point(1,3),
                                    new Point(2,1),
                                    new Point(2,3),
                                    new Point(3,2),
                                    new Point(3,3)]),10,10);

void main(){
  _setupLogger();
}

void nextStep(){
  lifeService.nextStep();
  hasHistory = gameEngine.historyLength > 1;
}
void previousStep(){
  lifeService.previousStep();
  hasHistory = gameEngine.historyLength > 1;
}

void run(){
  running = true;
  if(_timer == null){
    _timer = new Timer.periodic(new Duration(milliseconds:100), (_) => nextStep());
  }
}

void stop(){
  running = false;
  if(_timer != null){
    _timer.cancel();
    _timer = null;
  }
}

void _setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord r) {
    StringBuffer sb = new StringBuffer();
    sb
    ..write(r.time.toString())
    ..write(":")
    ..write(r.loggerName)
    ..write(":")
    ..write(r.level.name)
    ..write(":")
    ..write(r.sequenceNumber)
    ..write(": ")
    ..write(r.message.toString());
    print(sb.toString());
  });
}



