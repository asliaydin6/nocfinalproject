
//I CHANGED THIS NUMBER TO CHANGE THE NUMBER OF LEAVES GENERATED
int nLeafPoints = 20;
float[] xOutline;
float[] yOutline;
void defineLeafOutline() {
  xOutline = new float[nLeafPoints];
  yOutline = new float[nLeafPoints];
  for (int i=0; i<=nLeafPoints/2;i++) {
    xOutline[i] = 2*i/(float)(nLeafPoints);
    yOutline[i] = (-pow((xOutline[i]-.5), 2)+.25)*2;

    if (i>0 && i<=nLeafPoints/2) {
      xOutline[nLeafPoints-i] = xOutline[i];
      yOutline[nLeafPoints-i] = -yOutline[i];
    }
  }
}

float[] xVeins;
float[] yVeins;

void defineVeins() {
  xVeins = new float[4];
  yVeins = new float[4];
  xVeins[0] = .2;
  xVeins[1] = .25;
  xVeins[2] = .4;
  xVeins[3] = .47;

  yVeins[0] = 0;
  yVeins[1] = .3;
  yVeins[2] = 0;
  yVeins[3] = .45;
}

float tempx;
float tempy;
//leafWidth is a fraction of leafLength
void drawLeaf(float x, float y, float leafLength, float leafWidth, float direction) {
  beginShape();
  for (int i=0; i<xOutline.length;i++) {
    tempx = xOutline[i]*cos(direction)*leafLength-yOutline[i]*sin(direction)*leafWidth*leafLength;
    tempy = xOutline[i]*sin(direction)*leafLength+yOutline[i]*cos(direction)*leafWidth*leafLength;
    vertex(x+tempx, y+tempy);
  }
  endShape(CLOSE);
}

float vx1, vx2, vy1, vy2;
void drawVeins(float x, float y, float leafLength, float leafWidth, float direction) {
  //  strokeWeight(leafLength/40);
  strokeWeight(1);
  stroke(leafColor);
}

