import 'dart:async';
import 'dart:html' hide Point;
import 'package:web_ui/web_ui.dart';
import 'package:logging/logging.dart';
import 'gameengine.dart';

@observable
class GameBoardHtml extends WebComponent {
  Timer timer;
  static final Logger logger = new Logger("GameBoardHtml");
  final ObservableList<ObservableList<Cell>> visualmodel = new ObservableList<ObservableList<Cell>>();
  GameEngine _gameengine;
  bool _running = false;
  
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

  void inserted(){
    _updateVisualModel(gameengine.currentState);
  }

  void toggleCell(Cell cell){
    _gameengine.toggleCoord(cell.coord);
  }
  
  void run(){
    if(timer == null){
      _running = true;
      timer = new Timer.periodic(new Duration(milliseconds:500), (_) => nextStep());
      timer = null;
    }
  }
  
  void stop(){
    if(timer != null){
      logger.info("trying to cancel");
      _running = false;
      timer.cancel();
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
    visualmodel.clear();
    for(var i = 0; i < gameState.height; i++){
      ObservableList<Cell> col = new ObservableList<Cell>();
      for(var j = 0; j < gameState.width; j++){
        Point point = new Point(i,j);
        if(gameState.cells.contains(point)){
          col.add(new Cell.living(point));
        } else {
          col.add(new Cell.dead(point));
        }
      }
      visualmodel.add(col);
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
