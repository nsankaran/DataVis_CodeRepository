// Functions to draw various figures

PFont titleFont, smallFont;
ColourTable[] coloursCat;
BarChart barChart = null;
XYChart lineChart;

// 1) Bar chart 
BarChart drawBarChart(String[][] xlsData) {

  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);

  coloursCat = new ColourTable[8];
  coloursCat[0]  = ColourTable.getPresetColourTable(ColourTable.SET1_9);
  coloursCat[1]  = ColourTable.getPresetColourTable(ColourTable.SET2_8);
  coloursCat[2]  = ColourTable.getPresetColourTable(ColourTable.SET3_12);
  coloursCat[3]  = ColourTable.getPresetColourTable(ColourTable.PASTEL1_9);
  coloursCat[4]  = ColourTable.getPresetColourTable(ColourTable.PASTEL2_8);
  coloursCat[5]  = ColourTable.getPresetColourTable(ColourTable.DARK2_8);
  coloursCat[6]  = ColourTable.getPresetColourTable(ColourTable.PAIRED_12);
  coloursCat[7]  = ColourTable.getPresetColourTable(ColourTable.ACCENT_8);
 
  barChart = new BarChart(this);
  float[] values = new float[sizeY-1];
  String[] names= new String[sizeY-1];
  for (int i=hdrFlag; i<sizeY; i++) {
    values[i-1] = Float.parseFloat(xlsData[4][i]);
    names[i-1] = xlsData[0][i];
  }
  barChart.setData(values);
  barChart.setBarLabels(names);
  barChart.setBarColour(values, coloursCat[1]);
  barChart.setBarGap(2); 
  barChart.setValueFormat("#####");
  barChart.showValueAxis(true); 
  barChart.showCategoryAxis(true);
  barChart.setMinValue(0.0);


  return barChart;
}

// 2) Line Chart
XYChart drawXYChart(String[][] xlsData, int colNum) {

  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);

  lineChart = new XYChart(this);
  float[] yvalues = new float[sizeY-1];
  float[] xvalues = new float[sizeY-1];
  String names = "";
  coloursCat = new ColourTable[8];
  coloursCat[0]  = ColourTable.getPresetColourTable(ColourTable.SET1_9);
  coloursCat[1]  = ColourTable.getPresetColourTable(ColourTable.SET2_8);
  coloursCat[2]  = ColourTable.getPresetColourTable(ColourTable.SET3_12);
  coloursCat[3]  = ColourTable.getPresetColourTable(ColourTable.PASTEL1_9);
  coloursCat[4]  = ColourTable.getPresetColourTable(ColourTable.PASTEL2_8);
  coloursCat[5]  = ColourTable.getPresetColourTable(ColourTable.DARK2_8);
  coloursCat[6]  = ColourTable.getPresetColourTable(ColourTable.PAIRED_12);
  coloursCat[7]  = ColourTable.getPresetColourTable(ColourTable.ACCENT_8);
  for (int i=hdrFlag; i<sizeY; i++) {
    yvalues[i-1] = Float.parseFloat(xlsData[colNum][i]);
    xvalues[i-1] = float(i);
    names = names.concat(xlsData[0][i]);
  }

  lineChart.setData(xvalues, yvalues);
  lineChart.showXAxis(true);
  lineChart.showYAxis(true);
  lineChart.setLineColour(color(20, 80, 200, 100));
  lineChart.setPointSize(5);
  lineChart.setLineWidth(2);
  lineChart.setXAxisLabel(names);
  lineChart.setYAxisLabel(xlsData[colNum][0]);
  lineChart.setXFormat("");
  lineChart.setAxisColour(255);
  lineChart.setAxisLabelColour(255);
  lineChart.setAxisValuesColour(255);
  //lineChart.transposeAxes(true);
  return lineChart;
}