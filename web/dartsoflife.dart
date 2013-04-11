import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:logging/logging.dart';
import 'gameengine.dart';
/**
 * Learn about the Web UI package by visiting
 * http://www.dartlang.org/articles/dart-web-components/.
 */

final GameEngine gameEngine = new GameEngine([[0,0,0,0,0,0,0,0,0,0],
                               [0,0,0,1,0,0,0,0,0,0],
                               [0,1,0,1,0,0,0,0,0,0],
                               [0,0,1,1,0,0,0,0,0,0],
                               [0,0,0,0,0,0,0,0,0,0],
                               [0,0,0,0,0,0,0,0,0,0],
                               [0,0,0,0,0,0,0,0,0,0],
                               [0,0,0,0,0,0,0,0,0,0],
                               [0,0,0,0,0,0,0,0,0,0],
                               [0,0,0,0,0,0,0,0,0,0]]);
void main() {  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
  _setupLogger();
}

void start(){
  document.query('#gameboard').xtag.start();
}

void nextStep(){
  document.query('#gameboard').xtag.nextStep();
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

