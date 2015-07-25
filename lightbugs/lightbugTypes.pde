// only 3 'public' methods: makeLightbugs(n), moveLightbugs(PImage map), drawLightbugs()

void makeLightbugs(int n) {
  lightbugs = new Lightbug[n];
  for (int i = 0; i < n; i++) {
    lightbugs[i] = new Lightbug();
  }
}

void moveLightbugs(PImage map) {
  for (Lightbug bug : lightbugs) {
    bug.move(map);
  }
}

void drawLightbugs() {
  colorShifter.next();
  fill(#FFF7AA);
  for (Lightbug bug : lightbugs) {
    bug.draw();
  }
}

// 'private' bits
Lightbug[] lightbugs;
Incr colorShifter = new Incr(30, -0.025);

PVector scale(PVector v, float scale) {
  v.normalize();
  v.mult(scale);
  return v;
}

PVector randomDirection() {
  return new PVector(random(-1, 1), random(-1, 1));
}

PVector randomLocation() {
  return new PVector(random(width), random(height));
}

class Lightbug {
  protected PVector loc;
  private PVector vel;
  private PVector acc; // TODO find out that trick to removing acc...Shiffman? Box2D?

  private float accDamp = 0.025;
  private float maxVel = 3;
  private float size = map(pow(random(1), 3), 0, 1, 5, 15);

  protected PVector target = new PVector(0, 0);

  Lightbug() {
    loc = randomLocation();
    target.set(loc.x, loc.y, 0);  // we'll change targets soon enough
    vel = scale(randomDirection(), maxVel);
    acc = randomDirection();
    acc.mult(accDamp);
  }

  void draw() {
    //float hue = (colorShifter.current() + 255) % 255;
    //fill(hue, 149, 240, 170);
    ellipse(loc.x, loc.y, size, size);
  }

  void move(PImage map) {
    pickNewTarget(map);

    acc = PVector.sub(target, loc);
    acc.mult(accDamp);
    vel.add(acc);
    vel.limit(maxVel);
    loc.add(vel);
  }

  private void pickNewTarget(PImage map) {
    if (shouldPickNewTarget()) {
      target = findNewTarget(map);
    }
  }

  private boolean shouldPickNewTarget() {
    return dist(loc.x, loc.y, target.x, target.y) < 25;  // magic #
  }

  protected PVector findNewTarget(PImage map) {
    PVector newTarget;
    float bright = 0.0;

    int lim = 10;
    do {
      newTarget = PVector.add(target, scale(randomDirection(), 30)); // magic #

      color c = map.get((int)newTarget.x, (int)newTarget.y);
      bright = norm(brightness(c), 0, 255);
    } 
    while (bright < 0.9 && --lim > 0);   // magic #

    return newTarget;
  }
}
