class Incr {
  float value;
  float step;
  Incr(float start, float step) {
    value = start;
    this.step = step;
  }
  float next() {
    value += step;
    return current();
  }
  float current() {
    return value;
  }
}
