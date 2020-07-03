* Encoding: UTF-8.
/************************************************************************************
*************************************************************************************
******************************Erstellung Splittingtabelle ESt***********************
*************************************************************************************.

/********************************Einlesen der SPSS Datei***********************.

GET
  FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation ESt\cf_est01.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

/**************************************************************************************
*********************Erstellen Datei Splittingtabelle*********************************
**************************************************************************************
 
DATASET ACTIVATE DataSet1.
DATASET COPY  est_splittingtabelle.
DATASET ACTIVATE  est_splittingtabelle.
FILTER OFF.
USE ALL.
SELECT IF (tabelle=2).
EXECUTE.
DATASET ACTIVATE  DataSet1.

SAVE OUTFILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation ESt\est_splittingtabelle.sav'
  /COMPRESSED.
