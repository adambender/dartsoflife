import 'dart:async';
import 'dart:html' hide Point;
import 'package:web_ui/web_ui.dart';
import 'package:logging/logging.dart';
import 'gameengine.dart';
import 'common.dart';

@observable
class GameBoardHtml extends WebComponent {
  Timer timer;
  static final Logger logger = new Logger("GameBoardHtml");
  final ObservableList<ObservableList<Cell>> visualmodel = new ObservableList<ObservableList<Cell>>();
  GameEngine _gameengine;
  bool _running = false;
  LifeService _lifeService;

  GameBoardHtml(){
    window.onResize.listen(_resizeGameBoard);
  }

  bool get running => _running;

  GameEngine get gameengine => _gameengine;
  void set gameengine(GameEngine newEngine){
    _gameengine = newEngine;
    _gameengine.updates.listen(_updateVisualModel);
    _resizeGameBoard();
  }

  void get lifeService => _lifeService;
  void set lifeService(LifeService newLifeService){
    _lifeService = newLifeService;
    _lifeService.stream.listen((_){
//      switch(_.type){
//        case LifeEvent.NEXT:
//          nextStep();
//          break;
//        case LifeEvent.PREVIOUS:
//          previousStep();
//          break;
//        case LifeEvent.START:
//          run();
//          break;
//        case LifeEvent.STOP:
//          stop();
//          break;
//        default:
//      }
    });
  }

  void inserted(){
    _updateVisualModel(gameengine.currentState);
  }

  void toggleCell(Cell cell){
    _gameengine.toggleCoord(cell.coord);
  }

  void run(){
    if(timer == null){
      _running = true;
      timer = new Timer.periodic(new Duration(milliseconds:100), (_) => nextStep());

    }
  }

  void stop(){
    if(timer != null){
      _running = false;
      timer.cancel();
      timer = null;
    }
  }

  void nextStep(){
    gameengine.nextStep();
  }

  void previousStep(){
    gameengine.previousStep();
  }

  void _resizeGameBoard([_]){
    int nextHeight = (window.innerHeight/20).floor();
    int nextWidth = (window.innerWidth/20).floor();
    gameengine.setSize(nextHeight,nextWidth);
  }

  void _updateVisualModel(GameState gameState) {
    for(var i = 0; i < gameState.height; i++){
      if(visualmodel.length <= i){
        visualmodel.add(new ObservableList<Cell>());
      }
      for(var j = 0; j < gameState.width; j++){
        Point point = new Point(i,j);
        if(gameState.cells.contains(point)){
          if(visualmodel[i].length <= j){
            visualmodel[i].add(new Cell.living(point));
          } else {
            visualmodel[i][j] = new Cell.living(point);
          }
        } else {
          if(visualmodel[i].length <= j){
            visualmodel[i].add(new Cell.dead(point));
          } else {
            visualmodel[i][j] = new Cell.dead(point);
          }
        }
      }
    }
  }
}

class Cell{
  final bool alive;
  final Point coord;
  Cell(this.coord, this.alive);
  Cell.living(Point coord) : this.coord = coord, alive = true;
  Cell.dead(Point coord) : this.coord = coord, alive = false;
  String toString() => '"x":$coord.x, "y":$coord.y, "alive":$alive';
}
