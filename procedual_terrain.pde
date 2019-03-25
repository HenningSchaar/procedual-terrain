int cols, rows;
int scl = 80;
int mHeight = 300;
int w = 10000;
int h = 10000;
float terrain[][];
float fly = 0;
float noisespacing = 0.1;
float flymultiplier = 0.1;

void setup() {
  size(2800, 1800, P3D);
  cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];
  frameRate(60);
}

void draw() {
  background(0);
  fill(255, 50);
  stroke(255);
  translate(width/2, height/2);
  rotateX(PI / 3);
  translate(-w/2, -h/2-150);

  float yoffset = fly;
  for (int y = 0; y < rows; y++) {
    float xoffset = 0;
    for (int x= 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoffset, yoffset), 0, 1, -mHeight, mHeight);
      xoffset += noisespacing;
    }
    yoffset += noisespacing;
  }
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x= 0; x < cols; x++) {
      fill(map(terrain[x][y], -mHeight, mHeight, 0, 255), map(y, 0, rows, 0, 255), map(x, 0, cols, 0, 255));
      vertex(x * scl, y * scl, terrain[x][y]);
      vertex(x * scl, (y+1) * scl, terrain[x][y+1]);
    }
    endShape();
  }
  fly -= noisespacing * flymultiplier;
}
