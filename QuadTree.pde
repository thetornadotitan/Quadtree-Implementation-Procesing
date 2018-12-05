class QuadTree
{
  // Arbitrary constant to indicate how many elements can be stored in this quad tree node
  private final int QT_NODE_CAPACITY = 4;

  // Axis-aligned bounding box stored as a center with half-dimensions
  // to represent the boundaries of this quad tree
  //AABB boundary;
  private Boundery bounds;

  // Points in this quad tree node
  //Array of XY [size = QT_NODE_CAPACITY] points;
  private ArrayList<Point> points = new ArrayList<Point>();

  // Children
  private QuadTree tl;
  private QuadTree tr;
  private QuadTree bl;
  private QuadTree br;

  // Methods
  //function __construct(AABB _boundary) {...}
  public QuadTree(Boundery b){
    bounds = b;
  }
  
  //function insert(XY p) {...}
  public boolean Insert(Point p)
  {
    // Ignore objects that do not belong in this quad tree
    if (bounds.ContainsPoint(p) == false)
      return false; // object cannot be added

    // If there is space in this quad tree and if doesn't have subdivisions, add the object here
    if (points.size() < QT_NODE_CAPACITY && tl == null)
    {
      points.add(p);
      return true;
    }

    // Otherwise, subdivide and then add the point to whichever node will accept it
    if (tl == null)
      Subdivide();

    if (tl.Insert(p)) return true;
    if (tr.Insert(p)) return true;
    if (bl.Insert(p)) return true;
    if (br.Insert(p)) return true;

    // Otherwise, the point cannot be inserted for some unknown reason (this should never happen)
    return false;
  }
  
  //function remove(XY p) {...}
  public boolean Remove(Point p){
    
    boolean result = false;
    
    // Ignore objects that do not belong in this quad tree
    if (bounds.ContainsPoint(p) == false)
      return false; // object cannot be removed
    
    result = points.remove(p);
      
    if(tl != null){
      if (tl.Remove(p)) result = true;
      if (tr.Remove(p)) result = true;
      if (bl.Remove(p)) result = true;
      if (br.Remove(p)) result = true;
    }
    
    if(IsEmpty())result = Collapse();
    
    // Otherwise, the point cannot be removed because it does not exist. (Should not happen as you should never try to remove a non-existant point)
    return result;
  }
  
  public Boolean Move(Point p, int x, int y){
    if(!Remove(p)) return false;
    p = new Point(x, y);
    if(!Insert(p)) return false;
    return true;
  }
  
  //function subdivide() {...} // create four children that fully divide this quad into four quads of equal area
  private void Subdivide(){
    tl = new QuadTree(new Boundery(bounds.x, bounds.y, bounds.w / 2, bounds.h /2));
    tr = new QuadTree(new Boundery(bounds.x + bounds.w / 2, bounds.y, bounds.w / 2, bounds.h / 2));
    bl = new QuadTree(new Boundery(bounds.x, bounds.y + bounds.h / 2, bounds.w / 2, bounds.h /2));
    br = new QuadTree(new Boundery(bounds.x + bounds.w / 2, bounds.y + bounds.h / 2, bounds.w / 2, bounds.h /2));
  }
  
  private boolean Collapse(){
    tl = null;
    tr = null;
    bl = null;
    br = null;
    return true;
  }
   
  //function queryRange(AABB range) {...}
  public ArrayList<Point> QueryRange(Boundery b){
    // Prepare an array of results
    ArrayList<Point> pointsInRange = new ArrayList<Point>();

    // Automatically abort if the range does not intersect this quad
    if (!bounds.Intersects(b))
      return pointsInRange; // empty list

    // Check objects at this quad level
    for (int p = 0; p < points.size(); p++)
    {
      if (b.ContainsPoint(points.get(p)))
        pointsInRange.add(points.get(p));
    }

    // Terminate here, if there are no children
    if (tl == null)
      return pointsInRange;

    // Otherwise, add the points from the children
    pointsInRange.addAll(tl.QueryRange(b));
    pointsInRange.addAll(tr.QueryRange(b));
    pointsInRange.addAll(bl.QueryRange(b));
    pointsInRange.addAll(br.QueryRange(b));

    return pointsInRange;
  }
  
  public boolean IsEmpty(){
    boolean result = true;
    
    result = points.size() == 0;
    
    if(tl != null){
      if(tl.IsEmpty() && tr.IsEmpty() && bl.IsEmpty() && br.IsEmpty()){
        result = true;
      }else{
        result = false;
      }
    }
    
    return result;
  }
  
  public ArrayList<Point> GetAllPoints(){
    ArrayList<Point> result = new ArrayList<Point>();
    
    if(tl != null){
      result.addAll(tl.GetAllPoints());
      result.addAll(tr.GetAllPoints());
      result.addAll(bl.GetAllPoints());
      result.addAll(br.GetAllPoints());
    }
    
    result.addAll(points);
    
    return result;
  }
  
  public void Render(){
    noFill();
    stroke(255);
    strokeWeight(1);
    
    rect(bounds.x, bounds.y, bounds.w, bounds.h);
    
    if(tl != null){
      tl.Render();
      tr.Render();
      bl.Render();
      br.Render();
    }
  }
}
