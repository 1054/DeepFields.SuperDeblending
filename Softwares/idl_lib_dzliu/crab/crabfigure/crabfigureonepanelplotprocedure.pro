; 
; PlotData is a structure, providing full information for the figure. 
; 
; Usage:
;         PlotData = OBJ_NEW('CrabFigureDataStructure')
;         PlotData->setParameters, Title=Title, XTitle=XTitle, YTitle=YTitle, CTitle=ColorBarTitle, RTitle=RightSideYTitle, $ 
;                                               XUnits=XUnits, YUnits=YUnits, $
;                                               XStyle=XStyle, YStyle=YStyle, $
;                                               XTicks=XTicks, YTicks=YTicks, $
;                                               XMinor=XMinor, YMinor=YMinor, $
;                                               XIntev=XIntev, YIntev=YIntev, $
;                                               XRange=XRange, YRange=YRange, CRange=ColorBarRange, $
;                                               XLog=XLog, YLog=YLog, Note=AnyTextYouWantToAdd
;         PlotData->addDataPoint, XValue=XValue, XError=XError, $
;                                 YValue=YValue, YError=YError, $
;                                 SymSize=1.0,   SymType='Circle', $
;                                 PtThick=1.0,   PtColor=PtColor, $
;                                 PtLabel=PtLabel, PtNote=AnyTextYouWantToAdd, $
;                                 AddVar1=SomeValueYouMightWantToStore1, AddVar2=SomeValueYouMightWantToStore2
;         CrabFigureOnePanelPlotProcedure, PlotData
; 
PRO CrabFigureOnePanelPlotProcedure,      PlotData,                                       $ 
                                                           ShowLabel = ShowLabel,         $ 
                                                      ShowLinFitLine = ShowLinFitLine,    $ 
                                                      LinFitLineData = LinFitLineData,    $ 
                                                          SetVerbose = SetVerbose,        $ 
                                                            SaveFile = SaveFile,          $
                                                               Debug = Debug
    
    ; debug
    Debug = 1
    IF KEYWORD_SET(Debug) THEN BEGIN
        PlotData = OBJ_NEW('CrabFigureDataStructure')
        PlotData->setParameters, TitleText='TEST PLOTTING', XTitleText='X', YTitleText='Y', CTitleText='COLOR', ColBarFormatSTR='(I0)'
        PlotData->addDataPoint,  XValue=[5,10,15], YValue=[3,27,108], PtColor=[200,150,100]
    ENDIF
    
    
    ; linear regression line
    IF LinFitLineData NE !NULL THEN BEGIN
        fLineCount = LinFitLineData->getLineCount()
        OneLineData = LinFitLineData->getLine(0)
        PlotData->addPolyline, XArray=OneLineData.XArray, YArray=OneLineData.YArray, Color=cgColor('Charcoal'), Style=0, Thick=1.6, Note=''
        
        PlotData->addAnnotation, Position=[0.80,0.10], Normal=1, CharSize=0.7, CharThick=1.5, Color=cgColor('Charcoal'), $
                                 Text='N='+PrintValueWithError(OneLineData.Slope)
        PlotData->addAnnotation, Position=[0.80,0.15], Normal=1, CharSize=0.7, CharThick=1.5, Color=cgColor('Charcoal'), $
                                 Text='A='+PrintValueWithError(OneLineData.Intercept,/EXP)
    ENDIF                        
    
    
    
    
    PlotData->doPlot
    RETURN
    
    
    
    ; image border
;   PLOTS, [0,0,1,1,0], [0,1,1,0,0], /NORMAL, THICK=3, LINESTYLE=0 ; <TODO> image border
    
    
END