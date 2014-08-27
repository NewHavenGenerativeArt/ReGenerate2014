import wordcram.*;
import java.awt.*;
import processing.pdf.*;

PImage img;
PShape logo;

void setup() {
  //img = loadImage("/home/dan/Desktop/swoosh.png");
  //img.resize(1200, 0);
  //size(img.width, img.height);
  size(1000, 680, PDF, "cokecram.pdf");
//  println(1402f / 954);
//  println(1000 + ", " + 1000 / 1.4696016);

  logo = loadShape("Coca-Cola_logo.svg");
  logo.disableStyle();
  //logo.scale(0.8);
}

void draw() {
  color white = #FDFDFD;
  color red = #C70015;

  //ShapeBasedPlacer sbp = sbp(img, white);

  background(red);
  fill(white);
  noStroke();
  shapeMode(CENTER);
  shape(logo, 512, 261); //mouseX, mouseY);
  
//  textFont(createFont("Source Sans Pro", 70));
//  text("classic", 400, 450);
  textFont(createFont("Sinkin Sans 400 Regular", 50));
  text("classic", 400, 450);

  new WordCram(this).
    fromWords(repeat(150, "cocaine", "sugar")). //, "horse piss")).
    withFonts("Sinkin Sans 600 SemiBold"). //Liberation Sans Bold Italic", "ChunkFive Roman"). //"Bebas").

    //withPlacer(makePlacer()).
    //withPlacer(sbp).withNudger(sbp).
    withPlacer(new WaveWordPlacer()).

    //sizedByWeight(5, 50).
    withSizer(randomSizer(8, 16, 4)).

    minShapeSize(5).
    angledAt(0).
    //withColorer(pixelColorer(img)).
    withColors(white).
    drawAll();

//  println("done!");
//  noLoop();
  endRecord();
  exit();
}

void wordDrawn(Word w) {
  //println(w.word);
}

void mouseClicked() {
  println(mouseX + ", " + mouseY);
  println(hex(get(mouseX, mouseY)));
}

ShapeBasedPlacer sbp(PImage image, color c) {
  Shape imageShape = new ImageShaper().shape(image, c);
  return new ShapeBasedPlacer(imageShape);
}


WordColorer pixelColorer(final PImage srcImage) {
  return new WordColorer() {
    public color colorFor(Word w) {
      PVector place = w.getRenderedPlace();
      float wordWidth = w.getRenderedWidth();
      float wordHeight = w.getRenderedHeight();

      float x = place.x + wordWidth * 0.5;
      float y = place.y + wordHeight * 0.5;
      return srcImage.get(round(x), round(y));
    }
  };
}

Word[] repeat(int n, String... wordStrings) {
  Word[] words = new Word[n];

  for (int i = 0; i < words.length; i++) {
    float weight = pow(random(1), 10);
    Word w = new Word(wordStrings[i % wordStrings.length], weight);
    words[i] = w;
  }

  return words;
}

WordPlacer makePlacer() {
  return new WordPlacer() {
    public PVector place(Word word, 
    int wordIndex, 
    int wordsCount, 
    int wordImageWidth, 
    int wordImageHeight, 
    int fieldWidth, 
    int fieldHeight) {
      return new PVector(random(fieldWidth - wordImageWidth), 
      random(fieldHeight - wordImageHeight));
    }
  };
}

WordSizer randomSizer(float min, float max) {
  return randomSizer(min, max, 1);
}
WordSizer randomSizer(final float min, final float max, final float pow) {
  return new WordSizer() {
    public float sizeFor(Word word, int wordRank, int wordCount) {
      float f = pow(random(1), pow);
      return lerp(min, max, f);
    }
  };
}


class WaveWordPlacer implements WordPlacer {

    public PVector place(Word word, int wordIndex, int wordsCount,
            int wordImageWidth, int wordImageHeight, int fieldWidth,
            int fieldHeight) {

        float normalizedIndex = (float) wordIndex / wordsCount;
        float x = lerp(-100, fieldWidth, normalizedIndex);
        float y = lerp(fieldHeight*0.6, fieldHeight*0.85, normalizedIndex);
        
        float yOffset = getYOffset(wordIndex, wordsCount, fieldHeight);
        return new PVector(x, y + yOffset);
    }

    private float getYOffset(int wordIndex, int wordsCount, int fieldHeight) {
        float theta = PApplet.map(wordIndex, 0, wordsCount, PConstants.PI, -0.7*PConstants.PI);

        return (float) Math.sin(theta) * (fieldHeight / 10f);
    }
}


