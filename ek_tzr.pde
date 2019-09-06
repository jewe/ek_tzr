import processing.serial.*;
 
Serial port;   
JSONArray framecells, rows, cells1, cells2, cells3;
int sequence;
int frame;

int usbId = 1; // index in Serial.list


void setup() {
  size(480, 200);
  frameRate(3);
  
  // load json
  cells1 = loadJSONArray("sequence_1.json");
  cells2 = loadJSONArray("sequence_2.json");
  cells3 = loadJSONArray("sequence_3.json");
  
  // init vars
  sequence = 1;
  frame = 0;
  
  
  // debug: print json
  /*for (int x = 0; x < 28; x++) {
    println(x + " " + getPixel(x,1));
  }*/
  
  
  // usb port
  printArray(Serial.list());
  if (usbId > Serial.list().length-1) {
    println("ERROR: usb device #" + usbId + " not found.");
    exit();
  }
  port = new Serial(this, Serial.list()[usbId], 9600); // set device / port here
}


void draw() {
  simulate();
  send();
  delay(100);
  frame++;
  if (frame > 50) frame = 0;
}
 


int getPixel(int x, int y){
  switch(sequence) {
    case 1: 
      framecells = cells1.getJSONArray(frame);
      break;
    case 2: 
      framecells = cells2.getJSONArray(frame);
      break;
    case 3: 
      framecells = cells3.getJSONArray(frame);
      break;
  }
  rows = framecells.getJSONArray(x);
  //println(rows);
  return rows.getInt(y);
}


// sends current frame to panel
void send() {
  int data =0x00;
  int x,y;
  int u;

  int send_buffer[]={ 0x80, 0x84, 0xFF, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8F, 0x00, 0x00};
  for (x=0;x<28;x++) {  // counting columns of a panel
    data = 0x00; // set data byte to zero before calculating it for another column of 7 dots
    send_buffer[2] = 0; // address of a panel
    
    for (y=0;y<7;y++) {
      //int rnd = round( random(1) );
      data = (data + (( getPixel(x+14, y+7) &0x01)))<<1; // take pixel, take last bit, move bitwise by one bit and and add to data
    }
    
    send_buffer[x+3] = data>>1; // write data calculated for each column into string to send
  }
  
  // send to panel
  for (u=0; u<33; u++) port.write(send_buffer[u]); // send transmission for one panel

  // refresh 
  port.write(0x80); //header
  port.write(0x82); // refresh
  port.write(0x8F); // end
}
  

void simulate(){
  int x,y;
  background(0);
  
  fill(200);
  text("#"+frame, 30,30);
  text("seq "+sequence, 100,30);
  
  fill(255);
  for (x=0;x<28*2;x++) {  // counting columns of a panel
    for (y=0;y<7*3;y++) {
      if (getPixel(x, y) == 1) {
        ellipse(x*10,y*10, 8,8);
      }
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    sequence++;
    frame = 0;
    if (sequence > 3) {
      sequence = 1;
    }
    //println("sequence " + sequence);
  }
} 
 
 
 
 
 
