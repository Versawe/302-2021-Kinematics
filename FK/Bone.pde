class Bone{
  //properties
  
  //relative direction to bone points, radians
  //if 0, then bone points same way as parent
  float dir = random(-1,1);
  
  //length of the bone, in pixels
  float mag = random(50,150);
  
  //references to paretn/child bones:
  //implementing linked list
  Bone parent;
  ArrayList<Bone> children = new ArrayList<Bone>();
  
  boolean isRevolute = true; //can spin?
  boolean isPrismatic = true; // can change length?
  
  //cached / derived values:
  PVector worldStart; //start of bone in world-space
  PVector worldEnd; //end of bone in world-space
  float worldDir = 0; //world-space angle of the bone
  int boneDepth = 0; // how balls deep in the armature (tree) this bone is
  
  float wiggleOffset = random(0,6.28);
  float wiggleAmp = random(.5f, 2);
  float wiggleTimeScale = random(.25, 1);
  
  Bone(Bone parent){
    this.parent = parent;
    
    int num = 0;
    Bone p = parent;
    while(p != null){
      num++;
      p = p.parent;
    }
    boneDepth = num;
  }
  
  Bone(int chainLength){
    if(chainLength > 1){
      AddBone(chainLength - 1); 
    }
  }
  
  void AddBone(int chainLength){
    
    if(chainLength < 1) chainLength = 1;
    
    int numOfChildren = (int)random(1,4);
    for(int i = 0; i < numOfChildren; i++){
        Bone newBone = new Bone(this);
        children.add(newBone);
        //newBone.parent = this;
        
        if(chainLength > 1){
         newBone.AddBone(chainLength - 1); 
        }
      }  
  }
  
  void calc(){
     //calc bone start

    if(parent != null){
      worldStart = parent.worldEnd;
      worldDir = parent.worldDir + dir;
      
    }else{ //if no parent use default values
    
       worldStart = new PVector(100,100);
       worldDir = dir; 
    }
    
    //worldDir += sin(time) * (boneDepth+1) / 5.0;
    worldDir += sin((time + wiggleOffset) * wiggleTimeScale) * wiggleAmp;
     
    //calc bone end
    PVector localEnd = PVector.fromAngle(worldDir); //new PVector(mag * cos(worldDir), mag * sin(worldDir));
    localEnd.mult(mag);
    
    worldEnd = PVector.add(worldStart, localEnd);
    
    for(Bone child : children) child.calc();
    
  }
  
  void draw(){
    //draw line from bone start to bone end
    line(worldStart.x, worldStart.y, worldEnd.x, worldEnd.y);
    
    fill(100,100,200);
    ellipse(worldStart.x, worldStart.y, 20,20);
    
    for(Bone child : children) child.draw();
    fill(150,150,255);
    ellipse(worldEnd.x, worldEnd.y, 10,10);
    
  }
  
  Bone onClick(){
    PVector mouse = new PVector(mouseX, mouseY);
    
    PVector vToMouse = PVector.sub(mouse, worldEnd); // mouse - worldEnd
    if(vToMouse.magSq() < 20 * 20) return this; // if dis to mouse < 20px return this bone
    
    //checks all child bones
    for(Bone child : children){
     Bone b = child.onClick();
      if(b != null) return b;
    }
    return null;
  }
  
  void drag(){
      PVector mouse = new PVector(mouseX, mouseY);
      PVector vToMouse = PVector.sub(mouse, worldStart);
      if(isRevolute){
        if(parent != null){
          dir = vToMouse.heading() - parent.worldDir; //parent.worldDir - atan2(vToMouse.y, vToMouse.x);
        }else{
           dir = vToMouse.heading(); // root bone can point right at mouse 
        }
      }
      if(isPrismatic) mag = vToMouse.mag();
  }
  
}
