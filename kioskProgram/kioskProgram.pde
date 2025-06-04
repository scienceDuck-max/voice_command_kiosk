/**
  * This sketch demonstrates how to an <code>AudioRecorder</code> to record audio to disk. 
  * To use this sketch you need to have something plugged into the line-in on your computer, 
  * or else be working on a laptop with an active built-in microphone. 
  * <p>
  * Press 'r' to toggle recording on and off and the press 's' to save to disk. 
  * The recorded file will be placed in the sketch folder of the sketch.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

// import UDP library
import hypermedia.net.*;
import ddf.minim.*;
PImage start_scene_image;
PImage menu_scene_image;
PImage confirm_scene_image;
PImage check_scene_image;
PImage end_scene_image;
PImage start_btn_image;
PImage check_btn_image;
PImage confirm_btn_image;
PImage end_btn_image;

//START , MENU, CONFIRM, CHECK, END
String current_scene = "START";

Minim minim;
AudioInput in;
AudioRecorder recorder;
UDP udp;  // define the UDP object
boolean bRecordDone = false;
PFont mono;

void setup()
{
  size(1080,1920, P3D);
  
  mono = createFont("AdelleSansDevanagari-Extrabold-100.vlw",100);
  textFont(mono);
  
  minim = new Minim(this);

  in = minim.getLineIn(Minim.MONO, 512);
  // create a recorder that will record from the input to the filename specified
  // the file will be located in the sketch's root folder.
  recorder = minim.createRecorder(in, "../voiceOrderProject/test.wav");
  
  textFont(createFont("Arial", 12));
  
  udp = new UDP( this, 6000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
  
  //load all kiosk image
  loadKioskImage();
}

void draw()
{
  if(current_scene == "START")
  {
      draw_start_scene();
  }
  else if(current_scene == "MENU")
  {
      draw_menu_scene();
  }
  else if(current_scene == "CONFIRM")
  {
      draw_confirm_scene();
  }
  else if(current_scene == "CHECK")
  {
      draw_check_scene();
  }
  else if(current_scene == "END")
  {
      draw_end_scene();
  }
  
}


void loadKioskImage()
{ 
  start_scene_image = loadImage("start_scene.jpg");
  menu_scene_image = loadImage("menu_scene.jpg");
  confirm_scene_image = loadImage("confirm_scene.jpg");
  check_scene_image = loadImage("check_scene.jpg");
  end_scene_image = loadImage("end_scene.jpg");
    
  start_btn_image = loadImage("start_btn.jpg");
  check_btn_image = loadImage("check_btn.jpg");
  confirm_btn_image = loadImage("confirm_btn.jpg");
  end_btn_image = loadImage("end_btn.jpg");
}

void sendSpeechToTextCommand() {
    
    String message  = "START";  // the message to send
    String ip       = "127.0.0.1";  // the remote IP address
    int port        = 12345;    // the destination port
    
    // send the message
    udp.send( message, ip, port );
}

void keyReleased()
{
  if ( key == 'r' && current_scene == "MENU") 
  {
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
      
      recorder.save();
      println("Done saving.");
      
      bRecordDone = true;
    }
    else 
    {
      bRecordDone = false;
      recorder = minim.createRecorder(in, "../voiceOrderProject/test.wav");
      recorder.beginRecord();
    }
  }
  
  if(key==' ')
  {
    if(current_scene == "START")
    {
        current_scene = "MENU";
    }
    else if(current_scene == "MENU")
    {
        current_scene = "CONFIRM";
    }
    else if(current_scene == "CONFIRM")
    {
        current_scene = "CHECK";
    }
    else if(current_scene == "CHECK")
    {
        current_scene = "END";
    }
    else if(current_scene == "END")
    {
      current_scene = "START";
    }
  } 
}


void mouseReleased() {
  
  if (current_scene == "MENU") 
  {
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
      
      recorder.save();
      println("Done saving.");
      
      bRecordDone = true;
    }
    else 
    {
      bRecordDone = false;
      recorder = minim.createRecorder(in, "../voiceOrderProject/test.wav");
      recorder.beginRecord();
    }
  }
  
  if(current_scene == "START")
  {
      current_scene = "MENU";
  }
  else if(current_scene == "CONFIRM")
  {
      current_scene = "CHECK";
  }
  else if(current_scene == "CHECK")
  {
      current_scene = "END";
  }
  else if(current_scene == "END")
  {
    current_scene = "START";
  }
} 

void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  
  
  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  
  // print the result
  println( "receive: "+message+" from "+ip+" on port "+port );
  
  println("[QUESTION] "+message);
  //message = "다음 주문을 json format으로 변환해서 출력해줘, json format은{\"order\": [ {\"name\": \"item_name_1\",\"quantity\": 1 }, {\"name\": \"item_name_2\",\"quantity\": 2 } ] }"+message;
  message = "다음 주문을 json 1layer의  format으로 변환해서 출력해줘, "+message;
  
  sendRequest(message);
}
