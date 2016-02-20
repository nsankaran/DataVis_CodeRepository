// Allows the user to select an excel spreadsheet to load.
// Each time the excel file is changed and saved, processing reloads the file and updates the sketch.


import java.util.*;
import java.io.*;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Cell; 
import org.gicentre.utils.stat.*;        // For chart classes.

String[][] xlsData;
int[][] dataType;
String path;
int l;
SXSSFWorkbook swb=null;
Sheet sheet=null;
InputStream inp=null;
Workbook wb=null;
int sizeX;
int sizeY;
int hdrFlag;
int[] colType;
int[] rowType;


void setup() {
  selectInput("Select an excel file to process:", "fileSelected");
  size(800, 300);
  smooth();
  noLoop();
  fill(120);
}

void fileSelected(File selection) {
  if (selection == null) {
    println("No file selected.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    path = selection.getAbsolutePath();

    // create new Timer task
    TimerTask task = new FileWatcher( new File(path));
    // create timer
    Timer timer = new Timer();
    timer.schedule( task, new Date(), 10 ); // check every 10ms

    loadData();
  }
}

void loadData() {

  // Step 1: get datatype of every cell and data value
  readExcel(path);

  // Step 2: look for header in first row
  int H1 = 0;
  for (int j=0; j<sizeX; j++) {
    if (dataType[j][0] == 1) {
      H1 = H1+1;
    } else {
    }
  }

  if ((H1/sizeX) >=0.5) {
    hdrFlag = 1;
    println();
    println("Found headers in row 1");
  } else { 
    hdrFlag = 0;
  }

  // Step 3: look for common data type in each column
  colType = new int[sizeX]; 
  for (int i=0; i<sizeX; i++) {
    int[] Ccount = new int[sizeX];

    for (int j=hdrFlag; j<sizeY; j++) {
      if (dataType[i][j] == 0) {
        Ccount[0] = Ccount[0]+1;
      } else if (dataType[i][j] == 1) {        
        Ccount[1] = Ccount[1]+1;
      } else if (dataType[i][j] == 2) {        
        Ccount[2] = Ccount[2]+1;
      } else if (dataType[i][j] == 3) {       
        Ccount[3] = Ccount[3]+1;
      }
    } // loop through rows


    int largest = Ccount[0], index = 0;
    for (int k=1; k<Ccount.length; k++) {
      if (Ccount[k] > largest) {
        largest = Ccount[k];
        index = k;
      }
    }
    colType[i] = index;
  } // loop through columns

  // Step 4: look for common data type in each row
  rowType = new int[sizeY]; 
  for (int i=0; i<sizeY; i++) {
    int[] Ccount = new int[sizeX];

    for (int j=0; j<sizeX; j++) {
      if (dataType[j][i] == 0) {
        Ccount[0] = Ccount[0]+1;
      } else if (dataType[j][i] == 1) {        
        Ccount[1] = Ccount[1]+1;
      } else if (dataType[j][i] == 2) {        
        Ccount[2] = Ccount[2]+1;
      } else if (dataType[j][i] == 3) {       
        Ccount[3] = Ccount[3]+1;
      }
    } // loop through rows


    int largest = Ccount[0], index = 0;
    for (int k=1; k<Ccount.length; k++) {
      if (Ccount[k] > largest) {
        largest = Ccount[k];
        index = k;
      }
    }
    rowType[i] = index;
  } // loop through columns

  // Step 4: Import data using above information
  //----------------
  // Assume data organized down columns (default).
  // for each column with numeric data, if header exists then create list of fields to plot.
  // if no header exists prompt user for which column(s) to plot.
  // if first column = string, use as labels. 
  // if string encountered in column with mostly numeric, then assign to 'blank' cell or '0'
  // create 3 variables: 'Fields' , 'Labels' and 'Values' such that 
  // dims(Values) = [labels.length x fields.length]

  xlsData = importExcel(path); //<>//
  barChart = drawBarChart(xlsData);
  redraw();

  //for debugging purposes only
  l = int(xlsData[xlsData.length-1][1]);
  println(l);
} // end loadData()

class FileWatcher extends TimerTask {
  long timeStamp;
  File file;

  FileWatcher( File file ) {
    this.file = file;
    this.timeStamp = file.lastModified();
  }

  // check if file has been modified
  void run() {
    long timeStamp = file.lastModified();

    if ( this.timeStamp != timeStamp ) {
      this.timeStamp = timeStamp;
      onChange(file);
    }
  }

  // load data again
  void onChange( File file ) {
    loadData();
  }
}

void draw() {
  background(255);

  if (barChart!= null) {
    barChart.draw(10, 10, width-20, height-20);
    fill(120);
  } else {
  }
}