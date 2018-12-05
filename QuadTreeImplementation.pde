QuadTree qt;

Boundery mouseBounds;

int mouseBoundsSize = 100;

void setup(){
  size(501, 501);
  //fullScreen();
  qt = new QuadTree(new Boundery(0, 0, width-1, height-1));
  mouseBounds = new Boundery(mouseX - mouseBoundsSize / 2, mouseY - mouseBoundsSize / 2, mouseBoundsSize, mouseBoundsSize);
}

void draw(){
  background(0);
  mouseBounds.Move(mouseX - mouseBoundsSize / 2, mouseY - mouseBoundsSize / 2);
  
  ArrayList<Point> points = qt.GetAllPoints();
  
  for (Point p : points){
    p.Render();
  }
  
  qt.Render();
  noFill();
  strokeWeight(5);
  stroke(255, 0, 0);
  
  ArrayList<Point> pointsInRange = qt.QueryRange(mouseBounds);
  
  for (int i = pointsInRange.size() - 1; i >= 0; i--){
    if(mouseButton == RIGHT){
      qt.Remove(pointsInRange.get(i));
    }
  }
  
  strokeWeight(1);
  rect(mouseBounds.x, mouseBounds.y, mouseBounds.w, mouseBounds.h);
  
}

void mouseDragged(){
  if(mouseButton == LEFT)
  qt.Insert(new Point(mouseX, mouseY));
}
