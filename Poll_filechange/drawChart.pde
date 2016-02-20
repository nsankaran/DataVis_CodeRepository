
PFont titleFont, smallFont;
BarChart barChart = null;

BarChart drawBarChart(String[][] xlsData) {


  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);

  barChart = new BarChart(this);
  float[] values = new float[xlsData.length-1];
  String[] names= new String[xlsData.length-1];

  for (int i=hdrFlag; i<xlsData.length; i++) {
    values[i-1] = Float.parseFloat(xlsData[i][1]);
    names[i-1] = xlsData[i][0];
  }
  barChart.setData(values);
  barChart.setBarLabels(names);

  barChart.setBarColour(color(200, 80, 80, 100));
  barChart.setBarGap(2); 
  barChart.setValueFormat("#####");
  barChart.showValueAxis(true); 
  barChart.showCategoryAxis(true); 


  return barChart;
}