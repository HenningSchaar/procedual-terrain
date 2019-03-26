import processing.sound.*;

FFT fft;
AudioIn input;

int bands = 256;
float[] spectrum = new float[bands];
int cols, rows;
int scl = 80;
int mHeight = 800;
int w = 10160;
int h = 11000;
float terrain[][];
float oldterrain[][];
float fly = 0;
float noisespacing = 0.1;
float flymultiplier = 0.1;

void setup() {
  size(1920, 1234, P3D);
  cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];
  oldterrain = new float[cols][rows];
  input = new AudioIn(this, 0);
  input.start();
  fft = new FFT(this, bands);
  fft.input(input);
  frameRate(60);
}

void draw() {
  //background(0);
  fill(255, 50);
  stroke(255);
  translate(width/2, height/2);
  rotateX(PI / 3);
  translate(-w/2, -h/2-4770);
  fft.analyze(spectrum);

  for (int y = 0; y < rows-1; y++) {
    for (int x= 0; x < cols; x++) {
      terrain[x][y] = oldterrain[x][y+1];
      terrain[x][rows-1] = map((spectrum[x] * (x * 0.01)), -0.05, 0.05, -mHeight, mHeight);
    }
  }
  oldterrain = terrain;

  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x= 0; x < cols; x++) {
      fill(map(terrain[x][y], -mHeight, mHeight, 0, 255), map(y, 0, rows, 0, 255), map(x, 0, cols, 0, 255), 240);
      vertex(x * scl, y * scl, terrain[x][y]);
      vertex(x * scl, (y+1) * scl, terrain[x][y+1]);
    }
    endShape();
  }
  fly -= noisespacing * flymultiplier;
}
