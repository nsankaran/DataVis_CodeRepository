

// Step 1: read excel file: get array of data type and value for each cell
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
  xlsData = new String[sizeX][sizeY];
  for (int i=0; i<sizeX; ++i) {
    for (int j=0; j<sizeY; ++j) {
      Row row = sheet.getRow(j);
      try {
        Cell cell = row.getCell(i);
        dataType[i][j] = cell.getCellType();
        if (cell.getCellType()==0 || cell.getCellType()==2 || cell.getCellType()==3)cell.setCellType(1);
        xlsData[i][j] = cell.getStringCellValue();
      }
      catch(Exception e) {
      }
    }
  }
  println();
  println("Excel file imported: " + filepath + " successfully!");

  //// Step 2: look for header (field names) in first row
  //int H1 = 0;
  //for (int j=0; j<sizeX; j++) {
  //  if (dataType[j][0] == 1) {
  //    H1 = H1+1;
  //  } else {
  //  }
  //}
  //if ((H1/sizeX) >=0.5) {
  //  hdrFlag = 1;
  //  println();
  //  println("Found Headers in row 1");
  //} else { 
  //  hdrFlag = 0;
  //}

  //// Step 3: look for labels in first column
  //int L1 = 0;
  //for (int l = 0; l<sizeY; l++) {
  //  if (dataType[0][l] == 1) {
  //    L1 = L1+1;
  //  } else {
  //  }
  //}
  //if ((L1/sizeY) >= 0.5) {
  //  lblFlag = 1;
  //  println();
  //  println("Found data labels in column 1");
  //} else {
  //  lblFlag = 0;
  //}


  // Step 2: look for common data type in each column
  if (lblFlag == 1) {
    colType = new int[sizeX];
  } else {
    colType = new int[sizeX];
  }
  for (int i=0; i<sizeX; i++) {
    int[] Ccount = new int[sizeX];
    for (int j=0; j<sizeY; j++) {
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

  // If first column contains string, then labels:
  if (colType[0] == 1) {
    lblFlag = 1;
    println();
    println("Found data labels in column 1");
  } else {
    lblFlag = 0;
    println();
    println("No data labels found");
  }


  // Step 3: Look for common data type in remaining rows:
  if (hdrFlag == 1) {
    rowType = new int[sizeY];
  } else {
    rowType = new int[sizeY];
  }
  for (int i=0; i<sizeY; i++) {
    int[] Rcount = new int[sizeY];
    for (int j=0; j<sizeX; j++) {
      if (dataType[j][i] == 0) {
        Rcount[0] = Rcount[0]+1;
      } else if (dataType[j][i] == 1) {        
        Rcount[1] = Rcount[1]+1;
      } else if (dataType[j][i] == 2) {        
        Rcount[2] = Rcount[2]+1;
      } else if (dataType[j][i] == 3) {       
        Rcount[3] = Rcount[3]+1;
      }
    } // loop through columns

    int largest = Rcount[0], index = 0;
    for (int k=1; k<Rcount.length; k++) {
      if (Rcount[k] > largest) {
        largest = Rcount[k];
        index = k;
      }
    }
    rowType[i] = index;
  } // loop through rows

  // If first row contains string, then headers:
  if (rowType[0] == 1) {
    hdrFlag = 1;
    println();
    println("Found Headers in column 1");
  } else {
    hdrFlag = 0;
    println();
    println("No Headers found");
  }
  
} // end function readExcel


//String[][] importExcel(String filepath) {
//  String[][] temp;
//  //for (int i=0; i<sizeX; ++i) {
//  //  Row row = sheet.getRow(i);
//  //  for (int j=0; j<sizeY; ++j) {
//  //    try {
//  //      Cell cell = row.getCell(j);
//  //    }
//  //    catch(Exception e) {
//  //      if (j>sizeY) {
//  //        sizeY = j;
//  //      }
//  //    }
//  //  }
//  //}
//  Sheet sheet = wb.getSheetAt(0);
//  temp = new String[sizeX][sizeY];
//  for (int i=0; i<sizeX; ++i) {
//    for (int j=0; j<sizeY; ++j) {
//      Row row = sheet.getRow(j);
//      try {
//        Cell cell = row.getCell(i);
//        if (cell.getCellType()==0 || cell.getCellType()==2 || cell.getCellType()==3)cell.setCellType(1);
//        temp[i][j] = cell.getStringCellValue();
//      }
//      catch(Exception e) {
//      }
//    }
//  }
//  println("Excel file imported: " + filepath + " successfully!");
//  return temp;
//}