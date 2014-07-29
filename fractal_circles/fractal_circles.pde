import processing.pdf.*;

void setup() {
  size(800, 800);
  noStroke();
}

void draw() {
  //beginRecord(PDF, "circles.pdf");  // Uncomment this to save to a PDF
  background(255);
  recurse(0, 0, width, height);
  //endRecord();  // Uncomment this to save to a PDF
}

float pStopRecursing = 0.35; // The odds that we stop recursing.
float pDrawACircle = 0.75;   // The odds that, when we stop, we draw a circle.

void recurse(double left, double top, double right, double bottom) {
  double minSize = 12;
  double wide = right - left;
  double high = bottom - top;
  
  if (random(1) < pStopRecursing || wide < minSize || high < minSize) {
    if (random(1) < pDrawACircle) {
      pickACircle().draw(left, top, wide);
    }
  } 
  else {
    if (wide >= high) {
      double middle = (right + left) * 0.5;
      recurse(left, top, middle, bottom);
      recurse(middle, top, right, bottom);
    } else {
      double middle = (top + bottom) * 0.5;
      recurse(left, top, right, middle);
      recurse(left, middle, right, bottom);
    }
  }
}

Circle thick = new Circle(1 - (0.85 * 0.5));
Circle solid = new Circle(1);
Circle[] choices = new Circle[] { thick, solid };

Circle pickACircle() {
  return choices[floor(random(choices.length))];
}

class Circle {
  float strokeWeightPercentOfSize;

  Circle(float sizePercent) {
    strokeWeightPercentOfSize = sizePercent;
  }

  void draw(double top, double left, double size) {
    double halfSize = size * 0.5;
    double centerX = top + halfSize;
    double centerY = left + halfSize;
    double outerSize = size * 0.95;
    double innerSize = size * (1-strokeWeightPercentOfSize);
    
    ellipseMode(CENTER);
    fill(0);  // black
    ellipse((float)centerX, (float)centerY, (float)outerSize, (float)outerSize);
    fill(255); // white
    ellipse((float)centerX, (float)centerY, (float)innerSize, (float)innerSize);
  }
}
