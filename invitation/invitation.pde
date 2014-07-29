import processing.pdf.*;

PImage glow;  // The background image, by Danielle Kefford.

void setup() {
  // postcard: from 3.5 x 5 to 4.25 x 6 
  // for 3.5 x 5, it'd be 1542.8572 x 1080
  // for 4.25 x 6, it'd be 1524.7059 x 1080
  // for 5 x 7, it'd be 1512.0 x 1080
  // for 8 x 10, it'd be 1350 x 1080
  // for 8.5 x 11, it'd be 1397.6471 x 1080
  // for 11 x 17, it'd be 1669.091 x 1080
  // formula: println(1080 * 5 / 3.5);

  glow = loadImage("glow-5x7.jpg");
  size(glow.width, glow.height);

  beginRecord(PDF, "invite.pdf"); 
  
  color black = color(0);
  
  image(glow, 0, 0);
  generateTitle(520, row(7));
  
  // Pretty standard grid typography stuff.
  place(520, row(2), "Bebas", 36, false, black, "The Grove / 760 Chapel St. New Haven, CT");
  place(520, row(3), "Bebas", 36, false, black, "Aug 15 - Sept 20");
  place(520, row(9), "Bebas", 64, false, black, "Art   Based   on   Code");
  place(520, row(11), "DejaVu Sans Condensed", 32, false, black, "Meet the Artists:");
  place(520, row(12), "DejaVu Sans Condensed", 32, false, black, "Reception August 15 at 8pm");
  
  String[] artists = loadStrings("artists.txt");
  for (int i = 0; i < artists.length; i++) {
    place(520, row(13+i), "DejaVu Sans Condensed", 24, false, black, artists[i]);
  }
  
  String[] curators = loadStrings("curators.txt");
  for (int i = 0; i < curators.length; i++) {
    place(450, row(21+i), "DejaVu Sans Condensed", 32, true, black, curators[i]);
  }
  
  String[] thanks = loadStrings("thanks.txt");
  for (int i = 0; i < thanks.length; i++) {
    place(1275, row(18+i), "DejaVu Sans Condensed", 32, true, black, thanks[i]);
  }
  
  // Show the typographical grid:
//  stroke(0, 255, 0);
//  for (int i = 0; i < 28; i++) {
//    line(0, row(i), width, row(i));
//  }
  
  endRecord();
  exit();
}

// A little helper for setting up the typographical grid.
int row(int rowNum) {
  return rowNum * 38;
}

// This is the only real generative part of this sketch.
// It makes a bunch of teal dots around the sketch, and
// moves them closer to the "re:generate" title - so much so
// that they (mostly) fill it up, and you can read it.
void generateTitle(int textx, int texty) {
  // Render the "re:Generate" to an invisible image (see createTitlePattern).
  // We'll use this to determine where the teal dots should aim for.
  PImage pattern = createTitlePattern(textx, texty);
  
  pushStyle();
  // Other colors I was considering:
  //  color teal = #4DC2FF;  // a nice light smurf blue
  //  color teal = #4DDDFF;   // a slightly-greener blue
  color teal = #31D3BF;   // a slightly darker green-blue
  fill(teal);
  noStroke();
  
  // Find all the bright pixels. (That's where the re:Generate is drawn.)
  for (int i = 0; i < pattern.pixels.length; i++) {
    // Only draw a teal dot, if we've found a bright pixel to aim for,
    // and only 20% of the time. (100% was just Too Many Teal Dots.)
    if (brightness(pattern.pixels[i]) > 250 && random(1) < 0.2) {
      
      // This is a common way to figure the (x,y) coordinates for an
      // index in a list of pixels.
      // This is the bright pixel we're aiming for. 
      int x = i % width;
      int y = floor(i / width);
      
      // Find some other random place to put a teal dot.
      int rx = round(random(width));
      int ry = round(random(height));
      
      // "Move" the teal dot part-way towards the (x,y) coord we're on. 
      PVector v = PVector.sub(new PVector(x, y), new PVector(rx, ry));
      // Move most teal dots very close to the target, but leave some stragglers.
      v.mult(1 - pow(random(1), 20));
      PVector v2 = PVector.add(v, new PVector(rx, ry));
      
      // Draw the teal dot at some random size between 2 & 8 pixels.
      float size = random(2, 8);
      ellipse(v2.x, v2.y, size, size);
    }
  }
  popStyle();
}

PImage createTitlePattern(int x, int y) {
  PGraphics g = createGraphics(width, height);
  g.beginDraw();
  g.background(0);
  g.fill(255);

  g.textFont(createFont("Bebas", 128));  // Bebas <3
  g.textAlign(LEFT);
  g.text("re:Generate", x, y);

  return g.get(0, 0, g.width, g.height);
}

void place(float x, float y, String fontName, float fontSize, boolean rightAlign, color c, String text) {
  pushStyle();
  textAlign(rightAlign ? RIGHT : LEFT);
  fill(c);
  textFont(createFont(fontName, fontSize));
  text(text, x, y);
  popStyle();
}
