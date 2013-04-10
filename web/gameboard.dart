import 'package:web_ui/web_ui.dart';

class GameBoard extends WebComponent {
  List<List<int>>rows = new List<List<int>>();
  
  GameBoard(){
   for(int i = 0; i < 10; i++){
     List<int> col = new List<int>();
     for(int j = 0; j < 10; j++){
       col.add(i+j);
     }
     rows.add(col);
   }
  }
}
