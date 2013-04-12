library gol;
import 'dart:async';

class GameEngine{
  Set<Point> _model = new Set<Point>();
  StreamController<GameState> updateController = new StreamController();
  int _height = 0;
  int _width = 0;

  GameEngine(List<List<int>> initialModel){
    _model.clear();
    for(var i = 0; i < initialModel.length; i++){
      for(var j = 0; j< initialModel[i].length; j++){
        if(initialModel[i][j] == 1){
          _model.add(new Point(i,j));
        }
      }
    }
    _height = initialModel.length;
    _width = initialModel[0].length;
  }

  GameState get currentState => new GameState(new Set()..addAll(_model), width, height);
  Stream<GameState> get updates => updateController.stream;

  //Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  //Any live cell with two or three live neighbours lives on to the next generation.
  //Any live cell with more than three live neighbours dies, as if by overcrowding.
  //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
  void nextStep(){
    //process rules
    var nextModel = new Set<Point>();
    for(Point p in _model.expand(_computeNeighbors)){
      var neighborCount = _model.intersection(_computeNeighbors(p)).length;
      if((_model.contains(p) && neighborCount == 2) || neighborCount == 3){
        nextModel.add(p);
      }
    }
    _model
      ..clear()
      ..addAll(nextModel);
    updateController.add(new GameState(new Set()..addAll(_model), width, height));
  }

  Set<Point> _computeNeighbors(Point p){
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

  int get height => _height;
  void set height(int value) {
    _height = value;
  }

  int get width => _width;
  void set width(int value) {
    _width = value;
  }

  bool isPointAlive(Point point) => _model.contains(point);
}

class GameState{
  final Set<Point> cells;
  final int width;
  final int height;
  GameState(this.cells,this.width,this.height);
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
