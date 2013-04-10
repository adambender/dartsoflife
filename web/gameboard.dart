library gol;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:async';

class GameBoard extends WebComponent {
  final List<List<Cell>>model = new List<List<Cell>>();
  int _height = 0;
  int _width = 0;
  
  GameBoard(){
   _resetBoard();
  }
  
  //Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  //Any live cell with two or three live neighbours lives on to the next generation.
  //Any live cell with more than three live neighbours dies, as if by overcrowding.
  //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
  void nextStep(){
    //process rules 
    for(int i = 0; i < _height; i++){
      for(int j = 0; j < _width; j++){
        int neighborCount = _getAliveNeighborCount(i,j);
        bool isAlive = model[j][i].alive;
        model[j][i].alive = (isAlive && neighborCount < 2) ||  (isAlive && neighborCount == 2) ||  neighborCount == 3;
      }
    }
  }
  
  void _getAliveNeighborCount(int i, int j){
    int count = 0;
    if(0 < i && model[j][i-1]){//top
      count++;
    } 
    if(i < _width - 1 && model[j][i+1]){//bottom
      count++;
    }
    if(0 < j && model[j-1][i]){//left
      count++;
    }
    if(j < _height - 1 && model[j+1][i]){//right
      count++;
    }
    if(0 < i && 0 < j && model[j-1][i-1]){//top left
      count++;
    }
    if(i < _width && j < _height && model[j+1][i+1]){//bottom right
      count++;
    }
    if(0 < i && j < _height && model[j+1][i-1]){//top right
      count++;
    }
    if(i < _width && 0 < j && model[j-1][i+1]){//bottom left
      count++;
    }
    return count;
  }
  
  void _resetBoard(){
    for(int i = 0; i < _height; i++){
      List<Cell> col = new List<Cell>();
      for(int j = 0; j < _width; j++){
        col.add(new Cell(new Point(j,i), j % 3 == 0));
      }
      model.add(col);
    }
  }
  
  int get height => _height;
  void set height(int value) {
    _height = value;
    _resetBoard();
  }
  
  int get width => _width;
  void set width(int value) {
    _width = value;
    _resetBoard();
  }
}

class Cell{
  final bool alive;
  final Point coord;
  Cell(Point this.coord, bool this.alive){}
}
