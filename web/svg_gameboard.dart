import 'dart:async';
import 'dart:html' hide Point;
import 'dart:svg';
import 'package:web_ui/web_ui.dart';
import 'package:logging/logging.dart';
import 'gameengine.dart';
import 'common.dart';

@observable
class GameBoardSvg extends WebComponent {

  static final Logger logger = new Logger("GameBoardSvg");
//  final ObservableList<ObservableList<Cell>> visualmodel = new ObservableList<ObservableList<Cell>>();
//  GameEngine _gameengine;
//  LifeService _lifeservice;

  GameBoardSvg(){
   // window.onResize.listen(_resizeGameBoard);
  }

  void inserted(){
    append(new SvgElement.svg('<rect x="22" y="10" width="80" height="60" style="fill:rgb(0,255,255); stroke-width:1; stroke:rgb(0,0,0)"/>'));
  }

//  GameEngine get gameengine => _gameengine;
//  void set gameengine(GameEngine newEngine){
//    _gameengine = newEngine;
//    _gameengine.updates.listen(_updateVisualModel);
//    _resizeGameBoard();
//  }
//
//  LifeService get lifeservice => _lifeservice;
//  void set lifeservice(LifeService newLifeService){
//    _lifeservice = newLifeService;
//    _lifeservice.stream.listen((_){
//      switch(_.type){
//        case LifeEvent.NEXT:
//          gameengine.nextStep();
//          break;
//        case LifeEvent.PREVIOUS:
//          gameengine.previousStep();
//          break;
//        default:
//      }
//    });
// }
//
//  void inserted(){
//    _updateVisualModel(gameengine.currentState);
//  }
//
//  void toggleCell(Cell cell){
//    _gameengine.toggleCoord(cell.coord);
//  }
//
//  void _resizeGameBoard([_]){
//    int nextHeight = (window.innerHeight/20).floor();
//    int nextWidth = (window.innerWidth/20).floor();
//    gameengine.setSize(nextHeight,nextWidth);
//  }
//
//  void _updateVisualModel(GameState gameState) {
//    for(var i = 0; i < gameState.height; i++){
//      if(visualmodel.length <= i){
//        visualmodel.add(new ObservableList<Cell>());
//      }
//      for(var j = 0; j < gameState.width; j++){
//        Point point = new Point(i,j);
//        if(gameState.cells.contains(point)){
//          if(visualmodel[i].length <= j){
//            visualmodel[i].add(new Cell.living(point));
//          } else {
//            visualmodel[i][j] = new Cell.living(point);
//          }
//        } else {
//          if(visualmodel[i].length <= j){
//            visualmodel[i].add(new Cell.dead(point));
//          } else {
//            visualmodel[i][j] = new Cell.dead(point);
//          }
//        }
//      }
//    }
//  }
}

class Cell{
  final bool alive;
  final Point coord;
  Cell(this.coord, this.alive);
  Cell.living(Point coord) : this.coord = coord, alive = true;
  Cell.dead(Point coord) : this.coord = coord, alive = false;
  String toString() => '"x":$coord.x, "y":$coord.y, "alive":$alive';
}
