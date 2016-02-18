SXSSFWorkbook swb=null;
Sheet sh=null;
InputStream inp=null;
Workbook wb=null;

String[][] importExcel(String filepath) {
  String[][] temp;
  int[][] celldatatype;
  try {
    inp = new FileInputStream(filepath);
  }
  catch(Exception e) {
  }
  try {
    wb = WorkbookFactory.create(inp);
  }
  catch(Exception e) {
  }
  Sheet sheet = wb.getSheetAt(0);
  int sizeX = sheet.getLastRowNum()+1; // +1 because numbering convention differs btwn excel and java.
  int sizeY = sheet.getRow(0).getLastCellNum();//100;
  //for (int i=0; i<sizeX; ++i) {
  //  Row row = sheet.getRow(i);
  //  for (int j=0; j<sizeY; ++j) {
  //    try {
  //      Cell cell = row.getCell(j);
  //    }
  //    catch(Exception e) {
  //      if (j>sizeY) {
  //        sizeY = j;
  //      }
  //    }
  //  }
  //}
  temp = new String[sizeX][sizeY];
  celldatatype = new int[sizeX][sizeY];
  for (int i=0; i<sizeX; ++i) {
    for (int j=0; j<sizeY; ++j) {
      Row row = sheet.getRow(i);
      try {
        Cell cell = row.getCell(j);
        celldatatype[i][j] = cell.getCellType();
        if (cell.getCellType()==0 || cell.getCellType()==2 || cell.getCellType()==3)cell.setCellType(1);
        temp[i][j] = cell.getStringCellValue();
      }
      catch(Exception e) {
      }
    }
  }
  println("Excel file imported: " + filepath + " successfully!");
  return temp;
  //return celldatatype;
}

//void exportExcel(String[][] data, String filepath) {
//  SXSSFWorkbook wwb = new SXSSFWorkbook(100);
//  Sheet sh = wwb.createSheet();
//  int sizeX = data.length;
//  int sizeY = data[0].length;
//  for (int i=0;i<sizeX;++i) {
//    Row row = sh.createRow(i);
//    for (int j=0;j<sizeY;++j) {
//      Cell cell = row.createCell(j);
//      if (cell.getCellType()==0 || cell.getCellType()==2 || cell.getCellType()==3)cell.setCellType(1);
//      cell.setCellValue(data[i][j]);
//    }
//  }
//  try {
//    FileOutputStream out = new FileOutputStream(filepath);
//    wwb.write(out);
//    println("Excel file exported: " + filepath + " sucessfully!");
//  }
//  catch (Exception e) {
//    println("Error in saving the file...sorry!");
//  }
//}