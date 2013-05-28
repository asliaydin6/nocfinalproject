class Cloud {

  float x;
  float y;
  float w;
  float h;

  PVector location; 
  PVector velocity;   

  Cloud (float tempx, float tempy, float tempw, float temph) {

    x = tempx;
    y = tempy;
    w = tempw;
    h = temph;

    location = new PVector (tempx, tempy);    
    //velocity = new PVector (random(0.8, 1), 0);
    velocity = new PVector (random(1, 1.5), 0);
  }

  void drawCloud() {

    moveCloud();
    loopCloud();

    if (currentSeason == 0 ||currentSeason == 1 ) {
      fill(155);
    }
    else {
      fill (255);
    }

    x=location.x;
    noStroke();
    float z = x+50;
    for (float i=x; i< z; i++) {
      i = i + 25;
      ellipse (i, y, w, h);// cloud drawn by iteration
      ellipse(i-20, y+17, w, h);
      ellipse(i+20, y+17, w, h);
    }
  }

  void moveCloud() {
    location.add(velocity);
  }

  void loopCloud() {
    if (location.x > width) {
      location.x = -80;
    }
  }
}

