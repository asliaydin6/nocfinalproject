import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer fourSeason;

PImage fourseasons;

int currentSeason =0;
int timeCounter = 0;

long timeMark =0;
long timeThreshold = 30000;

//the tree//
float transparency = 150;
color leafColor = color(5, 113, 3, transparency);
color targetLeafColor = color(5, 113, 3, transparency);
color veinColor = color(5, 113, 3, transparency/2);
color branchColor = color(30);
color grassColor1 = color (15, 120, 0);
color grassColor2 = color (20, 145, 0, 150);
color grassTargetColor1 = color(255);
color grassTargetColor2 = color(255);
color sunColor = color (231, 234, 52);
color targetsunColor = color (231, 234, 52);
color skyColor = color(255);
color targetColor = color(255);
color flowerColor = color(255);
color targetFlowerColor = color(255);   
color flowercenterColor = color(255, 255, 0);
color targetFlowercenterColor = color(255, 255, 0);

//branch controls
int nTrees = 1; //the number of trees
int nSegments;
float totalBranchLength; 
float maxBranchThickness; 
float minBranchThickness; 
float minSpawnDistance; //this controls how far the branch will grow before splitting
float branchSpawnOdds;   //the odds of a branch growing there
float branchSpawnOddsOfSecond; //odds of a second branch growing from the same node
float mindThetaSplit; 
float maxdThetaSplit; 
float maxdThetaWander;
float dBranchSize; //the new branch may change by 1.0+/- this amount

//leaf controls
float minLength; //leaf length 
float maxLength; //leaf length
float minWidth;  //leaf width as a factor of length 
float maxWidth;  //leaf width as a factor of length
float maxBranchSizeForLeaves; 
float leafSpawnOdds;

branch[] branches;

//boolean pauseWind = false;
boolean drawWind = false;
boolean drawVeins = false;
boolean blackLeaves = false;
boolean drawLeaves = true;
boolean drawFlower = false;

ArrayList<Snow> s = new ArrayList<Snow>();
boolean createSnow = false;
ArrayList<Rain> r = new ArrayList<Rain>();
boolean createRain = false;

Cloud c; 
Cloud c1; 
Cloud c2;
Cloud c3; 
Cloud c4; 
Cloud c5;
Cloud c6; 
Cloud c7;

Flower[] flowers = new Flower[50];

float timeX = 50;
float currentWindSpeed = 0;

void setup() {
  size(800, 600, P2D);

  minim = new Minim(this);
  fourSeason = minim.loadFile("FourSeasons.mp3", 2048);
  fourSeason.loop();

  frameRate(30);
  smooth();
  noStroke();

  fourseasons = loadImage("four.jpg");

  initializeTreeValues();

  windDirection = 0;
  windVelocity = 0;
  defineLeafOutline();
  defineVeins();

  generateBranches();
  redrawTrees();

  c = new Cloud(10, 50, 30, 30);
  c1 = new Cloud(150, 75, 30, 30);
  c2 = new Cloud(300, 50, 30, 30);
  c3 = new Cloud(450, 25, 30, 30);
  c4 = new Cloud(600, 75, 30, 30);
  c5 = new Cloud(750, 25, 30, 30);

  for (int i=0;i<flowers.length;i++) {
    flowers[i] = new Flower();
  }
}

void draw() {
  background(26, 44, 26);
  image (fourseasons, 0, 545);
  //rect(50, 500, 700, 50);
  stroke(255);
  strokeWeight(4);
  line(timeX, 570, timeX, 590);
  textSize(15);
  fill(255);
  //text("January February March April May June July August     September October November December", 55, 550); 

  timeX = timeX + 2;
  if (timeX > 750) {
    timeX = 50;
  } 

  skyColor = lerpColor(skyColor, targetColor, 0.1);
  leafColor = lerpColor(leafColor, targetLeafColor, 0.1);
  sunColor = lerpColor (sunColor, targetsunColor, 0.1);
  grassColor1 = lerpColor(grassColor1, grassTargetColor1, 0.01);
  grassColor2 = lerpColor(grassColor2, grassTargetColor2, 0.01);
  flowerColor = lerpColor(flowerColor, targetFlowerColor, 0.01);
  flowercenterColor = lerpColor(flowercenterColor, targetFlowercenterColor, 0.01);

  fill(skyColor);
  noStroke();
  smooth();
  rect (0, 0, width, 400);
  triangle(0, 400, 300, 437, width, 350);
  //end of the sky//

  fill (sunColor);
  ellipse (80, 40, 150, 150);

  //hills in background//
  noStroke();
  smooth();
  fill(grassColor1);
  triangle(width, 350, width, 500, 300, 437);
  fill(grassColor2);
  quad(0, 350, width, 450, width, 540, 0, 540);
  //end of hill drawing//

  /////flower///
  for (int i=0;i<flowers.length;i++) {
    flowers[i].drawFlower();
  }  
  ///flower//
  //changeFlower();

  changeSeason();
  checkTime();

  ////snow//////
  if (createSnow) {
    s.add(new Snow (random(width), -10));
  }

  for (int i = s.size()-1; i >= 0; i--) {
    Snow snowFlake = s.get(i);
    snowFlake.drawSnow();
    snowFlake.moveSnow();

    if (createRain) {
      s.remove(i);
    } 
    else if (snowFlake.isDead()) {
      s.remove(i);
    }
  }

  ////rain///
  if (createRain) {
    for (int i = 0; i < 10; i++) {
      float x1 =  random(width); 
      float x2 = x1 - 2;
      float y1 = -8;
      float y2 = y1 + random (5, 10);
      r.add(new Rain (x1, y1, x2, y2));
    }
  }

  for (int i = r.size()-1; i >= 0; i--) {
    Rain rainDrop = r.get(i);
    rainDrop.drawRain();
    rainDrop.moveRain();

    if (rainDrop.isDead()) {
      r.remove(i);
    }
  }
  //clouds//
  c.drawCloud();   
  c1.drawCloud();   
  c2.drawCloud();
  c3.drawCloud();   
  c4.drawCloud();   
  c5.drawCloud();

  pushMatrix();
  //CHANGES THE LOCATION OF THE TREE
  translate(200, -60);
  updateWind(currentWindSpeed);

  //move in the wind!
  for (int i = 0; i<nTrees; i++)
    branches[i].rotateDueToWind();

  redrawTrees();

  //draw the wind line
  if (drawWind)
    drawWindLine();
  popMatrix();

  //THE WINDOW FRAME//
  //  fill (200, 192, 179);
  //  rect (0, height/2, 800, 30);
  //  rect (width/2, 0, 30, 700);
  //  fill(211, 41, 55);
  //  triangle (0, 0, 100, 0, 0, 700);
  //  triangle (0, 100, 0, height, 100, height);  
  //  triangle (700, 0, 800, 0, 800, 700);
  //  triangle (width, 100, width, height, 700, height); 
  //  fill(0);
  //  rect (0, 350, 50, 8);
  //  rect (750, 350, 50, 8);
}

void redrawTrees() {
  drawBranches();
  if (drawLeaves)
    drawLeaves();
}
void drawBranches() {
  stroke(branchColor);
  for (int i = 0; i<nTrees; i++)
  branches[i].drawBranch(new float[] {
    (1+i)*(width/(1+nTrees)), height
  }
  );
}

void drawLeaves() {
  noStroke();
  fill(leafColor);
  //draw leaves
  for (int i = 0; i<nTrees; i++)

  branches[i].drawLeaves(new float[] {
    (1+i)*(width/(1+nTrees)), height
  }
  );
}

void drawWindLine() {
  stroke(0);
  int dx= 100;
  int dy = 100;
  line(dx, dy, dx+50*windVelocity*cos(windDirection), dy+50*windVelocity*sin(windDirection));
  noStroke();
  fill(0);
  ellipse(dx, dy, 3, 3);
}

void initializeTreeValues() {
  drawWind = false;
  drawVeins = false;
  blackLeaves = false;
  drawLeaves = true;

  //branch
  nSegments = 15;
  totalBranchLength = 400;
  maxBranchThickness = 10;
  maxBranchSizeForLeaves = 4;
  minBranchThickness = 2; 
  minSpawnDistance = .2;
  branchSpawnOdds = .8; 
  branchSpawnOddsOfSecond = 0;
  mindThetaSplit = PI*.1;
  maxdThetaSplit = PI*.3;
  maxdThetaWander = PI/20;
  dBranchSize = .2;

  //leaves
  minLength = 10;
  maxLength = 30;
  minWidth = .4;
  maxWidth = .5;
  maxBranchSizeForLeaves = 4;
  leafSpawnOdds = .7;
  generateBranches();
}

void changeSeason() {

  //winter
  if (currentSeason == 0) {
    //change the sky color
    targetColor = color(52, 48, 48);
    grassTargetColor1 = color(255);
    grassTargetColor2 = color(255);
    createRain = false;
    createSnow = true; 
    //change the tree
    targetLeafColor = color(5, 113, 3, 0);


    //windVelocity = 6*noise(velOff)-1;
    currentWindSpeed = 8;

    targetsunColor = color (80, 40, 150, 0);
    drawFlower = false;
    flowerColor = color(255, 0);
    targetFlowerColor = color(255, 0);
    flowercenterColor = color(255, 255, 0, 0);
    targetFlowercenterColor = color(255, 255, 0, 0);
  }

  //fall
  if (currentSeason == 1) {
    //change the sky color
    targetColor = color(52, 148, 148);
    grassTargetColor1 = color(83, 113, 81);
    grassTargetColor2 = color(52, 90, 46);
    createRain = true;
    createSnow = false;
    //change the tree
    targetLeafColor = color(102, 34, 0, transparency);

    //windVelocity = 10*noise(velOff)-1;
    currentWindSpeed = random(-8, 10);

    targetsunColor = color (80, 40, 150, 10);
    drawFlower = false;
    flowerColor = color(255, 0);
    targetFlowerColor = color(255, 0);
    flowercenterColor = color(255, 255, 0, 0);
    targetFlowercenterColor = color(255, 255, 0, 0);
  }

  ///summer
  if (currentSeason == 2) {
    //change the sky color
    targetColor = color(100, 180, 200);
    grassTargetColor1 = color(83, 150, 81);
    grassTargetColor2 = color(83, 200, 81);
    targetsunColor = color (231, 234, 52);
    createRain = false;
    createSnow = false;
    //change the tree
    targetLeafColor = color(5, 113, 3, transparency);

    //windVelocity = 2*noise(velOff)-1;
    currentWindSpeed = 0;

    drawFlower = true;
    flowerColor = color(255);
    targetFlowerColor = color(255);
    flowercenterColor = color(255, 255, 0);
    targetFlowercenterColor = color(255, 255, 0);
  }

  //spring
  if (currentSeason == 3) {
    //change the sky color
    targetColor = color(21, 109, 193);
    grassTargetColor1 = color(83, 113, 81);
    grassTargetColor2 = color(52, 90, 46);
    //grassTargetColor2 = color(62, 155, 37);
    createRain = true;
    createSnow = false;
    //change the tree
    targetLeafColor = color(255, 113, 100, transparency);

    //windVelocity = 4*noise(velOff)-1;
    currentWindSpeed = 4;

    targetsunColor = color (80, 40, 150, 0);
    drawFlower = true;
    flowerColor = color(255, 113, 100, transparency);
    targetFlowerColor = color(255, 113, 100, transparency);
    flowercenterColor = color(255, 255, 0);
    targetFlowercenterColor = color(255, 255, 0);
  }
}

void checkTime() {
  if (timeX > 50 && timeX < 160) {
    currentSeason = 0;
  } 
  else if (timeX > 170 && timeX < 280) {
    currentSeason = 3;
  }
  else if (timeX > 288 && timeX < 440) {
    currentSeason = 2;
  }
  else if (timeX > 436 && timeX < 670) {
    currentSeason = 1;
  }
  else if (timeX > 650 && timeX < 750) {
    currentSeason = 0;
  }
}  
void stop() { 
  fourSeason.close(); 
  minim.stop();
  super.stop();
}
