// 0x80 beginning 
// 0x83 - 28 bytes of data / refresh / 2C
// address or 0xFF for all
// data ... 1 to nuber of data bytes
// 0x8F end

// panel's speed setting: 1-OFF 2-ON 3 - ON
// panel address : 1 (8 pos dip switch: 1:on 2 -8: off)



byte send_buffer[]= {0x80, 0x83, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8F};


// dark / bright transmissions for configurations above



byte all_bright[]= {0x80, 0x83, 0xFF, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x8F};
byte all_dark[]= {0x80, 0x83, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8F};

                  
                  
void setup() {

  Serial.begin(57600);  



}



void loop()

{
int n,m;

/*for (m=0;m<10;m++)  
    for (n=0;n<28;n++)

          {  
             send_buffer[n+3]=127;
             Serial.write(send_buffer,32); // eot
             send_buffer[n+3]=0x00;
             delay(m*10);
             
          }
          
  */
  
for (m=0;m<300;m++)  {    
                    Serial.write(all_bright, 32); 
                    delay(m*100);
                    Serial.write(all_dark, 32); 
                    delay(m*100);
                };
   



   
     
} 

