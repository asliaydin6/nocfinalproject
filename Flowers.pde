
class Flower {

  int numFlow= 15;
  float deg= 360/numFlow;
  float x;
  float y;
  Flower() {

    x = random (0, 600);
    y = random (470, 500);
  }

  void drawFlower() {

    pushMatrix();
    translate (x, y);
    scale (0.3);
    fill (flowercenterColor);
    //stroke (0);
    ellipse (0, 0, 50, 50);

    ///flower
    fill(flowerColor);
    strokeWeight(1);

    for (int i=0; i<numFlow;i++) {
      pushMatrix();
      scale(0.5);
      float rad = radians(deg*i);
      rotate (rad);
      translate (0, -60);
      ellipse (0, 0, 30, 70);
      popMatrix();
    }
    //End center translate
    popMatrix();
  }
}

//void changeFlower() {
////  if (currentSeason == 2) {
////    flowerColor = color(83, 150, 81);
////    targetFlowerColor = color(83, 200, 81);
////    drawFlower = true;
////  }
//  if (currentSeason == 1) {
//    flowerColor = color(255, 180);
//    targetFlowerColor = color(0, 180);
//    drawFlower = false;
//  }
//}

//winter 0
//  fall 1
//  summer 2
//  spring 3

