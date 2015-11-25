import wblut.math.*; //<>// //<>// //<>//
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.List;
import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.dxf.*;
//import processing.opengl.*;


HE_Mesh mesh1;
HE_Mesh mesh2;
WB_Render render;
String[] lines;
String[] pieces;
String[] header;
String[] plotfuncnames;
int[][] rgbArrayplot;
int ltot;
int lplot;
int min_idx1;
int min_idx2;
//float[] z1; // to store values
//float[] z2; // to store values
//int diffi;
//int diffj;
int gridDim = 151;
int gridSize = 650;
float[][] values1;
float[][] values2;
IntList z_idxs;
boolean record;
float counter;


void setup() {

  size(1600, 700, P3D);
  smooth(8);

  // get data from KEGG file
  lines = loadStrings("KEGG.txt");
  ltot = lines.length-1;  
  header = split(lines[0], TAB);
  println("there are " + ltot + " lines of data");

  float[] sig =new float[ltot];
  float[] z1 =new float[ltot];
  float[] z2 =new float[ltot];
  String[] allfuncs=new String[ltot];
  values1=new float[gridDim][gridDim];
  values2=new float[gridDim][gridDim];
  z_idxs=new IntList();
  counter = 0.0;

  // first extract z values and assign standard deviation to each gaussian
  for (int pp=0; pp<ltot; pp++) {
    pieces = split(lines[pp+1], TAB);
    if (pieces.length == 5) { 
      z1[pp] = float(pieces[2]); // value to be represented from data
      z2[pp] = float(pieces[3]); // value to be represented from data
      allfuncs[pp] = pieces[0];
      //---------------------------------------
      //Remove Metabollic Pathways
      if (z1[pp] > 100) {
        z1[pp] = 0;
        z2[pp] = 0;
      } 
      //---------------------------------------
      if (Float.isNaN(z1[pp])) { // NaN entries to 0
        z1[pp] = 0;
      }
      if (Float.isNaN(z2[pp])) { // NaN entries to 0
        z2[pp] = 0;
      }
      sig[pp] = 10;//constrain(round(z1[pp]*0.5), 2, 30); // standard dev of each peak scales with value.

      if (abs(z1[pp] - z2[pp]) >= 6) {
        z_idxs.append(pp);
      }
    }
  }

  // Only get Indices of values that change
  float[] z1plot=new float[z_idxs.size()];
  float[] z2plot=new float[z_idxs.size()];
  float[] sigmaplot=new float[z_idxs.size()];
  plotfuncnames =new String[z_idxs.size()];

  for (int zloop=0; zloop<z_idxs.size(); zloop++) {
    z1plot[zloop] = 3*z1[z_idxs.get(zloop)];
    z2plot[zloop] = 3*z2[z_idxs.get(zloop)];
    sigmaplot[zloop] = sig[z_idxs.get(zloop)];
    plotfuncnames[zloop] = allfuncs[z_idxs.get(zloop)];
  }

  lplot = z_idxs.size();
  int[][] uvpeak =new int[2][lplot];
  int[][] clrList=new int[3][lplot];
  float[] ybound=new float[lplot];
  float[] xbound=new float[lplot];


  println(z1plot);

  // create predefined colors:
  int[][] rgbarray = {{255, 0, 0}, {153, 0, 0}, {89, 0, 0}, {191, 48, 48}, {102, 26, 26}, {178, 89, 89}, {76, 38, 38}, {51, 26, 26}, {102, 77, 77}, {191, 26, 0}, {51, 7, 0}, {255, 89, 64}, {127, 45, 32}, {64, 22, 16}, {242, 137, 121}, 
    {153, 87, 77}, {115, 65, 57}, {255, 200, 191}, {179, 140, 134}, {140, 110, 105}, {77, 60, 57}, {229, 61, 0}, {153, 41, 0}, {115, 31, 0}, {242, 109, 61}, {191, 86, 48}, {140, 63, 35}, {89, 40, 22}, {255, 162, 128}, 
    {204, 129, 102}, {140, 89, 70}, {76, 48, 38}, {51, 32, 26}, {230, 187, 172}, {179, 146, 134}, {102, 83, 77}, {217, 87, 0}, {166, 66, 0}, {115, 46, 0}, {51, 20, 0}, {217, 119, 54}, {166, 91, 41}, {127, 70, 32}, {76, 42, 19}, 
    {255, 179, 128}, {178, 125, 89}, {102, 71, 51}, {64, 45, 32}, {242, 206, 182}, {191, 163, 143}, {128, 108, 96}, {77, 65, 57}, {51, 43, 38}, {255, 136, 0}, {191, 102, 0}, {127, 68, 0}, {89, 48, 0}, {229, 149, 57}, {178, 116, 45}, 
    {115, 75, 29}, {76, 50, 19}, {51, 33, 13}, {255, 196, 128}, {204, 156, 102}, {127, 98, 64}, {230, 203, 172}, {166, 146, 124}, {255, 170, 0}, {178, 119, 0}, {127, 85, 0}, {89, 60, 0}, {242, 182, 61}, {115, 86, 29}, {204, 170, 102}, 
    {89, 74, 45}, {242, 222, 182}, {128, 117, 96}, {204, 163, 0}, {140, 112, 0}, {76, 61, 0}, {51, 41, 0}, {255, 217, 64}, {115, 98, 29}, {255, 230, 128}, {140, 126, 70}, {102, 92, 51}, {179, 170, 134}, {89, 85, 67}, 
    {255, 238, 0}, {140, 131, 0}, {204, 194, 51}, {166, 160, 83}, {51, 49, 26}, {242, 238, 182}, {64, 63, 48}, {202, 217, 0}, {143, 153, 0}, {83, 89, 0}, {121, 128, 32}, {61, 64, 16}, {210, 217, 108}, {194, 242, 0}, 
    {92, 102, 51}, {133, 140, 105}, {85, 128, 0}, {34, 51, 0}, {163, 217, 54}, {124, 166, 41}, {67, 89, 22}, {212, 255, 128}, {170, 204, 102}, {138, 166, 83}, {106, 128, 64}, {64, 77, 38}, {199, 217, 163}, {136, 255, 0}, {39, 51, 26}, 
    {68, 77, 57}, {41, 102, 0}, {98, 179, 45}, {34, 128, 0}, {17, 64, 0}, {98, 217, 54}, {113, 179, 89}, {31, 89, 22}, {144, 255, 128}, {72, 128, 64}, {180, 230, 172}, {80, 102, 77}, {0, 242, 0}, {0, 230, 0}, {0, 179, 0}, 
    {102, 204, 102}, {134, 179, 134}, {13, 51, 18}, {38, 77, 43}, {105, 140, 110}, {121, 242, 153}, {48, 64, 52}, {0, 255, 102}, {0, 204, 82}, {0, 166, 66}, {0, 115, 46}, {64, 255, 140}, {38, 153, 84}, {26, 102, 56}, 
    {96, 191, 134}, {64, 128, 89}, {191, 255, 217}, {45, 89, 68}, {163, 217, 191}, {124, 166, 146}, {67, 89, 79}, {0, 64, 43}, {57, 230, 172}, {13, 51, 38}, {0, 153, 122}, {54, 217, 184}, {32, 128, 108}, {57, 115, 103}, 
    {143, 191, 182}, {96, 128, 121}, {0, 255, 238}, {0, 166, 155}, {0, 64, 60}, {54, 217, 206}, {22, 89, 85}, {191, 255, 251}, {38, 51, 50}, {0, 202, 217}, {0, 48, 51}, {128, 247, 255}, {96, 185, 191}, {70, 136, 140}, 
    {32, 62, 64}, {143, 188, 191}, {67, 88, 89}, {0, 194, 242}, {0, 143, 179}, {0, 61, 77}, {35, 119, 140}, {26, 87, 102}, {115, 207, 230}, {89, 161, 179}, {115, 145, 153}, {0, 77, 115}, {0, 51, 77}, {0, 34, 51}, 
    {64, 191, 255}, {51, 153, 204}, {108, 181, 217}, {45, 74, 89}, {191, 234, 255}, {86, 105, 115}, {48, 58, 64}, {0, 95, 179}, {0, 34, 64}, {57, 149, 230}, {45, 116, 179}, {115, 176, 230}, {77, 117, 153}, {57, 88, 115}, 
    {32, 49, 64}, {163, 191, 217}, {115, 135, 153}, {67, 79, 89}, {0, 76, 191}, {0, 51, 128}, {61, 133, 242}, {26, 56, 102}, {128, 179, 255}, {77, 107, 153}, {45, 62, 89}, {191, 217, 255}, {0, 51, 191}, {0, 34, 128}, 
    {61, 109, 242}, {38, 69, 153}, {22, 40, 89}, {128, 162, 255}, {89, 113, 179}, {57, 73, 115}, {32, 40, 64}, {163, 177, 217}, {86, 94, 115}, {38, 42, 51}, {0, 15, 115}, {64, 89, 255}, {19, 27, 77}, {13, 18, 51}, 
    {128, 145, 255}, {102, 116, 204}, {77, 87, 153}, {191, 200, 255}, {115, 120, 153}, {57, 60, 77}, {0, 0, 242}, {0, 0, 217}, {0, 0, 140}, {0, 0, 77}, {38, 38, 153}, {57, 57, 115}, {7, 0, 51}, {89, 64, 255}, {101, 89, 179}, 
    {36, 32, 64}, {44, 0, 166}, {46, 25, 102}, {145, 115, 230}, {167, 153, 204}, {70, 32, 128}, {42, 19, 77}, {217, 191, 255}, {87, 77, 102}, {102, 0, 191}, {61, 0, 115}, {48, 0, 89}, {124, 48, 191}, {33, 13, 51}, 
    {137, 89, 179}, {124, 105, 140}, {162, 0, 242}, {213, 128, 255}, {96, 57, 115}, {64, 38, 77}, {43, 26, 51}, {58, 48, 64}, {102, 0, 128}, {51, 0, 64}, {87, 26, 102}, {184, 102, 204}, {242, 191, 255}, {194, 153, 204}, 
    {226, 0, 242}, {167, 0, 179}, {133, 35, 140}, {148, 77, 153}, {217, 54, 206}, {64, 16, 61}, {230, 115, 222}, {153, 115, 150}, {115, 86, 113}, {255, 0, 204}, {179, 0, 143}, {140, 0, 112}, {51, 0, 41}, {102, 26, 87}, 
    {191, 96, 172}, {115, 57, 103}, {64, 32, 57}, {255, 0, 170}, {217, 54, 163}, {242, 121, 202}, {166, 83, 138}, {89, 45, 74}, {255, 191, 234}, {229, 0, 122}, {89, 0, 48}, {166, 41, 108}, {102, 26, 66}, {51, 13, 33}, 
    {166, 124, 146}, {102, 77, 90}, {51, 38, 45}, {191, 0, 77}, {153, 0, 61}, {64, 0, 26}, {191, 48, 105}, {140, 35, 77}, {255, 128, 179}, {191, 96, 134}, {115, 57, 80}, {217, 163, 184}, {178, 0, 48}, {140, 0, 37}, 
    {102, 0, 27}, {76, 0, 20}, {255, 64, 115}, {115, 29, 52}, {51, 13, 23}, {153, 77, 97}, {77, 38, 48}, {77, 57, 62}, {242, 0, 32}, {140, 0, 19}, {242, 61, 85}, {242, 121, 137}, {102, 51, 58}, {242, 182, 190}, {153, 115, 120}};

  // space out evenly across perceptual colorspace lplot unique colors.
  int clrlen = (rgbarray.length);
  rgbArrayplot=new int[lplot][3];
  for (int clridx = 0; clridx< lplot; clridx++) {
    rgbArrayplot[clridx][0]= rgbarray[(floor(clrlen/lplot))*(clridx)][0]; //r
    rgbArrayplot[clridx][1]= rgbarray[(floor(clrlen/lplot))*(clridx)][1]; //g
    rgbArrayplot[clridx][2]= rgbarray[(floor(clrlen/lplot))*(clridx)][2]; //b
  }


  for (int f = 0; f< lplot; f++) {

    // assign data to grid points 
    // space peaks pseudo-randomly across landscape so no xy overlap.
    ybound[f] = (floor(f/sqrt(lplot)))*(gridDim/sqrt(lplot));
    xbound[f] = (f%floor(sqrt(lplot)))*(gridDim/sqrt(lplot));
    uvpeak[0][f] = int(random(ybound[f]+sigmaplot[f], ybound[f]+(gridDim/sqrt(lplot))-sigmaplot[f]));
    uvpeak[1][f] = int(random(xbound[f]+sigmaplot[f], xbound[f]+(gridDim/sqrt(lplot))-sigmaplot[f]));
    clrList[0][f] = int(random(102, 255));
    clrList[1][f] = int(random(0, 255));
    clrList[2][f] = int(random(0, 102));

    for (int j = 0; j < gridDim; j++) {
      for (int i = 0; i < gridDim; i++) {
        int diffi=i - uvpeak[0][f];
        int diffj = j - uvpeak[1][f];
        if (abs(diffi) <=sigmaplot[f] & abs(diffj)<=sigmaplot[f]) {
          // multiply gaussian by z[f] * sig[f] to compensate for larger std dev of higher values.
          values1[i][j] = max(abs(values1[i][j]), abs(sigmaplot[f]*z1plot[f]*((1 / sqrt(TWO_PI * sig[f])) * exp(-(sq(diffi) / (2 * sigmaplot[f])) - (sq(diffj) / (2 * sigmaplot[f]))))));        
          values2[i][j] = max(abs(values2[i][j]), abs(sigmaplot[f]*z2plot[f]*((1 / sqrt(TWO_PI * sig[f])) * exp(-(sq(diffi) / (2 * sigmaplot[f])) - (sq(diffj) / (2 * sigmaplot[f]))))));
        }
      }
    }
  }

  HEC_Grid creator1=new HEC_Grid();
  creator1.setU(gridDim-1);// number of cells in U direction
  creator1.setV(gridDim-1);// number of cells in V direction
  creator1.setUSize(gridSize);// size of grid in U direction
  creator1.setVSize(gridSize);// size of grid in V direction
  creator1.setWValues(values1);// displacement of grid points (W value)
  mesh1=new HE_Mesh(creator1);

  HEC_Grid creator2=new HEC_Grid();
  creator2.setU(gridDim-1);// number of cells in U direction
  creator2.setV(gridDim-1);// number of cells in V direction
  creator2.setUSize(gridSize);// size of grid in U direction
  creator2.setVSize(gridSize);// size of grid in V direction
  creator2.setWValues(values2);// displacement of grid points (W value)
  mesh2=new HE_Mesh(creator2);

  // FACE ITERATION FOR MESH1
  HE_FaceIterator fItr1mesh1=new HE_FaceIterator(mesh1);
  HE_FaceIterator fItr2mesh1=new HE_FaceIterator(mesh1);
  HE_FaceIterator fItr3mesh1=new HE_FaceIterator(mesh1);

  // Begin iterating faces
  int fidx = 0;
  float[] w1=new float[mesh1.getNumberOfFaces()];
  while (fItr1mesh1.hasNext()) {

    // use first iterator get w values of each face
    w1[fidx] = fItr1mesh1.next().getFaceUVWs().get(1).wf(); 

    // second iterator to get face centers as Gridpoint units:
    String fc1 = fItr2mesh1.next().getFaceCenter().toString();
    String[] xyzstring1 = splitTokens(fc1, "[x=,yz]");    
    float xfc1 = ((float(xyzstring1[1]) + (gridSize/2))/gridSize)*gridDim;
    float yfc1 = ((float(xyzstring1[3]) + (gridSize/2))/gridSize)*gridDim;

    // for each face find distances to each xypeak
    float[] rads1=new float[lplot];
    for (int ridx=0; ridx<lplot; ridx++) {
      rads1[ridx] = sqrt(sq(uvpeak[0][ridx] - xfc1)+ sq(uvpeak[1][ridx] - yfc1));
    }

    // find index of minimum distance
    for (int midx=0; midx<lplot; midx++) {
      if (rads1[midx] == min(rads1)) {
        min_idx1 = midx;
      } else {
      }
    }

    color c1 = color(200, 200, 200); 
    color c2 = color(rgbArrayplot[min_idx1][0], rgbArrayplot[min_idx1][1], rgbArrayplot[min_idx1][2]);

    if (values1[int(xfc1)][int(yfc1)] > 0) { //(rads[min_idx] <= 2*sig[min_idx]) { 
      float[] valLoc1=new float[1];
      // search the local neighbourhood for the maximum Zval
      for (int xloc = int(xfc1) - int(2*sig[min_idx1]); xloc < int(xfc1) + int(2*sig[min_idx1]); xloc++) {
        for (int yloc = int(yfc1) - int(2*sig[min_idx1]); yloc < int(yfc1) + int(2*sig[min_idx1]); yloc++) {       
          if (xloc >0 && xloc < gridDim) {
            if (yloc>0 && yloc < gridDim) {
              valLoc1 = append(valLoc1, values1[xloc][yloc]);
            }
          }
        }
      }

      // find max Zvalue in local neighbourhood
      float maxZ1 = max(valLoc1);

      float Camt1 = (values1[int(xfc1)][int(yfc1)])/maxZ1;
      color faceClr1 = lerpColor(c1, c2, sqrt(Camt1)); // take sqrt so that peaks are predominantly colored

      // third iterator to set color
      fItr3mesh1.next().setColor(faceClr1);
    } else {
      fItr3mesh1.next().setColor(color(200, 200, 200));//,int(1/255)));
    }
    fidx = fidx+1;
  }

  // FACE ITERATION FOR MESH2
  HE_FaceIterator fItr1mesh2=new HE_FaceIterator(mesh2);
  HE_FaceIterator fItr2mesh2=new HE_FaceIterator(mesh2);
  HE_FaceIterator fItr3mesh2=new HE_FaceIterator(mesh2);

  // Begin iterating faces
  int fidx2 = 0;
  float[] w2=new float[mesh2.getNumberOfFaces()];
  while (fItr1mesh2.hasNext()) {

    // use first iterator get w values of each face
    w2[fidx2] = fItr1mesh2.next().getFaceUVWs().get(1).wf(); 

    // second iterator to get face centers as Gridpoint units:
    String fc2 = fItr2mesh2.next().getFaceCenter().toString();
    String[] xyzstring2 = splitTokens(fc2, "[x=,yz]");    
    float xfc2 = ((float(xyzstring2[1]) + (gridSize/2))/gridSize)*gridDim;
    float yfc2 = ((float(xyzstring2[3]) + (gridSize/2))/gridSize)*gridDim;

    // for each face find distances to each xypeak
    float[] rads2=new float[lplot];
    for (int ridx=0; ridx<lplot; ridx++) {
      rads2[ridx] = sqrt(sq(uvpeak[0][ridx] - xfc2)+ sq(uvpeak[1][ridx] - yfc2));
    }

    // find index of minimum distance
    for (int midx=0; midx<lplot; midx++) {
      if (rads2[midx] == min(rads2)) {
        min_idx2 = midx;
      } else {
      }
    }

    color c1 = color(200, 200, 200); 
    color c2 = color(rgbArrayplot[min_idx2][0], rgbArrayplot[min_idx2][1], rgbArrayplot[min_idx2][2]);

    if (values2[int(xfc2)][int(yfc2)] > 0) { //(rads[min_idx] <= 2*sig[min_idx]) { 
      float[] valLoc2=new float[1];
      // search the local neighbourhood for the maximum Zval
      for (int xloc = int(xfc2) - int(2*sig[min_idx2]); xloc < int(xfc2) + int(2*sig[min_idx2]); xloc++) {
        for (int yloc = int(yfc2) - int(2*sig[min_idx2]); yloc < int(yfc2) + int(2*sig[min_idx2]); yloc++) {       
          if (xloc >0 && xloc < gridDim) {
            if (yloc>0 && yloc < gridDim) {
              valLoc2 = append(valLoc2, values2[xloc][yloc]);
            }
          }
        }
      }

      // find max Zvalue in local neighbourhood
      float maxZ2 = max(valLoc2);

      float Camt2 = (values2[int(xfc2)][int(yfc2)])/maxZ2;
      color faceClr2 = lerpColor(c1, c2, sqrt(Camt2)); // take sqrt so that peaks are predominantly colored

      // third iterator to set color
      fItr3mesh2.next().setColor(faceClr2);
    } else {
      fItr3mesh2.next().setColor(color(200, 200, 200));//,int(1/255)));
    }
    fidx2 = fidx2+1;
  }
  render=new WB_Render(this);
} // end void setup

void draw() {
  background(255);
  //directionalLight(250, 250, 250, 0, -0.7, -0.7);
  lights();
  counter++;
  //if (record) {
  //beginRaw(DXF,"fibroblast_ipSC_KEGG_deltathresh_6.dxf");
  //}
  fill(0);
  text(header[2], width*5/24, height/10);
  text(header[3], width*12/24, height/10);
  for (int tidx=0; tidx< lplot; tidx++) { 
    fill(rgbArrayplot[tidx][0], rgbArrayplot[tidx][1], rgbArrayplot[tidx][2]);
    text(plotfuncnames[tidx], width*5/6, (height/(lplot+1))*(tidx+1)); // space text evenly along y-axis
    //rect(width*0.75,(height/(lplot+1))*(tidx+1), width*0.03, (height/(lplot))*0.5);
  }

  //camera(width/2.0, height/8.0,(height/2.0) / tan(PI*30.0 / 180.0),width/2.0, height/2.0, 0, 0, 1, 0);
  translate(width*10/24, height/1.5, -height/2);
  rotateY(mouseX*1.0f/width*TWO_PI);
  translate(-width*10/24, -height/1.5, height/2);
  
  pushMatrix();
  translate(width*5/24, height/1.5, -height/2);
  //rotateX(PI/2.0);
  rotateX(PI/2.0);
  //rotateY(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFacesFC(mesh1);
  stroke(50);
  render.drawEdges(mesh1);

  translate(width*10/24, 0, 0);
  noStroke();
  render.drawFacesFC(mesh2);
  stroke(50);
  render.drawEdges(mesh2);
  popMatrix();
}