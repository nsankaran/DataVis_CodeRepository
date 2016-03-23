// Allows the user to select an excel spreadsheet to load.
// Each time the excel file is changed and saved, processing reloads the file and updates the sketch.

import java.util.*;
import java.io.*;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Cell; 
import org.gicentre.utils.stat.*;        // For chart classes.
import org.gicentre.utils.colour.*;

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
int hdrFlag; // First row header flag (1,0)
int lblFlag; // First column labels flag (1,0)
int[] colType;
int[] rowType;

void setup() {
  selectInput("Select an excel file to process:", "fileSelected");
  size(800, 800);
  smooth();
  noLoop();

}

void fileSelected(File selection) {
  
  if (selection == null) {
    println("No file selected.");
  } else {
    println("User selected:  " + selection.getAbsolutePath());
    path = selection.getAbsolutePath();

    // create new Timer task
    TimerTask task = new FileWatcher( new File(path));
    // create timer
    Timer timer = new Timer();
    timer.schedule( task, new Date(), 10 ); // check every 10ms

    loadData();
  }
}

void loadData() { // Data handling

  readExcel(path);


  //----------------
  // Assume data organized down columns (default).
  // for each column with numeric data, if header exists then create list of fields to plot.
  // if no header exists prompt user for which column(s) to plot.
  // if first column = string, use as labels. 
  // if string encountered in column with mostly numeric, then assign to 'blank' cell or '0'
  // create 3 variables: 'Fields' , 'Labels' and 'Values' such that 
  // dims(Values) = [labels.length x fields.length]

  //barChart = drawBarChart(xlsData);
  lineChart = drawXYChart(xlsData);
  redraw();

  //for debugging purposes only
  //l = int(xlsData[xlsData.length-1][1]);
  //println(l);
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
  } 
  if (lineChart != null) {
    lineChart.draw(10, 10, width-20, height-20);
    fill(120);

  }
}