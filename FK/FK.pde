Bone bone = new Bone(5);
Bone draggedBone = null;

float time = 0;

void setup(){
  size(600,600);
  
}

// ticks every 1/60th
void draw()
{
  background(128);
  
  time = millis()/1000.0;
  
  if(draggedBone != null) draggedBone.drag();
  
  bone.calc();
  bone.draw();
}

void mousePressed(){
   //bone = new Bone(5);
   
  Bone clickedBone = bone.onClick();
  
  if(Keys.SHIFT()){
    if(clickedBone != null){
     clickedBone.AddBone(1); 
    }
  }else{ // no keys held
   draggedBone = clickedBone;
  }
  
}
void mouseReleased(){
   draggedBone = null; //stop dragging
}
