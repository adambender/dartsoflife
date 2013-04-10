library gol;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

class GameBoard extends WebComponent {
  static final Logger logger = new Logger("GameBoard");
  final List<List<Cell>> model = new List<List<Cell>>();
  int _height = 0;
  int _width = 0;
  
  GameBoard(){
    
  }
  
  void setExternalModel(List<List<int>> externalModel){
    model.clear();
    for(var i = 0; i < externalModel.length; i++){
      List<Cell> col = new List<Cell>();
      for(var j = 0; j< externalModel[i].length; j++){
        col.add(new Cell(new Point(j,i), externalModel[i][j] == 1));
      }
      height = externalModel.length;
      width = externalModel[0].length;
      model.add(col);
    }
  }
  //Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  //Any live cell with two or three live neighbours lives on to the next generation.
  //Any live cell with more than three live neighbours dies, as if by overcrowding.
  //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
  void nextStep(){
    //process rules 
    var nextModel = new List<List<Cell>>();
    for(var i = 0; i < _height; i++){
      List<Cell> col = new List<Cell>();
      logger.fine("xxxxxxxxxxxxxxxxxxxxxxxxx");
      for(var j = 0; j < _width; j++){
        var neighborCount = _getAliveNeighborCount(i,j);
        var isAlive = model[i][j].alive;
        var stillAlive = (isAlive && neighborCount == 2) || neighborCount == 3;
        var nextCell = stillAlive ? new Cell.living(model[i][j].coord): new Cell.dead(model[i][j].coord);
        col.add(nextCell);
        logger.fine(nextCell.toString());
      }
      nextModel.add(col);
      logger.fine("-------------------------");
    }
    for(var i = 0; i < _height; i++){
      for(var j = 0; j < _width; j++){
        model[i][j] = nextModel[i][j];
      }
    }
  }
  
  int _getAliveNeighborCount(int i, int j){
    var count = 0;
    if(0 < i && model[i-1][j].alive){//top
      count++;
    } 
    if(i < _height - 1 && model[i+1][j].alive){//bottom
      count++;
    }
    if(0 < j && model[i][j-1].alive){//left
      count++;
    }
    if(j < _width - 1 && model[i][j+1].alive){//right
      count++;
    }
    if(0 < i && 0 < j && model[i-1][j-1].alive){//top left
      count++;
    }
    if(i < _height - 1 && j < _width - 1 && model[i+1][j+1].alive){//bottom right
      count++;
    }
    if(0 < i && j < _width -1 && model[i-1][j+1].alive){//top right
      count++;
    }
    if(i < _height -1 && 0 < j && model[i+1][j-1].alive){//bottom left
      count++;
    }
    return count;
  }
  
  void _resetBoard(){
    model.clear();
    for(var i = 0; i < _height; i++){
      List<Cell> col = new List<Cell>();
      for(var j = 0; j < _width; j++){
        col.add(new Cell(new Point(j,i), j % 3 == 0));
      }
      model.add(col);
    }
  }
  
  int get height => _height;
  void set height(int value) {
    _height = value;
  }
  
  int get width => _width;
  void set width(int value) {
    _width = value;
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
