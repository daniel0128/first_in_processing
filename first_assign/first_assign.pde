//import g4p_controls.*;
String[] headers;
float[][] values;
String[] names;
int rowCount;
int columnCount;
float matrixL;
float matrixH;
float blankX;
float blankY;
float canvasL = width*.95;
float canvasH = height*.9;
float[][] limits;
//GCustomSlider[] sldrs;

void setup(){
  size(768,768);
  //load table
  selectInput("Select a file to process:", "fileSelected");
  //createGUI();
}
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    Table table = loadTable(selection.getAbsolutePath());
    println(table.getRowCount() + " total rows in table");
    rowCount = table.getRowCount()-1;
    columnCount = table.getColumnCount()-1;
    headers = new String[columnCount+1];
    for(int i=0;i<=columnCount;i++){
      headers[i] = table.getString(0,i);
    }
    names = new String[rowCount];
    values = new float[columnCount][rowCount];
    for(int i=0;i<columnCount;i++){
      for(int j=0; j<rowCount;j++){
        values[i][j] = table.getFloat(j+1,i+1);
        names[j] = table.getString(j+1,0);
      }
    }
    limits = new float[columnCount][2];
    for(int i=0;i<limits.length;i++){
      limits[i] = getMaxAndMin(values[i]);
    }
    //sldrs = new GCustomSlider[columnCount];
  canvasL = width*.95;
  canvasH = height*.9;
  matrixL = canvasL/columnCount *.95;
  matrixH = canvasH/columnCount *.95;
  blankX = canvasL/columnCount *.04;
  blankY = canvasH/columnCount *.04;
  }
}
void draw(){
  stroke(0);
  background(255);
  //boolean markX,markY;
  //scatter matrix:
  for(int i=0;i<columnCount;i++){
   for (int j=0;j<columnCount;j++){
      if(i==columnCount-1){// markX
       for(int k = 0;k<5;k++){
         stroke(0);
         line((float)k/5*matrixL+blankX+j*(blankX+matrixL),canvasH-blankY+3,(float)k/5*matrixL+blankX+j*(blankX+matrixL),canvasH-blankY+5);
         fill(0);
         textSize(10);
         float num =((float)k/5*(float)Math.ceil(limits[i][0]-limits[i][1])+limits[i][1]);
         text( num,(float)k/5*matrixL+blankX+j*(blankX+matrixL)-3,canvasH-blankY+15);
       }
     }
     if(j==columnCount-1){
       for(int k = 0;k<5;k++){
         stroke(0);
         line(canvasL-blankX+3,(float)(k+1)/5*matrixH+blankY+i*(blankY+matrixH),canvasL-blankX+5,(float)(k+1)/5*matrixH+blankY+i*(blankY+matrixH));
         fill(0);
         textSize(10);
         int num = (int)((float)k/5*Math.ceil(limits[i][0]-limits[i][1])+limits[i][1]);
         text( num,canvasL-blankX+7,(float)(k+1)/5*matrixH+blankY+i*(blankY+matrixH));
       }
     }
     if(mouseX>blankX+j*(blankX+matrixL)&&mouseX<blankX+j*(blankX+matrixL)+matrixL &&
     mouseY > blankY+i*(blankY+matrixH)&&mouseY<blankY+i*(blankY+matrixH)+matrixH){
       fill(255,255,255);
       stroke(255,0,0);
     }else{
       stroke(0);
       fill(255,255,255,0);
     }  
     rect(blankX+j*(blankX+matrixL),blankY+i*(blankY+matrixH),matrixL,matrixH);
     if(i==j){
       if(2*rowCount<matrixL-2){
         barChart(values[i],matrixL,matrixH,blankX+j*(blankX+matrixL),(i+1)*(blankY+matrixH));
          fill(0);
       }else 
         fill(0);
       textSize(18);
       text(headers[i+1],blankX+j*(blankX+matrixL)+.2*matrixL,blankY+i*(blankY+matrixH)+.1*matrixH);
     }else {
       scatterPlot(values[j],values[i],matrixL,matrixH,blankX+j*(blankX+matrixL),(i+1)*(blankY+matrixH));
       textSize(12);
     }
   }
  }
}

void barChart(float[] data, float len, float high, float chartX, float chartY ){
  int dataNum = data.length;
  float[] max_min = getMaxAndMin(data);
  float max = max_min[0], min = max_min[1];
  int threshold =(int)(Math.ceil(max-min)); 
  float distance = (float)(len/dataNum);
  
  line(chartX,chartY,chartX,chartY-high);
  line(chartX,chartY,chartX+len,chartY);
  for(int i=0;i<dataNum;i++){
    if(mouseX>1+i*distance+chartX&&mouseX<1+i*distance+chartX+distance-1 && mouseY<chartY && mouseY>chartY-(data[i]-min+1)/threshold*high){
      fill(0);
      textSize(12);
      text(data[i],1+i*distance+chartX-2,chartY-(data[i]-min)/threshold*high-2);
      fill(0,255,0);
    }else{
      fill(0,0,255);
    }
    stroke(0);
    rect(1+i*distance+chartX,chartY,distance-1,-(data[i]-min)/threshold*high);
  }
}

void scatterPlot(float[] columnX, float[] columnY,float len,float high, float chartX, float chartY){
  int dataNum = columnX.length;
  float[] max_minX = getMaxAndMin(columnX);
  float[] max_minY = getMaxAndMin(columnY);
  float maxX = max_minX[0], minX = max_minX[1];
  float maxY = max_minY[0], minY = max_minY[1];
  int thresholdX =(int)(Math.ceil((maxX-minX))); 
  int thresholdY =(int)Math.ceil((maxY-minY)); 
  int r;
  line(chartX,chartY,chartX,chartY-high);
  line(chartX,chartY,chartX+len,chartY);
  for(int i=0;i<dataNum;i++){
    if(mouseX>chartX+(columnX[i]-minX)*len/thresholdX-2 && mouseX<chartX+(columnX[i]-minX)*len/thresholdX+2 && mouseY>chartY-(columnY[i]-minY)*high/thresholdY-2 && mouseY<chartY-(columnY[i]-minY)*high/thresholdY+2){
      fill(0);
      textSize(12);
      text("("+columnX[i]+","+columnY[i]+")",mouseX-4,mouseY-4);
      stroke(0);
      fill(0,255,0);
      r= 10;
    }else{
      stroke(0,0,255);
      fill(0,0,255);
      r=4;
    }
    ellipse( chartX+(columnX[i]-minX)*len/thresholdX,chartY-(columnY[i]-minY)*high/thresholdY,r,r);
  }
}
float[] getMaxAndMin(float[] data){
 float[] result = new float[2];
 result[0] = result[1] = data[0];
 for(int i=1;i<data.length;i++){
   if(data[i]>result[0]){
     result[0] = data[i];
   }
   if(data[i]<result[1]){
     result[1] = data[i];
   }
 }
 return result;
}
//void handleSliderEvents(GSlider slider) {
//  println("integer value:" + slider.getValueI() + " float value:" + slider.getValueF());
//}