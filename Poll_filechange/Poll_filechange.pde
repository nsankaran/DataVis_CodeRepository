// Allows the user to select an excel spreadsheet to load. //<>//
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
  xlsData = importExcel(path);
  barChart = drawBarChart(xlsData); //<>//
  redraw();

  //for debugging purposes only
  l = int(xlsData[xlsData.length-1][1]);
  println(l);
}

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