class Rain {

  PVector location1;
  PVector location2;
  PVector velocity;
  

  Rain(float tempxPos1, float tempyPos1, float tempxPos2, float tempyPos2) {

    location1 = new PVector (tempxPos1, tempyPos1);
    location2 = new PVector (tempxPos2, tempyPos2);
    velocity = new PVector (-0.5, 5);
    velocity.mult(random(5, 20));
  }


  void drawRain() {
    //stroke(125);
    stroke (45, 45, 45);
    strokeWeight(2);
    line(location1.x, location1.y, location2.x, location2.y);
  }

  void moveRain() {
    location1.add(velocity);
    location2.add(velocity);
  }

  boolean isDead() {
    if (location1.y > height) {
      return true;
    } 
    else {
      return false;
    }
  }
}

