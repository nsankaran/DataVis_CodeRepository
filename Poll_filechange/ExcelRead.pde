

void readExcel(String filepath) {

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
  sizeY = sheet.getLastRowNum()+1; // +1 because numbering convention differs btwn excel and java.
  sizeX = sheet.getRow(0).getLastCellNum();

  dataType = new int[sizeX][sizeY];
  for (int i=0; i<sizeX; ++i) {
    for (int j=0; j<sizeY; ++j) {
      Row row = sheet.getRow(j);
      try {
        Cell cell = row.getCell(i);
        dataType[i][j] = cell.getCellType();
      }
      catch(Exception e) {
      }
    }
  }
  
  // place data handling stages here
}

String[][] importExcel(String filepath) {
  String[][] temp;
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
  Sheet sheet = wb.getSheetAt(0);
  temp = new String[sizeX][sizeY];
  for (int i=0; i<sizeX; ++i) {
    for (int j=0; j<sizeY; ++j) {
      Row row = sheet.getRow(i);
      try {
        Cell cell = row.getCell(j);
        if (cell.getCellType()==0 || cell.getCellType()==2 || cell.getCellType()==3)cell.setCellType(1);
        temp[i][j] = cell.getStringCellValue();
      }
      catch(Exception e) {
      }
    }
  }
  println("Excel file imported: " + filepath + " successfully!");
  return temp;
}