* Encoding: UTF-8.
*******************************************************************************
*******************************************************************************
********Projekt Mikrosimulation von Einkommensteuerreformen********
********************************************************************************
********************************************************************************

/*******************************Daten einlesen******************************

GET
  FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation_ESt\Grundtabelle\est_grundtabelle.sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

WEIGHT OFF.
WEIGHT BY SamplingWeight.

/*Fortschreibung der monetären Größen bis 2020*

COMPUTE sde=c65309.
COMPUTE zve=c65522.
COMPUTE zve_neu=zve * 1.07029.
COMPUTE sde_neu=sde * 1.07029.
COMPUTE zve_neu=TRUNC(zve_neu).

/***************Berechnung Einkommensteuertarif 2020 (Status Quo)*********************************.

COMPUTE y=(TRUNC(zve_neu) - 9408) / 10000.
COMPUTE z=(TRUNC(zve_neu) - 14532) / 10000.
COMPUTE x=TRUNC(zve_neu).

DO IF (zve_neu LE 9408).
    COMPUTE st20=0.
ELSE IF (zve_neu GE 9169 AND zve_neu LE 14532).
    COMPUTE st20=(972.87 * y + 1400) * y.
    COMPUTE st20=TRUNC(st20).
ELSE IF (zve_neu GE 14533 AND zve_neu LE 57051).
    COMPUTE st20=(212.02 * z + 2397) * z + 972.79.
    COMPUTE st20=TRUNC(st20).
ELSE IF (zve_neu GE 57052 AND zve_neu LE 270500).
    COMPUTE st20=0.42 * x - 8963.74.
    COMPUTE st20=TRUNC(st20).
ELSE IF (zve_neu GE 270501).
    COMPUTE st20=0.45 * x - 17078.74.
    COMPUTE st20=TRUNC(st20).
END IF.

**************Simulation Abschaffung Solidaritätszuschlag ab 2021*********************************.

DO IF (st20 LE 16956).
 COMPUTE soli=0.
 COMPUTE st20=st20 + soli.
ELSE IF (st20 GE 16957 AND st20 LE 31528).
 COMPUTE soli=(st20 - 16957) * 0.119.
 COMPUTE st20=st20 + soli.
ELSE IF (st20 GE 31529).
 COMPUTE soli=st20 * 0.055.
 COMPUTE st20=st20 + soli.
END IF. 

COMPUTE st20_s=st20 - soli.
EXECUTE.
