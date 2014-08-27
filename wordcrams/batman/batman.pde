import wordcram.*;
import java.awt.*;
import processing.pdf.*;

void setup() {
  PImage image = loadImage("batman-aspect-ratio.gif");
  size(image.width, image.height, PDF, "batman.pdf");

  background(#110000);

  ShapeBasedPlacer placer = sbp(image, #000000);

  new WordCram(this).
    fromWebPage("http://en.wikipedia.org/wiki/Batman").
    withPlacer(placer).
    withNudger(placer).
    minShapeSize(4).
    sizedByWeight(7, 50).
    angledAt(radians(75)).
    maxNumberOfWordsToDraw(500).
    withFont("Fira Sans Heavy").
    withColor(#DBC900).
    withStopWords("Wikipedia Retrieved Archived pg article ISBN get").
    drawAll();

  println("done!");
}

ShapeBasedPlacer sbp(PImage image, color c) {
  Shape imageShape = new ImageShaper().shape(image, c);
  return new ShapeBasedPlacer(imageShape);
}

