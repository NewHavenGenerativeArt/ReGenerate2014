import processing.video.*;

LightbugPattern[] patterns;
WebCamDiffLightbugPattern camDiff;

void setup() {
  size(1280, 720);
  
  patterns = new LightbugPattern[] {
    camDiff = new WebCamDiffLightbugPattern(this),
    new WebCamThresholdLightbugPattern(this),
//    echoer = new TypeEchoLightbugPattern(),
    new StaticTextLightbugPattern("bugs!"),
//    new LetterMorphLightbugPattern("abc SOS 1234567890 SOS ", 3),
  };
  
  makeLightbugs(1000);
  
  background(0);
  noStroke();
  colorMode(HSB);
}

boolean showImage;  
void keyTyped() {
  if (key == ' ') { showImage = !showImage; }
  if (key == 'r') { camDiff.reset(); }
}

void draw() {
  //background(0);
  pushStyle();
  fill(0, 80);
  rect(0, 0, width, height);
  popStyle();
  
  PImage pattern = patterns[patternNum].asPImage();
  //pattern.resize(640, 480);  // This might be useful - so patterns don't CARE what size they need to be.
  
  if (showImage) { image(pattern, 0, 0); }
  moveLightbugs(pattern);
  patterns[patternNum].update();
  drawLightbugs();
}

int patternNum = 0;
void mouseClicked() {
  patternNum = (patternNum + 1) % patterns.length;
}

