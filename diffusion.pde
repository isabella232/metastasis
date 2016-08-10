/* 
Keyboard controls:
m     :  switch between monochrome and colour drawing
space :  pause growth
n     :  new drawing, but keep old background
r     :  new drawing but erase background
s     :  save in project folder
*/


PGraphics bg;
PGraphics newLayer;
int mx;
int my;
boolean test = false;
boolean pause = false;
boolean monochrome = false;

void setup() {
  size(800, 800);
  bg = createGraphics(width, height);
  newLayer = createGraphics(width, height);
  background(128);
  bg.beginDraw();
  //bg.background(255);
  bg.stroke(0);
  bg.strokeWeight(3);
  bg.strokeCap(ROUND);
  bg.endDraw();
  newLayer.beginDraw();
  newLayer.stroke(0);
  newLayer.strokeWeight(6);
  newLayer.strokeCap(ROUND);
  newLayer.endDraw();
}

void draw() {
  if (mousePressed) {
    bg.beginDraw();
    if (monochrome) {
      bg.stroke(random(255));
    } else {
      bg.stroke(random(255), random(255), random(255));
    }
    bg.line(mouseX, mouseY, mx, my);
    bg.endDraw();
    image(bg, 0, 0);
    mx = mouseX;
    my = mouseY;
  } else if (pause == false) {
    bg.loadPixels();
    newLayer.beginDraw();
    for (int x = 1; x < width-1; x++) {
      for (int y = 1; y < height-1; y++) {
        test = false;
        if (alpha(bg.pixels[x+y*width]) > 0) {
          for (int i = -1; i < 2; i++) {
            for (int j = -1; j < 2; j++) {
              if (alpha(bg.pixels[x+i+(y+j)*width]) == 0) {
                test = true;
              }
            }
          }
        }
        if (test) {
          // newLayer.stroke(255-brightness(bg.pixels[x+y*width]));
          newLayer.stroke(255-red(bg.pixels[x+y*width]), 255-green(bg.pixels[x+y*width]), 255-blue(bg.pixels[x+y*width]));
          newLayer.point(x, y);
        }
      }
    }
    newLayer.endDraw();
    newLayer.loadPixels();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (alpha(bg.pixels[x+y*width]) == 0) {
          bg.pixels[x+y*width] = newLayer.pixels[x+y*width];
        }
      }
    }
    bg.updatePixels();
    image(bg, 0, 0);
  }
}

void mousePressed() {
  mx = mouseX;
  my = mouseY;
}

void keyPressed() {
  if (key == ' ') {
    pause = !pause;
  } else if (key == 'm') {
    monochrome = !monochrome;
  } else if (key == 'r') {
    bg.clear();
    newLayer.clear();
    background(128);
  } else if (key == 'n') {
    bg.clear();
    newLayer.clear();
  } else if (key == 's') {
    save(nf(random(10000))+".png");
  }
}