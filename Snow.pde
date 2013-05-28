class Snow {

  PVector location;
  PVector velocity;

  Snow(float tempxPos, float tempyPos) {

    location = new PVector (tempxPos, tempyPos);
    velocity = new PVector (0, random(0.5, 1));
    velocity.mult(12);
    //velocity.mult(random(5,20));
    
  }

  void drawSnow() {
    stroke(255);
    strokeWeight(4);
    point (location.x, location.y);
  }

  void moveSnow() {
    location.add(velocity);
  }

  boolean isDead() {
    if (location.y > height + 100) {
       
      return true;
    } 
    else {
      return false;
    }
  }

  void loopSnow() {
    if (location.y > height) {
      location.y = 0;
    }
  }
}
