library gol;

import 'package:web_ui/web_ui.dart';
import 'dart:async';
import 'package:logging/logging.dart';

class GameBoard extends WebComponent {
  static final Logger logger = new Logger("GameBoard");
  final List<List<Cell>> visualmodel = new List<List<Cell>>();
  final Set<Point> hashmodel = new Set();
  int _height = 0;
  int _width = 0;

  GameBoard();

  //perhaps use hashtable by xy coord to keep everything and forget the grid
  //when we ask for a cell we dont know about add that cell as dead to the hash
  void setExternalModel(List<List<int>> externalModel){
    hashmodel.clear();
    for(var i = 0; i < externalModel.length; i++){
      for(var j = 0; j< externalModel[i].length; j++){
        if(externalModel[i][j] == 1){
          hashmodel.add(new Point(i,j));
        }
      }
    }
    height = externalModel.length;
    width = externalModel[0].length;
    _updateVisualModel();
  }

  void _updateVisualModel() {
    visualmodel.clear();
    for(var i = 0; i < height; i++){
      List<Cell> col = new List<Cell>();
      for(var j = 0; j < width; j++){
        Point point = new Point(i,j);
        if(hashmodel.contains(point)){
          col.add(new Cell.living(point));
        } else {
          col.add(new Cell.dead(point));
        }
      }
      visualmodel.add(col);
    }
  }
  //Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  //Any live cell with two or three live neighbours lives on to the next generation.
  //Any live cell with more than three live neighbours dies, as if by overcrowding.
  //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
  void nextStep(){
    //process rules
    var nextModel = new Set<Point>();
    for(Point p in hashmodel.expand(computeNeighbors)){
      var neighborCount = hashmodel.intersection(computeNeighbors(p)).length;
      if((hashmodel.contains(p) && neighborCount == 2) || neighborCount == 3){
        nextModel.add(p);
      }
    }
    hashmodel
      ..clear()
      ..addAll(nextModel);
    _updateVisualModel();
  }

  int get height => _height;
  void set height(int value) {
    _height = value;
  }

  int get width => _width;
  void set width(int value) {
    _width = value;
  }

  Set<Point> computeNeighbors(Point p){
    var _top = new Point(p.x-1,p.y);
    var _bottom = new Point(p.x+1,p.y);
    var _left = new Point(p.x,p.y-1);
    var _right = new Point(p.x,p.y+1);
    var _topleft= new Point(p.x-1,p.y-1);
    var _bottomleft = new Point(p.x+1,p.y-1);
    var _topright = new Point(p.x-1,p.y+1);
    var _bottomright = new Point(p.x+1,p.y+1);
    return new Set.from([_top,_bottom,_left,_right,_topleft,_bottomleft,_topright,_bottomright]);
  }
}

class Point{
  final int x;
  final int y;

  Point(this.x, this.y);

  bool operator == (var other) {
    if (other is !Point) return false;
    return x == other.x && y == other.y;
  }

  int get hashCode {
    int result = 17;
    result = 37 * result + x;
    result = 37 * result + y;
    return result;
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
