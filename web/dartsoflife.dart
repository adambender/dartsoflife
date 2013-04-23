import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:logging/logging.dart';
import 'gameengine.dart';
import 'common.dart';

/**
 * Learn about the Web UI package by visiting
 * http://www.dartlang.org/articles/dart-web-components/.
 */
final LifeService lifeService = new LifeService();
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


void main() {  
  _setupLogger();
}

void nextStep(){
  lifeService.nextStep();
}

void run(){
  lifeService.start();
}

void stop(){
  lifeService.stop();
}

void previousStep(){
  lifeService.previousStep();
}

bool get previousDisabled => gameEngine.historySize == 1;
bool get running => document.query('#gameboard').xtag.running;

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



