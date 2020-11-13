* Encoding: UTF-8.
*******************************************************************************
*******************************************************************************
    ********Projekt Mikrosimulation von Einkommensteuerreformen********
    *******************************************************************************
    *******************************************************************************

/*******************************Daten einlesen*******************************

GET
    FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation_ESt\Gesamttabelle\Berufe & Gewerbe\est_sim_fdp_gesundheit.sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

/*Fortschreibung der monetären Größen bis 2020 aufgrund des Inflationsindex des Statistischen Bundesamts*.

COMPUTE sde=c65309.
COMPUTE zve=c65522.
COMPUTE zve_neu=zve * 1.07029.
COMPUTE sde_neu=sde * 1.07029.
COMPUTE zve_neu=TRUNC(zve_neu).

/***********************************************************************************
/*****************************Deskriptive Analyse*******************************
/***********************************************************************************

/***************************Anteil der Einkommensteuer am Bruttoeinkommen************************

WEIGHT OFF.
WEIGHT BY SamplingWeight.
    
FREQUENCIES VARIABLES=sde_neu
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

DO IF (sde_neu GE 0 AND sde_neu LE 26199).
    COMPUTE p=1.  
ELSE IF (sde_neu GE 26200 AND sde_neu LE 45339).
     COMPUTE p=2.
ELSE IF (sde_neu GE 45340 AND sde_neu LE 64187).
     COMPUTE p=3.
ELSE IF (sde_neu GE 64188 AND sde_neu LE 86786).
    COMPUTE p=4.
ELSE IF (sde_neu GE 86787 AND sde_neu LE 115071).
   COMPUTE p=5.
ELSE IF (sde_neu GE 115072 AND sde_neu LE 148273).
   COMPUTE p=6.
ELSE IF (sde_neu GE 148274 AND sde_neu LE 188914).
    COMPUTE p=7.
ELSE IF (sde_neu GE 188915 AND sde_neu LE 243664).
    COMPUTE p=8.
ELSE IF (sde_neu GE 243665 AND sde_neu LE 341070).
    COMPUTE p=9.
ELSE IF (sde_neu GE 341071).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_sde_neu = SUM(sde_neu).
    
AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s = p_st20_s / p_sde_neu.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_sde_neu = SUM(sde_neu).

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_st20_s = SUM(st20_s).

COMPUTE q_st20_s = g_st20_s / g_sde_neu.

***************************Analyse 10%-Einkommensperzentile****************

/***************************Sekundäre Einkommensverteilung*******************

WEIGHT OFF.
WEIGHT BY SamplingWeight.

COMPUTE einkommen_sek = zve_neu - st20_s.
    
FREQUENCIES VARIABLES=einkommen_sek
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_einkommen_sek = SUM(einkommen_sek).

DO IF (einkommen_sek GE 0 AND einkommen_sek LE 1887).
    COMPUTE p=1.  
ELSE IF (einkommen_sek GE 1888 AND einkommen_sek LE 5675).
     COMPUTE p=2.
ELSE IF (einkommen_sek GE 5676 AND einkommen_sek LE 9503).
    COMPUTE p=3.
ELSE IF (einkommen_sek GE 9504 AND einkommen_sek LE 12775).
   COMPUTE p=4.
ELSE IF (einkommen_sek GE 12776 AND einkommen_sek LE 16440).
   COMPUTE p=5.
ELSE IF (einkommen_sek GE 16441 AND einkommen_sek LE 20138).
    COMPUTE p=6.
ELSE IF (einkommen_sek GE 20139 AND einkommen_sek LE 24190).
    COMPUTE p=7.
ELSE IF (einkommen_sek GE 24191 AND einkommen_sek LE 28574).
    COMPUTE p=8.
ELSE IF (einkommen_sek GE 28575 AND einkommen_sek LE 36894).
    COMPUTE p=9.
ELSE IF (einkommen_sek GE 36895).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_einkommen_sek = SUM(einkommen_sek).

COMPUTE q_einkommen_sek=p_einkommen_sek  /  g_einkommen_sek.
EXE.

/***************************Verteilung Steuerlast************************

WEIGHT OFF.
WEIGHT BY SamplingWeight.
    
FREQUENCIES VARIABLES=zve_neu
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_st20_s = SUM(st20_s).

DO IF (zve_neu GE 0 AND zve_neu LE 1887).
    COMPUTE p=1.  
ELSE IF (zve_neu GE 1888 AND zve_neu LE 5675).
     COMPUTE p=2.
ELSE IF (zve_neu GE 5676 AND zve_neu LE 9518).
    COMPUTE p=3.
ELSE IF (zve_neu GE 9519 AND zve_neu LE 13480).
   COMPUTE p=4.
ELSE IF (zve_neu GE 13481 AND zve_neu LE 18267).
   COMPUTE p=5.
ELSE IF (zve_neu GE 18268 AND zve_neu LE 23212).
    COMPUTE p=6.
ELSE IF (zve_neu GE 23213 AND zve_neu LE 28725).
    COMPUTE p=7.
ELSE IF (zve_neu GE 28726 AND zve_neu LE 34806).
    COMPUTE p=8.
ELSE IF (zve_neu GE 34807 AND zve_neu LE 46704).
    COMPUTE p=9.
ELSE IF (zve_neu GE 46705).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s=p_st20_s / g_st20_s.

FORMATS p(f1.0).
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=p q_st20_s MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /COLORCYCLE COLOR1(85,150,230), COLOR2(215,0,51), COLOR3(41,134,38), COLOR4(243,103,42), 
    COLOR5(227,215,16), COLOR6(0,180,160), COLOR7(255,196,226), COLOR8(171,73,243), COLOR9(95,195,56), 
    COLOR10(63,90,168)
  /FRAME OUTER=NO INNER=NO
  /GRIDLINES XAXIS=NO YAXIS=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: p=col(source(s), name("p"), unit.category())
  DATA: q_st20_s=col(source(s), name("q_st20_s"))
  GUIDE: axis(dim(1), label("Einkommensperzentile"))
  GUIDE: axis(dim(2), label("Anteil am Steueraufkommen (in %)"))
  GUIDE: text.title(label("Anteil von Einkommensgruppen an der gesamten Einkommensteuer"))
  GUIDE: text.subtitle(label("(Reformvorschlag FDP, Stand: 2020)"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(p*q_st20_s), shape.interior(shape.square))
END GPL.

/***************************Analyse Einkommensmillionäre************************

/***************************Verteilung Steuerlast************************************

WEIGHT OFF.
WEIGHT BY SamplingWeight.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=
    /g_st20_s = SUM(st20_s).

COMPUTE filter=(zve_neu GE 1000000).
VALUE LABELS filter 0 'Restliche Einkommensgruppen' 1 'Einkommensmillionäre'.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=filter
    /p_st20_s = SUM(st20_s).

COMPUTE anteil=p_st20_s / g_st20_s.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=filter anteil MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: filter=col(source(s), name("filter"), unit.category())
  DATA: anteil=col(source(s), name("anteil"))
  GUIDE: axis(dim(1), label("Einkommensgruppe"))
  GUIDE: axis(dim(2), label("Anteil am Einkommensteueraufkommen (in %)"))
  GUIDE: text.title(label("Anteil der Einkommensmillionäre an der gesamten Einkommensteuer"))
  GUIDE: text.subtitle(label("(Reformvorschlag FDP, Stand: 2020)"))
  SCALE: cat(dim(1), include("1.00", "0.00"), sort.values("1.00", "0.00"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(filter*anteil), shape.interior(shape.square))
END GPL.
EXE.