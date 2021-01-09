

import processing.net.*;
import controlP5.*;


Client client; 
String input;
float buffer[];

int width = 1080;
int factor_1 = 4;
int factor_2 = 13;
int shiftGraph_1 = 450;
int shiftGraph_2 = 160;

ControlP5 cp5;
String[] textfieldNames = {"K_p", "K_i", "K_d", "Target"};

float[] data0 = new float[width]; 
float[] data1 = new float[width]; 
float[] data2 = new float[width];
float[] data3 = new float[width];
float[] data4 = new float[width];
float[] data5 = new float[width];
float[] data6 = new float[width];
float[] data7 = new float[width];
float[] data8 = new float[width];
float newDataPoint0 = 0;   
float newDataPoint1 = 0;                                             
float newDataPoint2 = 0;
float newDataPoint3 = 0;
float newDataPoint4 = 0;
float newDataPoint5 = 0;
float newDataPoint6 = 0;
float newDataPoint7 = 0;
float newDataPoint8 = 0;


void setup() { 
  size(1080,720);
  frameRate(60);
  client = new Client(this, "192.168.4.1", 8888);
  
  
  cp5 = new ControlP5(this);
  PFont font = createFont("arial",14);

  int y = 350;
  int x = 20;
  int spacing = 80;
  for(String name: textfieldNames){
    cp5.addTextfield(name)
       .setPosition(x,y)
       .setSize(70,20)
       .setFont(font)
       .setFocus(true)
       .setColor(color(255,255,255))
       ;
     x += spacing;
  }
} 

void draw() { 
  background(115);
  
  if (client.available() > 0) {
    input = client.readString();
    println(input);
    input = input.substring(0,input.indexOf("\n"));
    buffer = float(split(input, ' '));
    
    // Put texts
    String newDataPointString0 = "Input PWM: " + str(buffer[0]);
    String newDataPointString1 = "Sensor Value: " + str(buffer[1]);
    String newDataPointString2 = "Target Value: " + str(buffer[2]);
    String newDataPointString3 = "K_p: " + str(buffer[3]);
    String newDataPointString4 = "K_i: " + str(buffer[4]);
    String newDataPointString5 = "K_d: " + str(buffer[5]);
    String newDataPointString6 = "P-Component: " + str(buffer[6]);
    String newDataPointString7 = "I-Component: " + str(buffer[7]);
    String newDataPointString8 = "D-Component: " + str(buffer[8]);
    
    textSize(14);
    fill(254, 87, 0);
    text(newDataPointString0, 10, 30);
    fill(87, 255, 0);
    text(newDataPointString1, 10, 50);
    fill(204, 153, 0);
    text(newDataPointString2, 10, 70);
    fill(255);
    text(newDataPointString3, 370, 350);
    fill(255);
    text(newDataPointString4, 370, 370);
    fill(255);
    text(newDataPointString5, 370, 390);
    fill(254, 0, 255);
    text(newDataPointString6, 10, 500);
    fill(254, 255, 0);
    text(newDataPointString7, 10, 520);
    fill(0, 87, 255);
    text(newDataPointString8, 10, 540);
    
    newDataPoint0 = buffer[0] / factor_1 + shiftGraph_1;   
    newDataPoint1 = buffer[1] / factor_1 + shiftGraph_1;                                             
    newDataPoint2 = buffer[2] / factor_1 + shiftGraph_1;
    //newDataPoint3 = buffer[3] / factor;
    //newDataPoint4 = buffer[4] / factor;
    //newDataPoint5 = buffer[5] / factor;
    newDataPoint6 = buffer[6] / factor_2 + shiftGraph_2;
    newDataPoint7 = buffer[7] / factor_2 + shiftGraph_2;
    newDataPoint8 = buffer[8] / factor_2 + shiftGraph_2;
    
    for(int i = 0; i < width-1; i++)                                 //each interation of draw, shift data points one pixel to the left to simulate a continuously moving graph
    {
      data0[i] = data0[i+1];
      data1[i] = data1[i+1];
      data2[i] = data2[i+1];
      //data3[i] = data3[i+1];
      //data4[i] = data4[i+1];
      //data5[i] = data5[i+1];
      data6[i] = data6[i+1];
      data7[i] = data7[i+1];
      data8[i] = data8[i+1];
    }
    
    data0[width-1] = newDataPoint0;                                 //introduce the bufffered data into the rightmost data slot
    data1[width-1] = newDataPoint1;
    data2[width-1] = newDataPoint2;
    //data3[width-1] = newDataPoint3;
    //data4[width-1] = newDataPoint4;
    //data5[width-1] = newDataPoint5;
    data6[width-1] = newDataPoint6;
    data7[width-1] = newDataPoint7;
    data8[width-1] = newDataPoint8;
    
    strokeWeight(1);
    
    pushMatrix();
    translate(0, 720);
    scale(1,-1);
    for(int i = width-1; i > 0; i--)                                
    {
      stroke(254, 87, 0);
      line(i,data0[i-1], i+1, data0[i]);        // force
      stroke(87, 255, 0);
      line(i,data1[i-1], i+1, data1[i]);        // halsensorval
      stroke(204, 153, 0);
      line(i,data2[i-1], i+1, data2[i]);        // targetval
      //stroke(0,0,255);
      //line(i,data3[i-1], i+1, data3[i]);
      //stroke(0,0,255);
      //line(i,data4[i-1], i+1, data4[i]); 
      //stroke(0,0,255);
      //line(i,data5[i-1], i+1, data5[i]); 
      stroke(254, 0, 255);
      line(i,data6[i-1], i+1, data6[i]);        // P
      stroke(254, 255, 0);
      line(i,data7[i-1], i+1, data7[i]);        // I
      stroke(0, 87, 255);
      line(i,data8[i-1], i+1, data8[i]);        // D
    }
    popMatrix();
  } 
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '" +theEvent.getName()+"': " +theEvent.getStringValue() );
    client.write(theEvent.getName() + " " + theEvent.getStringValue());
    
  }
}
