
void draw_menu_scene()
{
  //menu scene background
  image(menu_scene_image, 0,0,width,height);

  stroke(255,0,0);
  strokeWeight(5);
  
  
  if ( recorder.isRecording() )
  {
    fill(255,255,0);
    textFont(mono);
    text("LISTENING...", 175, 150);
    // draw the waveforms
    // the values returned by left.get() and right.get() will be between -1 and 1,
    // so we need to scale them up to see the waveform
    for(int i = 0; i < in.bufferSize() - 1; i++)
    {
      int scale = 1000;
      line(3*i, scale + in.left.get(i)*scale, 3*(i+1), scale + in.left.get(i+1)*scale);
      line(3*i, scale + 300 + in.right.get(i)*scale, 3*(i+1), scale +300 + in.right.get(i+1)*scale);
    }
  }
  else
  {
    fill(255,255,0);
    textFont(mono);
    text("TOUCH TO START", 105, 80);
    text("VOICE ORDER", 175, 170);
  }
  
  
  if(bRecordDone==true)
  {
      bRecordDone = false;
      println("sendSpeechToTextCommand");
      sendSpeechToTextCommand();
  }
  
  delay(50);
 
}
