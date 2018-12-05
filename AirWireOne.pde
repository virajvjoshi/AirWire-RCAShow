
// Hey future Viraj. Here's your code.
// Calling libraries:
import processing.video.*;
import jp.nyatla.nyar4psg.*;
import processing.serial.*;

//Creating Image Variables
PImage img1;
PImage img2;
PImage img3;
PImage img4;
PImage textbox;

//Serial Sender
Serial myPort;

//Text above markers
PFont myFont;
String txt1 = "Button";
String txt2 = "LED";
String txt3 = "Ultrasonic Sensor";
String txt4 = "Servo";

//Cursor Code
float[] x = new float[20]; 
float[] y = new float[20]; 

//Buttons Code

int circleSize = 93;   // Diameter of circle
int circleX, circleY;  // Position of circle button
boolean circleOver = false;

int rect1X, rect1Y;      // Position of square1 button
int rect1Size = 400;     // Diameter of rect
boolean rect1Over = false;

int rect2X, rect2Y;      // Position of square2 button
int rect2Size = 400;     // Diameter of rect
boolean rect2Over = false;

int rect3X, rect3Y;      // Position of square3 button
int rect3Size = 400;     // Diameter of rect
boolean rect3Over = false;

int rect4X, rect4Y;      // Position of square4 button
int rect4Size = 400;     // Diameter of rect
boolean rect4Over = false;

//AR Code
Capture cam;
MultiMarker nya;

void setup() {
  textSize(32);
  size(1375,1000,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  cam=new Capture(this, "name=USB Camera #5, size=1375x1000");
  nya=new MultiMarker(this,width,height,"../../data/camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker(loadImage("../../data/show01.png"),16,25,80);
  nya.addARMarker(loadImage("../../data/show02.png"),16,25,80);
  nya.addARMarker(loadImage("../../data/show03.png"),16,25,80);
  nya.addARMarker(loadImage("../../data/show04.png"),16,25,80);
cam.start();
  

//ButtonsCode
  circleX = width/2+circleSize/2+10;
  circleY = height/2;
  
  rect1X = 200;
  rect1Y = 50;
  
  rect2X = 250;
  rect2Y = 675;
   
  rect3X = 850;
  rect3Y = 25;
  
  rect4X = 850;
  rect4Y = 675;
  ellipseMode(CENTER);
  
//More Cursor Code
  smooth(); 
  noStroke();
  for(int i = 0; i<x.length; i++) {
    x[i] = 0;
    y[i] = 0; 
  }
    
  //Arduino Push
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
 
 //AirWireGraphics
  img1 = loadImage("AW1.png");
  img2 = loadImage("AW2.png");
  img3 = loadImage("AW3.png");
  img4 = loadImage("AW4.png");
  textbox = loadImage("textbox.png");
}

void draw()
{
  //Setting the stage
  cam.read();
  //nya.detect(cam);
  background(0);
  nya.drawBackground(cam);
  
    //Main bits of code for AR Markers
    if((nya.isExist(0))){
      nya.beginTransform(0);
      noFill();
      strokeWeight(3);
      stroke(100,0,0);
      rect(-40,-40,80,80);
      stroke(100,100,0);
      text (txt1,-40,90);
      nya.endTransform();
    }
    
    if((nya.isExist(1))){
      nya.beginTransform(1);
      noFill();
      strokeWeight(3);
      stroke(0,0,100);
      rect(-40,-40,80,80);
      stroke(100,100,0);
      text (txt2,-40,90);
      nya.endTransform();
    }
    
    if((nya.isExist(2))){
      nya.beginTransform(2);
      noFill();
      strokeWeight(3);
      stroke(100,0,0);
      rect(-40,-40,80,80);
      stroke(100,100,0);
      text (txt3,-40,90);
      nya.endTransform();
    }
    
    if((nya.isExist(3))){
      nya.beginTransform(3);
      noFill();
      strokeWeight(3);
      stroke(0,0,100);
      rect(-40,-40,80,80);
      stroke(100,100,0);
      text (txt4,-40,90);
      nya.endTransform();
    }
    
   
  
  //Even More Cursor Code
  for(int i = 0; i<x.length-1; i++) {
    
    x[i] = x[i+1];
    y[i] = y[i+1]; 
    
    fill(100);
    ellipse(x[i], y[i], i, i); 
    
  }
  x[x.length-3] = mouseX; 
  y[y.length-3] = mouseY;
  
  //button code
  update(mouseX, mouseY);
  
  if (rect1Over) {
    fill(255,255,255,2);
    myPort.write('1'); //seria l sender!
    println("1"); //display that serial is being sent
    stroke(255);
    rect(rect1X, rect1Y, rect1Size, rect1Size);
    image(img1, 200, 50);
    image(textbox, 100, 900);
  }
  else if (rect2Over) {
    fill(255,255,255,2);
    myPort.write('4'); //serial sender!
    println("4"); //display that serial is being sent
    stroke(255);
    rect(rect2X, rect2Y, rect2Size, rect2Size);
    image(img2, 250, 675);
    image(textbox, 100, 900);
  }
  else if (rect3Over) {
    fill(255,255,255,2);
    myPort.write('2'); //serial sender!
    println("2"); //display that serial is being sent
    stroke(255);
    rect(rect3X, rect3Y, rect3Size, rect3Size);
    image(img3, 850, 25);
    image(textbox, 100, 900);
  }
  else if (rect4Over) {
    fill(255,255,255,2);
    myPort.write('3'); //serial sender!
    println("3"); //display that serial is being sent
    stroke(255);
    rect(rect4X, rect4Y, rect4Size, rect4Size);
    image(img4, 850, 675);
    image(textbox, 100, 900);
  }
  else {
    myPort.write('0'); //serial sender!
    noFill();
  }
}

void update(int x, int y) {
  if (overRect1(rect1X, rect1Y, rect1Size, rect1Size) ) {
    rect1Over = true;
  }
  else if (overRect2(rect2X, rect2Y, rect2Size, rect2Size) ) {
    rect2Over = true;
  }
  else if (overRect3(rect3X, rect3Y, rect3Size, rect3Size) ) {
    rect3Over = true;
  }
  else if (overRect4(rect4X, rect4Y, rect4Size, rect4Size) ) {
    rect4Over = true;
  }
  else {
    circleOver = rect1Over = rect2Over = rect3Over = rect4Over = false;
  }
}


boolean overRect1(int x1, int y1, int width, int height)  {
  if (mouseX >= x1 && mouseX <= x1+width && 
      mouseY >= y1 && mouseY <= y1+height) {
    return true;
  }
  else {
    return false;
  }
}

boolean overRect2(int x2, int y2, int w2, int h2)  {
  if (mouseX >= x2 && mouseX <= x2+w2 && 
      mouseY >= y2 && mouseY <= y2+h2) {
    return true;
  }
  else {
    return false;
  }
}

boolean overRect3(int x3, int y3, int w3, int h3)  {
  if (mouseX >= x3 && mouseX <= x3+w3 && 
      mouseY >= y3 && mouseY <= y3+h3) {
    return true;
  }
  else {
    return false;
  }
}

boolean overRect4(int x4, int y4, int w4, int h4)  {
  if (mouseX >= x4 && mouseX <= x4+w4 && 
      mouseY >= y4 && mouseY <= y4+h4) {
    return true;
  }
  else {
    return false;
  }
}
