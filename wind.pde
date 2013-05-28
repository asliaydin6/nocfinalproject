float windDirection;
float windVelocity;
float velIncrement = 0.04;
float velOff = 0;

void updateWind(float windSpeed){
  velOff+= velIncrement;
  windDirection = (windDirection+random(-1,-1)*.001+TWO_PI)%TWO_PI;
  windVelocity = (windSpeed) *noise(velOff)-1;

  println(windVelocity);
}
 
