class Point
{
  int x;
  int y;

  //function __construct(float _x, float _y) {...}
  public Point(int _x, int _y){
    x = _x;
    y = _y;
  }
  
  public void Render(){
    fill(0, 255, 0);
    noStroke();
    ellipse(x, y, 4, 4);
  }
}
