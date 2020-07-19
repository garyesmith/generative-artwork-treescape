
// TREESCAPE 
// A ProcessingJS/Canvas code-generated landscape by Gary Smith (https://www.genartive.com)
// For educational purposes only: please do not redistribute for profit unmodified.

int calcWidth=250; // theoretical canvas width to use for calculations
int calcHeight=250; // theoretical canvas height to use for calculations

// Define some global variables and arrays related to the rendering of leaves
// These variables are populated during rendering of the branches, but the actual rendering of the leaves
// is left to the end. This is because switching color has a time/processing cost that makes things very 
// sluggish if we try to render them at the same time as the branches themselves
int[] leavesX = {}; // x position of leaves
int[] leavesY = {}; // y position of leaves
int[] leavesC = {}; // color of leaves
float leafSize;
float leafSparseness;
int lastBranchRendered=0;

// Initialize the canvas and draw the artwork elements
void setup() {

  // clear the background
  background(0,0,0,0); 
  fill(0,0,0,0); 

  // there is no animating loop, just a static image
  noLoop(); 

  size(640,640);

  leavesX.length=0;
  leavesY.length=0;
  leavesC.length=0;

  leafSize = calcWidth*0.004*random(0.7,2.1);
  leafSparseness = random(30,50); // percentage change of branch having no leaves

  if (random(0,100)>95) {
    leafSparseness=0; // some trees have no leaves
  }

  smooth(); // smooth rendering

  textAlign(CENTER,CENTER); // position text to be centered on x,y coords

  strokeJoin(ROUND);

  colorMode(HSB, 360, 100, 100); // set colour mode to HSB (Hue/Saturation/Brightness)

  background(0,0,100); // white  

  int hue1 = random(1,360); // main colour
  int hue2 = colorSplitComplementLeft(hue1); // left split complement to main colour
  int hue3 = colorSplitComplementRight(hue1); // right split complement to main colour

  // draw sky
  drawTexture('*', calcWidth*0.02, calcHeight*0.030, calcWidth*0.963, calcHeight*0.82, hue1, random(3,12), random(40,60), random(85,95), random(75,84));

  // draw ground
  drawTexture('"',calcWidth*0.02,calcHeight*0.82,calcWidth*0.962,calcHeight*0.175, hue1, random(15,35), random(65,80), random(95,100), random(60,70));

  // draw mountains
  drawMountains(calcWidth*0.015,calcHeight*0.8,calcWidth*0.972,calcHeight*0.35, color(hue1,40,45,40),calcWidth*0.003);
  drawMountains(calcWidth*0.016,calcHeight*0.8,calcWidth*0.971,calcHeight*0.25, color(hue1,30,35,30),calcWidth*0.003);
  drawMountains(calcWidth*0.015,calcHeight*0.8,calcWidth*0.972,calcHeight*0.15, color(hue1,35,45,25),calcWidth*0.003);
  drawMountains(calcWidth*0.014,calcHeight*0.8,calcWidth*0.972,calcHeight*0.08, color(hue1,35,22,20),calcWidth*0.002);
  drawMountains(calcWidth*0.016,calcHeight*0.8,calcWidth*0.971,calcHeight*0.02, color(hue1,55,15,60),calcWidth*0.001);

  // draw grass
  drawGrass(calcWidth*0.015,calcHeight*0.81,calcWidth*0.945,calcHeight*0.078, color(0,0,10,200));
  drawGrass(calcWidth*0.017,calcHeight*0.83,calcWidth*0.945,calcHeight*0.095, color(hue1,35,45,200));
  drawGrass(calcWidth*0.014,calcHeight*0.82,calcWidth*0.945,calcHeight*0.115, color(0,0,15,255));
  drawGrass(calcWidth*0.032,calcHeight*0.82,calcWidth*0.945,calcHeight*0.080, color(0,0,10,180));
  drawGrass(calcWidth*0.015,calcHeight*0.81,calcWidth*0.945,calcHeight*0.105, color(hue1,260,15,240));
  drawGrass(calcWidth*0.015,calcHeight*0.81,calcWidth*0.945,calcHeight*0.075, color(0,0,100,255));    
  drawGrass(calcWidth*0.014,calcHeight*0.82,calcWidth*0.945,calcHeight*0.075, color(0,0,5,225)); 

  // draw the tree
  drawTree(calcWidth/2, calcHeight*0.83, calcWidth*0.043, color(0,100,0,255), color(hue1,30,15,255), color(0,0,20,255), color(hue1,45,55,350), color(hue2,20,80,200), color(hue3,65,85,230));
  
  // add signature
  PFont fontA = loadFont("Courier New");
  textFont(fontA, scalePixelsX(calcWidth*0.032)); 
  fill(0,0,0,300);
  text("GES",scalePixelsX(calcWidth*0.941), scalePixelsY(calcHeight*0.968));

}

// Draw a textured rectangle composed of overlapping characters
//  char - character(s) to draw
//  xLeft - left x position of rectangle
//  yTop - top y position of rectangle
//  w - width of rectangle
//  h - height of rectangle
//  hue - base hue for color
//  startSat - starting saturation range for color
//  endSat - ending saturation range for color
//  startBri - staring brightness range for color
//  endBri - ending brightness range for color
void drawTexture(string char, float x1, float y1, float w, float h, int hue, int startSat, int endSat, int startBri, int endBri) {
 
  int dw=calcWidth*0.006;
  int dh=calcHeight*0.008;

  float numRows=h/dh;
  float dSat = (endSat-startSat)/numRows;
  float dBri = (startBri-endBri)/numRows;

  textSize(scalePixelsX(calcWidth*0.0225));

  noStroke();
  for (int x=x1; x<x1+w; x+=dw){
    float sat=startSat;
    float bri=startBri;
    for (int y=y1; y<y1+h; y+=dh) {      
      fill(color(hue,sat,bri));
      sat+=dSat;
      bri-=dBri;
      for (int i=0; i<6; i++) {
        text(char,scalePixelsX(x+calcWidth*random(-0.006,0.006)),scalePixelsY(y+calcWidth*random(-0.006,0.006)));
      }
    }
 }
}

// Draw a line of mountains
//  - xLeft - left x position of mountain line
//  - yBot - bottom y position of mountain line
//  - w - width of mountain line
//  - maxcalcHeight - maximum high mountain line can reach
//  - mountainColor - color of mountain line
//  - blobSize - size of characters used to draw mountain line elements
void drawMountains(float xLeft, float yBot, float w, float maxcalcHeight, color mountainColor, void blobSize) {
  stroke(mountainColor);
  fill(mountainColor);
  textSize(scalePixelsX(calcWidth*0.0225));
  float mountaincalcHeight=round(maxcalcHeight*random(0.5,1));
  float mountainDelta=-4;
  for (x=xLeft; x<xLeft+w; x+=blobSize*0.8) {
    for (y=yBot; y>yBot-mountaincalcHeight; y-=blobSize*0.8) {
      text("x",scalePixelsX(x+calcWidth*random(-0.002,0.002)),scalePixelsY(y+calcWidth*random(-0.002,0.002)));
    }
    if (random(1,10)>6) {
      mountaincalcHeight+=mountainDelta;
    }
    if (mountaincalcHeight>maxcalcHeight) {
      mountaincalcHeight-=abs(mountainDelta);
      mountainDelta-=random(0,5);
    }
    if (mountaincalcHeight<(maxcalcHeight/2)) {
      mountaincalcHeight+=abs(mountainDelta);
      mountainDelta+=random(0,5);
    }
    if (random(1,10)>9) {
      mountainDelta+=random(-5,5);
    }
  }
}

// Draw a line of almost-vertical grass blades
//  - xLeft - left x position of row of grass
//  - yTop - top y position of row of grass
//  - w - width of row of grass
//  - h - height of row of grass
//  - grassColor - color of grass blades
void drawGrass(float xLeft, float yTop, float w, float h, color grassColor) {
  var weight=calcWidth*0.0004;
  var offsetY=yTop;
  var maxTuftcalcHeight=calcHeight*0.004;
  for (y=yTop; y<yTop+h; y=y*1.0025) {
    if (offsetY<calcHeight*0.977) {
      for (x=xLeft+calcWidth*random(0, 0.01); x<xLeft+w-10; x+=calcWidth*random(0.01, 0.2)) {
        float endX=x+calcWidth*random(0.01, 0.05);
        drawOneTuft(x, offsetY, endX, grassColor, weight, maxTuftcalcHeight);
        weight*=1.01;
      }
      maxTuftcalcHeight*=1.25;
      offsetY*=1.023;
      weight*=1.04;
    }
  }
}

// Draw a small tuft of almost-vertical grass blades
//  - startX - horizontal x start position of tuft
//  - startY - vertical start position of tuft
//  - endX - horizontal x end position of tuft
//  - endY - vertical end position of tuft
//  - grassColor - color of grass blades
//  - weight- thickness of grass blades
//  - maxTuftcalcHeight - maximum height of a grass blade
void drawOneTuft(float startX, float startY, float endX, color grassColor, float weight, float maxTuftcalcHeight) {
  float h=hue(grassColor);
  float s=saturation(grassColor);
  float b=brightness(grassColor);
  grassColor = color(h, s, b, random(50,255));
  stroke(grassColor);
  strokeWeight(scalePixelsX(weight));
  for (x=startX+calcWidth*random(0.002,0.003); x<endX-calcWidth*random(0.002,0.003); x++) {
    if (random(1,10)>6) {
      if (x<calcWidth*0.985) {
        line(scalePixelsX(x), scalePixelsY(startY+maxTuftcalcHeight*random(0, 0.25)), scalePixelsX(x+calcWidth*random(-0.008,0.008)), scalePixelsY(startY-maxTuftcalcHeight*random(0, 1)));
      }
    }
  }
}

// Begin the recursive process of drawing a tree and its roots
// Then adds some tufts of grass to the bottom of the trunk, overlapping the roots
// Then adds leaves to the final tree
//  - x - horizontal x position of the base of the tree trunk
//  - y - vertical y position of the base of the tree trunk
//  - w - initial width of the base of the tree trunk
//  - colorTreeTrunkShading - color of shading on the tree trunk
//  - colorTreeTrunkBase - color of the tree trunk at the base
//  - colorTreeTrunkHighlight - color of highlights on the tree trunk
//  - colorBaseGrass - color of grass at the base of the tree trunk
//  - colorLeaves - color of leaves on the tree
//  - colorFruit - color of fruit (or contrasting leaves) on the tree
void drawTree(float x, float y, float w, color colorTreeTrunkShading, color colorTreeTrunkBase, color colorTreeTrunkHighlight, color colorBaseGrass, color colorLeaves, color colorFruit) { 
  drawBranch(x, y, x*random(0.95,1.05), y-(w*random(1.5,2.0)), w, colorTreeTrunkShading, colorTreeTrunkBase, colorTreeTrunkHighlight, colorLeaves, colorFruit); 
  fill(color(0,0,0,280));
  noStroke();  
  drawRoot(x, y, x, y+(calcHeight*0.001), w*0.6);
  drawOneTuft(x-(calcWidth*0.12), y+(calcHeight*0.019), x+(calcWidth*0.12), colorBaseGrass, calcWidth*0.0010, calcHeight*0.012);
  drawOneTuft(x-(calcWidth*0.16), y+(calcHeight*0.024), x+(calcWidth*0.16), colorBaseGrass, calcWidth*0.0010, calcHeight*0.016);
  drawOneTuft(x-(calcWidth*0.05), y+(calcHeight*0.022), x+(calcWidth*0.05), color(0,100,100,360), calcWidth*0.0010, calcHeight*0.015);
  drawLeaves();
}

// Draw a single branch of a tree
// Then make recursive calls to this function to draw additional smaller branches splitting to the left and right of this one
// Note that recursive calls are wrapped in setTimout() calls to push them into another processing thread to reduce browser sluggishness
//  - x1 - horizontal x start position of branch
//  - y1 - vertical start position of branch
//  - x2 - horizontal x end position of branch
//  - y2 - vertical end position of branch
//  - thickness - thickness of the branch
//  - colorTreeTrunkShading - color of shading on the tree trunk
//  - colorTreeTrunkBase - color of the tree trunk at the base
//  - colorTreeTrunkHighlight - color of highlights on the tree trunk
//  - colorBaseGrass - color of grass at the base of the tree trunk
//  - colorLeaves - color of leaves on the tree
//  - colorFruit - color of fruit (or contrasting leaves) on the tree
void drawBranch(float x1, float y1, float x2, float y2, float thickness, color colorTreeTrunkShading, color colorTreeTrunkBase, color colorTreeTrunkHighlight, color colorLeaves, color colorFruit) {

  // draw the main branch line in solid black
  stroke(0,0,2,360);
  strokeWeight(scalePixelsX(thickness));
  line(scalePixelsX(x1), scalePixelsY(y1), scalePixelsX(x2), scalePixelsY(y2));

  // if the branch is very thick give it some shading and texture
  if (thickness>calcWidth*0.0055) { 
    float lineLength=calculateLineLength(x1, y1, x2, y2);
    float increments = lineLength/thickness*6;
    textSize(scalePixelsX(thickness*1.2)); 
    for (int i=1; i<=increments; i++) {
      float x = lerp(x1, x2, i/increments);
      float y = lerp(y1, y2, i/increments);
      addTreeTexture(x, y, colorTreeTrunkBase);
    }
    textSize(scalePixelsX(thickness*0.5));
    for (int i=1; i<=increments; i++) {
      float x = lerp(x1, x2, i/increments);
      float y = lerp(y1, y2, i/increments);
      addTreeHighlight(x, y);
    }
  }

  // make potential new child branches thinner than their parent
  thickness=thickness*0.74;  

  // while the branch is thick enough, split it into two smaller ones
  if (thickness>calcWidth*0.0015) { 
      
    // split a branch out to the left
    setTimeout(function() {    
      float dx=thickness*random(2.3,2.8);
      float dy=thickness*random(-0.5,8.0);
      if (dy<calcHeight*0.16) {
        dy*=random(0.5,0.8);
      }
      if (dx<calcWidth*0.16) {
        dx*=random(1.2,1.5);
      } else if (dx>calcWidth*0.84) {
        dx/=random(1.2,1.5); 
      }   
      drawBranch(x2, y2, x2-dx, y2-dy, thickness, colorTreeTrunkShading, colorTreeTrunkBase, colorTreeTrunkHighlight, colorLeaves, colorFruit);
    },1);

    // split a branch out to the right
    setTimeout(function() {
      float dx=thickness*random(2.3,2.8);
      float dy=thickness*random(-0.5,8.0);
      if (dy<calcHeight*0.16) {
        dy*=random(0.5,0.8);
      }
      if (dx<calcWidth*0.16) {
        dx*=random(1.2,1.5);
      } else if (dx>calcWidth*0.84) {
        dx/=random(1.2,1.5); 
      }  
      drawBranch(x2, y2, x2+dx, y2-dy, thickness, colorTreeTrunkShading, colorTreeTrunkBase, colorTreeTrunkHighlight, colorLeaves, colorFruit);
    },1);

    // add some texture and highlight to the "joint" where the new branches begin
    textSize(scalePixelsX(thickness*1.2));
    addTreeTexture(x2-(calcWidth*0.0025), y2+(calcHeight*0.002), colorTreeTrunkBase);
    addTreeTexture(x2-(calcWidth*0.005), y2-(calcHeight*0.002), colorTreeTrunkBase);
    addTreeTexture(x2, y2+(calcHeight*0.0034), colorTreeTrunkBase);
    textSize(scalePixelsX(thickness*0.5));
    addTreeHighlight(x2-(calcWidth*0.002), y2+(calcHeight*0.002));
    addTreeHighlight(x2-(calcWidth*0.002), y2+(calcHeight*0.002));

  }

   // if the branch is very thin, calculate position of some leaves and fruit around the end
  if (thickness<calcWidth*0.012) {
    if (random(0,100)>=leafSparseness) { // only sometimes draw leaves
      append(leavesX,x2+leafSize*random(-1.2,1.2));
      append(leavesY,y2+leafSize*random(-1.2,1.2));
      float leafType=int(random(0,10));
      if (leafType>8) { 
        append(leavesC,colorFruit);
      } else if (leafType>7) {
        append(leavesC,color(0,0,100)); // white
      } else if (leafType>5) {
        append(leavesC,color(hue(colorLeaves), saturation(colorLeaves)+10, brightness(colorLeaves)-10, 360)); 
      } else {
        append(leavesC,colorLeaves); 
      }
    }
  } 

  lastBranchRendered=performance.now();

}

// Add some texture to the tree trunk base
//  - x - horizontal x position of the texture
//  - y - vertical y position of the texture
//  - colorTreeTrunkBase - color of the tree trunk at the base
void addTreeTexture(x, y, colorTreeTrunkBase) {
  fill(hue(colorTreeTrunkBase),30,45,35);
  float charType=random(1,60);
  if (charType<33) {
    text('#',scalePixelsX(x),scalePixelsY(y));
  } else if (charType>66) {
    text('_',scalePixelsX(x),scalePixelsY(y));
  } else {
    text('&',scalePixelsX(x),scalePixelsY(y));
  }
}

// Add some white highlights to the tree trunk base
//  - x - horizontal x position of the highlight
//  - y - vertical y position of the highlight
void addTreeHighlight(x, y) {
  fill(0,0,85,40); // white
  charType=random(1,100);
  if (charType<33) {
    text('#',scalePixelsX(x),scalePixelsY(y));
  } else if (charType>66) {
    text('_',scalePixelsX(x),scalePixelsY(y));
  } else {
    text('*',scalePixelsX(x),scalePixelsY(y));
  }  
}

// Draw a root on the tree
// Then recursively call this function to draw two smaller roots splitting to the left and right of this one
//  - x1 - horizontal x start position of root
//  - y1 - vertical start position of root
//  - x2 - horizontal x end position of root
//  - y2 - vertical end position of root
//  - thickness - thickness of the root
void drawRoot(float x1, float y1, float x2, float y2, float thickness) {
  stroke(color(0,5,5,300));
  noFill();
  strokeWeight(scalePixelsX(thickness));
  line(scalePixelsX(x1), scalePixelsY(y1), scalePixelsX(x2), scalePixelsY(y2));
  if (thickness>calcWidth*0.0024) {
    float dxL=calcWidth*random(0.022, 0.03);
    float dxR=calcWidth*random(0.022, 0.03);
    float dy=calcHeight*0.0038;
    drawRoot(x2, y2, x2+dxL, y2+dy, thickness*0.62);
    drawRoot(x2, y2, x2-dxR, y2+dy, thickness*0.62);
  }
}

// Draw leaves on the tree
// Leaf position and color have been previously stored in the global leavesX[], leavesY[] and leavesC[] arrays
//   which were populated during rendering of the branches, to be positioned roughly at the end of each branch
void drawLeaves() {
  if (performance.now()-lastBranchRendered<200) {
    setTimeout(function() {
      drawLeaves();
    },50);
  } else {
    if (leafSparseness) { 
      float leafSize=int(calcWidth*0.004*random(4.0,8.0));
      textSize(scalePixelsX(leafSize));
      string leafChars = '"""""******';
      noStroke();
      for (int i=0; i<leavesX.length; i++) {
        fill(leavesC[i]);
        for (int j=0; j<4; j++) {
          text(leafChars.charAt(int(random(0,leafChars.length()))),scalePixelsX(leavesX[i]),scalePixelsY(leavesY[i])); 
        }
      }  
    }
  }
}

// Return the left split complementary color for a given hue
//  hue - hue to split
color colorSplitComplementLeft(int h) {
  h+=150;
  h=h%360;
  return h;
}

// Return the right split complementary color for a given hue
//  hue - hue to split
color colorSplitComplementRight(int h) {
  h+=210;
  h=h%360;
  return h;
}

// Calculate the pixel length of a line, given it's start and end points
//  - x1 - horizontal x start position of the line
//  - y1 - vertical y start position of the line
//  - x2 - horizontal x end position of the line
//  - y2 - vertical y end position of the line
float calculateLineLength( float x1, float y1, float x2, float y2) {
    return sqrt( ((x2-x1)*(x2-x1)) + ((y2-y1)*(y2-y1)) );
}

// Scale a horizontal (x) position on the canvas to the width of the canvas
// This allows calculations to be done independent of canvas size
//  px - The horizontal x position to scale
float scalePixelsX(px) {
  return int(px*(width/calcWidth));
}

// Scale a vertical (y) position on the canvas to the width of the canvas
// This allows calculations to be done independent of canvas size
//  py - The vertical y position to scale
float scalePixelsY(px) {
  return int(px*(height/calcHeight));
}
