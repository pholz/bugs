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
  public float theta;
  public ArrayList<Segment> segments;

  public Bug(PVector _pos, PVector _vel)
  {
    pos = _pos;
    vel = _vel;
    
    theta = .0f;

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
    //stroke(color(200, 0, 0));
    noStroke();

    pushMatrix();

    translate(pos.x, pos.y);
    ellipse(0, 0, 25, 25);

    popMatrix();

    fill(color(0));
    beginShape();

    PVector nh = new PVector(vel.x, vel.y);

    float th = nh.x;
    nh.x = nh.y;
    nh.y = -th;
    nh.normalize();
    nh.mult(12.0f);

    PVector resh = PVector.sub(pos, nh);

    curveVertex(pos.x, pos.y);
    curveVertex(pos.x, pos.y);
    //curveVertex(resh.x, resh.y);
    curveVertex(resh.x, resh.y);

    for(int i = 0; i < segments.size(); i++)
    {
      Segment s = segments.get(i);

      PVector n = new PVector(s.vel.x, s.vel.y);

      float t = n.x;
      n.x = n.y;
      n.y = -t;
      n.normalize();
      n.mult(12.0f);

      PVector res = PVector.sub(s.pos, n);

      curveVertex(res.x, res.y);

      // segments.get(i).draw();
    }

    for(int i = segments.size()-1; i >= 0; i--)
    {
      Segment s = segments.get(i);

      PVector n = new PVector(s.vel.x, s.vel.y);

      float t = n.x;
      n.x = n.y;
      n.y = -t;
      n.normalize();
      n.mult(12.0f);

      PVector res = PVector.add(s.pos, n);
      curveVertex(res.x, res.y);
    }

    resh = PVector.add(pos, nh);

    curveVertex(resh.x, resh.y);
   // curveVertex(resh.x, resh.y);
    curveVertex(pos.x, pos.y);
    curveVertex(pos.x, pos.y);
    endShape();
  }
}

ArrayList<Bug> bugs;
float last;

float randomNormal()
{
  float x = 1.0, y = 1.0, 
        s = 2.0; // s = x^2 + y^2
  while(s >= 1.0)
  {
    x = random(-1.0f, 1.0f);
    y = random(-1.0f, 1.0f);
    s = x*x + y*y;
  }
  return x * sqrt(-2.0f * log(s)/s);
}

void setup()
{
  size(1024, 768);
  smooth();

  bugs = new ArrayList<Bug>();

  for(int i = 0; i < 50; i++)
  {
    bugs.add(new Bug(new PVector(random(0, width), random(0,height), 0), new PVector(random(-10.0f,10.0f), 0, 0)));
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
    Bug b = bugs.get(i);
    float mg = b.vel.mag();
    b.theta = atan2(b.vel.y, b.vel.x);
    b.theta += randomNormal() * .05f;
    
    if(b.pos.x < 0 || b.pos.y < 0 || b.pos.x > width || b.pos.y > height)
    {
      PVector to = PVector.sub( (new PVector(width/2, height/2)), b.pos);
       b.theta = atan2(to.y, to.x);
    }
    
    mg += (randomNormal() * 5.0f);
    mg = constrain(mg, 5.0f, 35.0f);

    bugs.get(i).vel.x = cos(b.theta) * mg;
    bugs.get(i).vel.y = sin(b.theta) * mg;
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

