abstract class LightbugPattern {
  abstract PImage render(PGraphics g);

  PImage asPImage() {
    PGraphics g = createGraphics(width, height);
    g.beginDraw();
    g.background(0);
    g.fill(255);

    render(g);

    g.endDraw();
    return g; // PGraphics extends PImage
  }

  void update() {
  }
}

abstract class TextyLightbugPattern extends LightbugPattern {
  protected PImage renderCentered(String text, PFont font, PGraphics g) {
    g.textFont(font);
    g.textAlign(CENTER, CENTER);
    g.text(text, g.width * 0.5, g.height * 0.5);
    return g;
  }
}

class LetterMorphLightbugPattern extends TextyLightbugPattern {
  String[] chars;
  long millisDelay;
  PFont font;

  LetterMorphLightbugPattern(String message, int secondsDelay) {
    chars = new String[message.length()];
    for (int i = 0; i < chars.length; i++) {
      chars[i] = str(message.charAt(i));
    }

    millisDelay = secondsDelay * 1000;
    font = createFont("Georgia Bold", 450);
  }

  PImage render(PGraphics g) {
    return renderCentered(currentLetter(), font, g);
  }

  private String currentLetter() {
    int i = int(millis() / millisDelay) % chars.length;
    return chars[i];
  }
}

class StaticTextLightbugPattern extends TextyLightbugPattern {
  private String text = " ";
  PFont font;

  StaticTextLightbugPattern(String text) {
    this.text = text;
    font = createFont("Georgia Bold", 350);
  }

  PImage render(PGraphics g) {
    return renderCentered(text, font, g);
  }
}

class WebCamThresholdLightbugPattern extends LightbugPattern {
  PImage cached;
  Capture cam;

  WebCamThresholdLightbugPattern(PApplet parent) {
    //println(Capture.list());
    String sizeString = "size=640x360";
    //println(sizeString);
    cam = new Capture(parent, "name=/dev/video0," + sizeString + ",fps=15");
    cam.start();
  }

  PGraphics render(PGraphics g) {
    if (cam.available()) {
      cam.read();
      g.scale(-2.0, 2.0);
      g.image(cam, -cam.width, 0);
      g.filter(GRAY);
      g.filter(THRESHOLD, bestThresholdLevel(cam));
      cached = g.get(0, 0, g.width, g.height);
    } else if (cached != null) {
      g.image(cached, 0, 0);
    }
    return g;
  }

  float bestThresholdLevel(PImage img) {
    float avgLevel = averageLevel(img);
    return avgLevel / 255.0;
  }

  float averageLevel(PImage img) {
    img.loadPixels();
    long sum = 0;
    for (int i = 0; i < img.pixels.length; i++) {
      sum += brightness(img.pixels[i]);
    }
    return (float)sum / img.pixels.length;
  }
}



class WebCamDiffLightbugPattern extends LightbugPattern {
  PImage original;
  long originalTimestamp;
  long maxOriginalAge = 50000000;
  
  PImage cached;
  Capture cam;

  WebCamDiffLightbugPattern(PApplet parent) {
    String sizeString = "size=640x360";
    cam = new Capture(parent, "name=/dev/video0," + sizeString + ",fps=15");
    cam.start();
  }
  
  boolean originalIsStale() {
    return System.currentTimeMillis() - originalTimestamp > maxOriginalAge;
  }
  
  void reset() {
    original = null;
  }

  PGraphics render(PGraphics g) {
    if (cam.available()) {
      cam.read();

      if (original == null || originalIsStale()) {
        original = cam.get(0, 0, cam.width, cam.height);
        original.loadPixels();
        originalTimestamp = System.currentTimeMillis();
      }

      PImage raw = cam.get(0, 0, cam.width, cam.height);
      raw.blend(original, 0, 0, raw.width, raw.height, 0, 0, raw.width, raw.height, DIFFERENCE);
      raw.filter(GRAY);
      raw.filter(THRESHOLD, bestThresholdLevel(raw));
//      raw.blend(raw, 0, 0, raw.width, raw.height, 0, 0, raw.width, raw.height, MULTIPLY);

      g.scale(-2.0, 2.0);
      g.image(raw, -raw.width, 0);
      cached = g.get(0, 0, g.width, g.height);
    } else if (cached != null) {
      g.image(cached, 0, 0);
    }
    return g;
  }

  float bestThresholdLevel(PImage img) {
    float avgLevel = averageLevel(img);
    return avgLevel / 255.0;
  }

  float averageLevel(PImage img) {
    img.loadPixels();
    long sum = 0;
    for (int i = 0; i < img.pixels.length; i++) {
      sum += brightness(img.pixels[i]);
    }
    return (float)sum / img.pixels.length;
  }
}

