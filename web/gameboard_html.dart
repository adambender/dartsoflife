import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:logging/logging.dart';
import 'GameEngine.dart';

class GameBoardHtml extends WebComponent {
  static final Logger logger = new Logger("GameBoardHtml");
  final List<List<Cell>> visualmodel = new List<List<Cell>>();
  GameEngine _gameengine;

  GameBoardHtml();

  GameEngine get gameengine => _gameengine;
  void set gameengine(GameEngine newEngine){
    _gameengine = newEngine;
    _gameengine.updates.listen(_updateVisualModel);
  }

  void start(){
    _updateVisualModel(gameengine.currentState);
  }

  void nextStep(){
    gameengine.nextStep();
  }

  void _updateVisualModel(GameState gameState) {
    visualmodel.clear();
    for(var i = 0; i < gameState.height; i++){
      List<Cell> col = new List<Cell>();
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
