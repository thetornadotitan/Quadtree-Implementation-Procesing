class Boundery
{
  private int x;
  private int y;
  private int w;
  private int h;

  //function __construct(XY center, float halfDimension) {...}
  public Boundery(int _x, int _y, int _w, int _h){
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  //function containsPoint(XY point) {...}
  public boolean ContainsPoint(Point p){
    boolean result = false;
    
    if(p.x >= x && p.x < x + w && p.y >= y && p.y < y + h)
    result = true;
    
    return result;
  }
  
  //function intersectsAABB(AABB other) {...}
  public boolean Intersects(Boundery b){
    boolean result = false;
    
    if((x + w >= b.x && y + h >= b.y)
    && (x < b.x + b.w && y < b.y + b.h))
    result = true;
    
    return result;
  }
  
  public void Move(int _x, int _y){
    x = _x;
    y = _y;
  }
}
