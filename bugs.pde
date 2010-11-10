import java.util.*;


class Segment
{
  PVector pos, vel;
  
  public Segment(PVector _pos)
  {
    pos = _pos;
    vel = new PVector(0,0,0);
  }
  
  public void update(float dt)
  {
     pos.add(PVector.mult(vel, dt)); 
  }
  
  public void draw()
  {
     pushMatrix();
     fill(color(150));
     translate(pos.x, pos.y);
     ellipse(0, 0, 15, 15);
     
     popMatrix();
  }  
}

class Bug
{
   public PVector pos, vel;
   
   public ArrayList<Segment> segments;
  
   public Bug(PVector _pos, PVector _vel)
   {
     pos = _pos;
     vel = _vel;
     
     segments = new ArrayList<Segment>();
     
     segments.add(new Segment(PVector.add(pos, new PVector(-20, -20, 0))));
     for(int i = 1; i < 3; i++)
     {
        segments.add(new Segment(PVector.add(segments.get(i-1).pos, new PVector(-20, -20, 0)  ) )  );
     }
   }
   
   public void update(float dt)
   {
      pos.add(PVector.mult(vel, dt)); 
      
      segments.get(0).vel = PVector.sub(pos, segments.get(0).pos);
      //segments.get(0).vel.normalize();
      //segments.get(0).vel.mult(vel.mag());
      segments.get(0).update(dt);
      
      for(int i = 1; i < segments.size(); i++)
      {
         segments.get(i).vel = PVector.sub(segments.get(i-1).pos, segments.get(i).pos);
         //segments.get(i).vel.normalize();
         //segments.get(i).vel.mult(segments.get(i-1).vel.mag());
         
         segments.get(i).update(dt);
      }
   }
   
   public void draw()
   {
     fill(color(0));
     stroke(color(200, 0, 0));
     
     pushMatrix();
     
     translate(pos.x, pos.y);
     ellipse(0, 0, 15, 15);
     
     popMatrix();
     
     for(int i = 0; i < segments.size(); i++)
     {
       segments.get(i).draw();
     }
     
     
   }
}

ArrayList<Bug> bugs;
float last;

void setup()
{
    size(1024, 768);
    smooth();
    
    bugs = new ArrayList<Bug>();
    
    for(int i = 0; i < 5; i++)
    {
       bugs.add(new Bug(new PVector(random(0, width), random(0,height), 0), new PVector(0, 0, 0))); 
    }
    
    last = (float) millis() / 1000.0f;
}

void update()
{
    float now = (float) millis() / 1000.0f;
    float dt = now - last;
    last = now;
  
    for(int i = 0; i < bugs.size(); i++)
    {
       bugs.get(i).vel.x += (random(-1.0f, 1.0f));
       bugs.get(i).vel.y += (random(-1.0f, 1.0f));
       bugs.get(i).update(dt); 
    }
}

void draw()
{
    update();
    
    background(color(255));
    
    for(int i = 0; i < bugs.size(); i++)
    {
       bugs.get(i).draw(); 
    }
}
