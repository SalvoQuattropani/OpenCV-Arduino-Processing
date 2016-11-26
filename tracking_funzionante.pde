import processing.serial.*;

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

int servoTiltPosition = 90;
// contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;
int servoPanPosition = 90;

char tiltChannel = 0;
char panChannel = 1;
int midFaceY=0;
int midFaceX=0;
int stepSize=1;

int midScreenY = (height/2);
int midScreenX = (width/2);
int midScreenWindow = 10;  
Capture video;
OpenCV opencv;
Serial port;
void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480,"USB2.0 PC CAMERA",30);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  
  println(Serial.list()); 


  port = new Serial(this, Serial.list()[0], 57600);   

 
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );
  
  
  port.write(servoTiltPosition);  
 
  

  
}

void draw() {
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
  //  port.write(faces[i].x);
  }
  
  //Find out if any faces were detected.
  if(faces.length > 0){
    
    midFaceY = faces[0].y + (faces[0].height/2);
    midFaceX = faces[0].x + (faces[0].width/2);
  
    
    if(midFaceX < 150){
      if(servoTiltPosition >= 5)servoTiltPosition += stepSize; 
    }
  
    else if(midFaceX >150){
      println( "midscreenX: " +  midScreenWindow);
      if(servoTiltPosition <= 175)servoTiltPosition -=stepSize; 
    }

    if(midFaceY < (midScreenY - midScreenWindow)){
      if(servoPanPosition >= 5)servoPanPosition += stepSize; 
    }

    else if(midFaceY > (midScreenY + midScreenWindow)){
      if(servoPanPosition <= 175) servoPanPosition -=stepSize; 
    }
    
  }
  
  port.write(servoTiltPosition); 
  delay(1);
    
}

void captureEvent(Capture c) {
  c.read();
}


void mouseDragged() {
  contrast_value   = (int) map( mouseX, 0, width, -128, 128 );
  brightness_value = (int) map( mouseY, 0, width, -128, 128 );
}