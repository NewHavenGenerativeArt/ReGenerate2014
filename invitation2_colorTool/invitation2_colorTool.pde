/*
PImage img;
 
 void setup() {
 img = loadImage("/home/dan/projects/p5j/regenerate2014/invitation2/glow-5x7.jpg");
 size(img.width, img.height);
 image(img, 0, 0);
 }
 
 void draw() {
 }
 
 void mouseClicked() {
 println(hex(get(mouseX, mouseY)));
 }
 */

color[] colors = new color[] {
  #FEFEFE, 
  #F8F0E3, 
  #FDEDD4, 
  #FFECCB, 
  #F8DCB4, 
  #FCDDA7, 
  #F4CC8E, 
  #F4C87F, 
  #F2BE68, 
  #EBB354, 
  #E8A83E, 
  #DE9E32, 
  #D89427, 
  #C58A22, 
  #B87A17, 
  #A86F15, 
  #8F5E11, 
  #754D08
};

void setup() {
  size(400, 700);

  background(0);

  float hueSum = 0;
  float satSum = 0;
  float valSum = 0;

  for (int i = 0; i < colors.length; i++) {
    fill(colors[i]);
    float y = map(i, 0, colors.length, 30, height);
    ellipse(50, y, 50, 50);
    
    fill(255);
    text(hue(colors[i]), 100, y);
    hueSum += hue(colors[i]);
    satSum += saturation(colors[i]);
    valSum += brightness(colors[i]);
  }
  
  println(hueSum / colors.length);  // 24.904135
  println(satSum / colors.length);
  println(valSum / colors.length);
  
  colorMode(HSB);
  color c = color(hueSum / colors.length, 
                  satSum / colors.length, 
                  valSum / colors.length);
  println(hex(c));
  fill(c);
  ellipse(width * 0.75, height*0.25, 100, 100);
  
  color teal = #31D3BF;
  fill(teal);
  ellipse(width * 0.75, height* 0.5, 100, 100);
  println(hue(teal));  // 122.25309
  
  float avgHue = hueSum / colors.length;
  float dist = hue(teal) - avgHue;
  float nextHue = (avgHue - dist + 255) % 255;
  println(nextHue);
  color next = color(nextHue, satSum / colors.length, valSum / colors.length);
  println(hex(next));
  fill(next);
  ellipse(width * 0.75, height * 0.75, 100, 100);
}

