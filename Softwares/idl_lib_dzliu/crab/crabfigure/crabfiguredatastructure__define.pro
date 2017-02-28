;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; CrabFigureDataStructure is a structure containing full information for plotting a figure.  
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Usage:
;        
; 
; 
; 
; 
; 
; 
FUNCTION CrabFigureDataStructure::INIT
    SELF.DataPoints  = PTR_NEW(/ALLOCATE)
    SELF.Annotations = PTR_NEW(/ALLOCATE)
    SELF.Polylines   = PTR_NEW(/ALLOCATE)
    SELF.XTicksTextArray = PTR_NEW(/ALLOCATE)
    SELF.YTicksTextArray = PTR_NEW(/ALLOCATE)
    SELF.XTicksValueArray = PTR_NEW(/ALLOCATE)
    SELF.YTicksValueArray = PTR_NEW(/ALLOCATE)
    SELF.RTicksTextArray = PTR_NEW(/ALLOCATE)
    ;; 
    SELF.TitleCharThick = 1.0
    SELF.TitleCharSizeF = 1.0
    SELF.TitlePositionR = [0.5,0.9]
    ;;
    SELF.XTitleCharThick = 1.0
    SELF.XTitleCharSizeF = 1.0 ; default TitleCharSize <TODO>
    SELF.XTitleAlignment = 0.5
    ;;
    SELF.YTitleCharThick = 1.0
    SELF.YTitleCharSizeF = 1.0
    SELF.YTitleAlignment = 0.5
    ;;
    SELF.RTitleCharThick = 1.0
    SELF.RTitleCharSizeF = 1.0
    SELF.RTitleAlignment = 0.5
    ;;
    SELF.CTitleCharThick = 1.0
    SELF.CTitleCharSizeF = 1.0
    SELF.ColBarCharThick = 1.0
    SELF.ColBarCharSizeF = 1.0
    SELF.ColorBarPosRect = [0.872,0.305,0.91,0.65] ; x1,y1,x2,y2
    SELF.CTitlePositionR = [(SELF.ColorBarPosRect[0]+SELF.ColorBarPosRect[2])/2.0+0.02,$
                        MAX([SELF.ColorBarPosRect[1],SELF.ColorBarPosRect[3]])+0.03]
    SELF.ColBarFormatSTR = '(F0.2)'
    ;;
    SELF.LegendCharThick = 1.0
    SELF.LegendCharSizeF = 1.0
    SELF.LegendPositionR = [0.225,0.775]
    ;;
    SELF.XTicksCharThick = 1.0
    SELF.XTicksCharSizeF = 1.0 ; default TicksCharSize <TODO>
    SELF.XTicksAlignment = 0.5
    SELF.XTicksRotationF = 0.0
    SELF.XTicksFormatSTR = ''
    ;;
    SELF.YTicksCharThick = 1.0
    SELF.YTicksCharSizeF = 1.0 ; default TicksCharSize <TODO>
    SELF.YTicksAlignment = 0.5
    SELF.YTicksRotationF = 0.0
    SELF.YTicksFormatSTR = ''
    ;;
    SELF.RTicksCharThick = 1.0
    SELF.RTicksCharSizeF = 1.0
    SELF.RTicksAlignment = 0.5
    SELF.RTicksRotationF = 0.0
    SELF.RTicksFormatSTR = ''
    ;;
    SELF.XTkLen = 0.02
    SELF.XThick = 1.0
    ;; 
    SELF.YTkLen = 0.02
    SELF.YThick = 1.0
    ;;
    SELF.RStyle = 8+1
    ;;
    IF STRMATCH(!VERSION.OS_FAMILY,'*Windows*',/FOLD_CASE) THEN SELF.DefaultDevice='WIN'
    IF STRMATCH(!VERSION.OS_FAMILY,'*unix*',/FOLD_CASE) THEN SELF.DefaultDevice='X'
    ;;
    RETURN, 1
END



PRO CrabFigureDataStructure::setParameters,     Verbose =  Verbose,        $ 
                                              TitleText =  TitleText,      $ 
                                         TitleCharThick =  TitleCharThick, $ 
                                         TitleCharSizeF =  TitleCharSizeF, $ 
                                         TitlePositionR =  TitlePositionR, $ 
                                             XTitleText = XTitleText,      $ 
                                        XTitleCharThick = XTitleCharThick, $ 
                                        XTitleCharSizeF = XTitleCharSizeF, $ 
                                        XTitleAlignment = XTitleAlignment, $ ; the position of x title
                                             YTitleText = YTitleText,      $ 
                                        YTitleCharThick = YTitleCharThick, $ 
                                        YTitleCharSizeF = YTitleCharSizeF, $ 
                                        YTitleAlignment = YTitleAlignment, $ ; the position of y title
                                             CTitleText = CTitleText,      $ ; Colorbar Title
                                        CTitleCharThick = CTitleCharThick, $ ; Colorbar Title char thick
                                        CTitleCharSizeF = CTitleCharSizeF, $ ; Colorbar Title char size
                                        ColBarCharThick = ColBarCharThick, $ ; Colorbar char thick
                                        ColBarCharSizeF = ColBarCharSizeF, $ ; Colorbar char size
                                        CTitlePositionR = CTitlePositionR, $ ; Colorbar Title position
                                        ColorBarPosRect = ColorBarPosRect, $ ; Colorbar Position
                                        ColBarFormatSTR = ColBarFormatSTR, $ ; Colorbar text format
                                        LegendCharThick = LegendCharThick, $ ; Legend char thick
                                        LegendCharSizeF = LegendCharSizeF, $ ; Legend char size
                                        LegendPositionR = LegendPositionR, $ ; Legend starting position
                                             RTitleText = RTitleText,      $ ; Right Y2 Title
                                                 XUnits = XUnits,          $
                                                 YUnits = YUnits,          $
                                                 XStyle = XStyle,          $
                                                 YStyle = YStyle,          $
                                                 RStyle = RStyle,          $
                                            XTickFormat = XTickFormat,     $
                                            YTickFormat = YTickFormat,     $
                                        XTicksTextArray = XTicksTextArray, $ ; text array for tick label
                                       XTicksValueArray = XTicksValueArray,$ ; value array for tick label
                                        XTicksCharThick = XTicksCharThick, $
                                        XTicksCharSizeF = XTicksCharSizeF, $
                                        XTicksAlignment = XTicksAlignment, $
                                        XTicksRotationF = XTicksRotationF, $
                                        XTicksFormatSTR = XTicksFormatSTR, $
                                        YTicksTextArray = YTicksTextArray, $ ; text array for tick label
                                       YTicksValueArray = YTicksValueArray,$ ; value array for tick label
                                        YTicksCharThick = YTicksCharThick, $
                                        YTicksCharSizeF = YTicksCharSizeF, $
                                        YTicksAlignment = YTicksAlignment, $
                                        YTicksRotationF = YTicksRotationF, $
                                        YTicksFormatSTR = YTicksFormatSTR, $
                                        RTicksTextArray = RTicksTextArray, $ ; text array for right Y tick label
                                        RTicksCharThick = RTicksCharThick, $
                                        RTicksCharSizeF = RTicksCharSizeF, $
                                        RTicksAlignment = RTicksAlignment, $
                                        RTicksRotationF = RTicksRotationF, $
                                        RTicksFormatSTR = RTicksFormatSTR, $
                                                 XMinor = XMinor,    $ ; number of minor tick
                                                 YMinor = YMinor,    $ ; number of minor tick
                                                 XMajor = XMajor,    $ ; number of Major tick INTEVALS
                                                 YMajor = YMajor,    $ ; number of Major tick INTEVALS
                                                 XIntev = XIntev,    $
                                                 YIntev = YIntev,    $
                                                 XTkLen = XTkLen,    $ ; x axis small tick line length
                                                 YTkLen = YTkLen,    $ ; y axis small tick line length
                                                 XThick = XThick,    $ ; x axis line thickness
                                                 YThick = YThick,    $ ; y axis line thickness
                                                 XRange = XRange,    $
                                                 YRange = YRange,    $
                                                 RRange = RRange,    $
                                                 CRange = CRange,    $
                                                   XLog = XLog,      $
                                                   YLog = YLog,      $
                                                   RLog = RLog,      $
                                                   CLog = CLog,      $
                                                   Note = Note,      $
                                                Version = Version,   $
                                                  Debug = Debug      
                       SELF->setParameter,      Verbose =  Verbose,        $ 
                                              TitleText =  TitleText,      $ 
                                         TitleCharThick =  TitleCharThick, $ 
                                         TitleCharSizeF =  TitleCharSizeF, $ 
                                         TitlePositionR =  TitlePositionR, $ 
                                             XTitleText = XTitleText,      $ 
                                        XTitleCharThick = XTitleCharThick, $ 
                                        XTitleCharSizeF = XTitleCharSizeF, $ 
                                        XTitleAlignment = XTitleAlignment, $ ; the position of x title
                                             YTitleText = YTitleText,      $ 
                                        YTitleCharThick = YTitleCharThick, $ 
                                        YTitleCharSizeF = YTitleCharSizeF, $ 
                                        YTitleAlignment = YTitleAlignment, $ ; the position of y title
                                             CTitleText = CTitleText,      $ ; Colorbar Title
                                        CTitleCharThick = CTitleCharThick, $ ; Colorbar Title char thick
                                        CTitleCharSizeF = CTitleCharSizeF, $ ; Colorbar Title char size
                                        ColBarCharThick = ColBarCharThick, $ ; Colorbar char thick
                                        ColBarCharSizeF = ColBarCharSizeF, $ ; Colorbar char size
                                        CTitlePositionR = CTitlePositionR, $ ; Colorbar Title position
                                        ColorBarPosRect = ColorBarPosRect, $ ; Colorbar Position
                                        ColBarFormatSTR = ColBarFormatSTR, $ ; Colorbar text format
                                        LegendCharThick = LegendCharThick, $ ; Legend char thick
                                        LegendCharSizeF = LegendCharSizeF, $ ; Legend char size
                                        LegendPositionR = LegendPositionR, $ ; Legend starting position
                                             RTitleText = RTitleText,      $ ; Right Y2 Title
                                                 XUnits = XUnits,          $
                                                 YUnits = YUnits,          $
                                                 XStyle = XStyle,          $
                                                 YStyle = YStyle,          $
                                                 RStyle = RStyle,          $
                                            XTickFormat = XTickFormat,     $
                                            YTickFormat = YTickFormat,     $
                                        XTicksTextArray = XTicksTextArray, $ ; text array for tick label
                                       XTicksValueArray = XTicksValueArray,$ ; value array for tick label
                                        XTicksCharThick = XTicksCharThick, $
                                        XTicksCharSizeF = XTicksCharSizeF, $
                                        XTicksAlignment = XTicksAlignment, $
                                        XTicksRotationF = XTicksRotationF, $
                                        XTicksFormatSTR = XTicksFormatSTR, $
                                        YTicksTextArray = YTicksTextArray, $ ; text array for tick label
                                       YTicksValueArray = YTicksValueArray,$ ; value array for tick label
                                        YTicksCharThick = YTicksCharThick, $
                                        YTicksCharSizeF = YTicksCharSizeF, $
                                        YTicksAlignment = YTicksAlignment, $
                                        YTicksRotationF = YTicksRotationF, $
                                        YTicksFormatSTR = YTicksFormatSTR, $
                                        RTicksTextArray = RTicksTextArray, $ ; text array for right Y tick label
                                        RTicksCharThick = RTicksCharThick, $
                                        RTicksCharSizeF = RTicksCharSizeF, $
                                        RTicksAlignment = RTicksAlignment, $
                                        RTicksRotationF = RTicksRotationF, $
                                        RTicksFormatSTR = RTicksFormatSTR, $
                                                 XMinor = XMinor,    $ ; number of minor tick
                                                 YMinor = YMinor,    $ ; number of minor tick
                                                 XMajor = XMajor,    $ ; number of Major tick INTEVALS
                                                 YMajor = YMajor,    $ ; number of Major tick INTEVALS
                                                 XIntev = XIntev,    $
                                                 YIntev = YIntev,    $
                                                 XTkLen = XTkLen,    $ ; x axis small tick line length
                                                 YTkLen = YTkLen,    $ ; y axis small tick line length
                                                 XThick = XThick,    $ ; x axis line thickness
                                                 YThick = YThick,    $ ; y axis line thickness
                                                 XRange = XRange,    $
                                                 YRange = YRange,    $
                                                 RRange = RRange,    $
                                                 CRange = CRange,    $
                                                   XLog = XLog,      $
                                                   YLog = YLog,      $
                                                   RLog = RLog,      $
                                                   CLog = CLog,      $
                                                   Note = Note,      $
                                                Version = Version,   $
                                                  Debug = Debug      
END



PRO CrabFigureDataStructure::setParameter,      Verbose =  Verbose,        $ 
                                              TitleText =  TitleText,      $ 
                                         TitleCharThick =  TitleCharThick, $ 
                                         TitleCharSizeF =  TitleCharSizeF, $ 
                                         TitlePositionR =  TitlePositionR, $ 
                                             XTitleText = XTitleText,      $ 
                                        XTitleCharThick = XTitleCharThick, $ 
                                        XTitleCharSizeF = XTitleCharSizeF, $ 
                                        XTitleAlignment = XTitleAlignment, $ ; the position of x title
                                             YTitleText = YTitleText,      $ 
                                        YTitleCharThick = YTitleCharThick, $ 
                                        YTitleCharSizeF = YTitleCharSizeF, $ 
                                        YTitleAlignment = YTitleAlignment, $ ; the position of y title
                                             CTitleText = CTitleText,      $ ; Colorbar Title
                                        CTitleCharThick = CTitleCharThick, $ ; Colorbar Title char thick
                                        CTitleCharSizeF = CTitleCharSizeF, $ ; Colorbar Title char size
                                        ColBarCharThick = ColBarCharThick, $ ; Colorbar char thick
                                        ColBarCharSizeF = ColBarCharSizeF, $ ; Colorbar char size
                                        CTitlePositionR = CTitlePositionR, $ ; Colorbar Title position
                                        ColorBarPosRect = ColorBarPosRect, $ ; Colorbar Position
                                        ColBarFormatSTR = ColBarFormatSTR, $ ; Colorbar text format
                                        LegendCharThick = LegendCharThick, $ ; Legend char thick
                                        LegendCharSizeF = LegendCharSizeF, $ ; Legend char size
                                        LegendPositionR = LegendPositionR, $ ; Legend starting position
                                             RTitleText = RTitleText,      $ ; Right Y2 Title
                                                 XUnits = XUnits,          $
                                                 YUnits = YUnits,          $
                                                 XStyle = XStyle,          $
                                                 YStyle = YStyle,          $
                                                 RStyle = RStyle,          $
                                               NoXTicks = NoXTicks,        $
                                               NoYTicks = NoYTicks,        $
                                            XTickFormat = XTickFormat,     $
                                            YTickFormat = YTickFormat,     $
                                        XTicksTextArray = XTicksTextArray, $ ; text array for tick label
                                       XTicksValueArray = XTicksValueArray,$ ; value array for tick label
                                        XTicksCharThick = XTicksCharThick, $
                                        XTicksCharSizeF = XTicksCharSizeF, $
                                        XTicksAlignment = XTicksAlignment, $
                                        XTicksRotationF = XTicksRotationF, $
                                        XTicksFormatSTR = XTicksFormatSTR, $
                                        YTicksTextArray = YTicksTextArray, $ ; text array for tick label
                                       YTicksValueArray = YTicksValueArray,$ ; value array for tick label
                                        YTicksCharThick = YTicksCharThick, $
                                        YTicksCharSizeF = YTicksCharSizeF, $
                                        YTicksAlignment = YTicksAlignment, $
                                        YTicksRotationF = YTicksRotationF, $
                                        YTicksFormatSTR = YTicksFormatSTR, $
                                        RTicksTextArray = RTicksTextArray, $ ; text array for right Y tick label
                                        RTicksCharThick = RTicksCharThick, $
                                        RTicksCharSizeF = RTicksCharSizeF, $
                                        RTicksAlignment = RTicksAlignment, $
                                        RTicksRotationF = RTicksRotationF, $
                                        RTicksFormatSTR = RTicksFormatSTR, $
                                                 XMinor = XMinor,    $ ; number of minor tick
                                                 YMinor = YMinor,    $ ; number of minor tick
                                                 XMajor = XMajor,    $ ; number of Major tick INTEVALS
                                                 YMajor = YMajor,    $ ; number of Major tick INTEVALS
                                                 XIntev = XIntev,    $
                                                 YIntev = YIntev,    $
                                                 XTkLen = XTkLen,    $ ; x axis small tick line length
                                                 YTkLen = YTkLen,    $ ; y axis small tick line length
                                                 XThick = XThick,    $ ; x axis line thickness
                                                 YThick = YThick,    $ ; y axis line thickness
                                                 XRange = XRange,    $
                                                 YRange = YRange,    $
                                                 RRange = RRange,    $
                                                 CRange = CRange,    $
                                                   XLog = XLog,      $
                                                   YLog = YLog,      $
                                                   RLog = RLog,      $
                                                   CLog = CLog,      $
                                                   Note = Note,      $
                                                Version = Version,   $
                                                  Debug = Debug      
    ;;
    IF SIZE(TitleText,/TNAME)  EQ 'STRING' THEN SELF.TitleText       = STRTRIM(TitleText,2)
    IF N_ELEMENTS( TitleCharThick) EQ 1    THEN SELF.TitleCharThick  = DOUBLE(TitleCharThick)
    IF N_ELEMENTS( TitleCharSizeF) EQ 1    THEN SELF.TitleCharSizeF  = DOUBLE(TitleCharSizeF)
    IF N_ELEMENTS( TitlePositionR) GE 2    THEN SELF.TitlePositionR  = DOUBLE(TitlePositionR[0:1])
    ;; 
    IF SIZE(XTitleText,/TNAME) EQ 'STRING' THEN SELF.XTitleText      = STRTRIM(XTitleText,2)
    IF N_ELEMENTS(XTitleCharThick) EQ 1    THEN SELF.XTitleCharThick = DOUBLE(XTitleCharThick)
    IF N_ELEMENTS(XTitleCharSizeF) EQ 1    THEN SELF.XTitleCharSizeF = DOUBLE(XTitleCharSizeF)
    ;;
    IF SIZE(YTitleText,/TNAME) EQ 'STRING' THEN SELF.YTitleText      = STRTRIM(YTitleText,2)
    IF N_ELEMENTS(YTitleCharThick) EQ 1    THEN SELF.YTitleCharThick = DOUBLE(YTitleCharThick)
    IF N_ELEMENTS(YTitleCharSizeF) EQ 1    THEN SELF.YTitleCharSizeF = DOUBLE(YTitleCharSizeF)
    ;;
    IF SIZE(RTitleText,/TNAME) EQ 'STRING' THEN SELF.RTitleText      = STRTRIM(RTitleText,2)
    ;;
    IF SIZE(CTitleText,/TNAME) EQ 'STRING' THEN SELF.CTitleText      = STRTRIM(CTitleText,2)
    IF N_ELEMENTS(CTitleCharThick) EQ 1    THEN SELF.CTitleCharThick = DOUBLE(CTitleCharThick)
    IF N_ELEMENTS(CTitleCharSizeF) EQ 1    THEN SELF.CTitleCharSizeF = DOUBLE(CTitleCharSizeF)
    IF N_ELEMENTS(ColBarCharThick) EQ 1    THEN SELF.ColBarCharThick = DOUBLE(ColBarCharThick)
    IF N_ELEMENTS(ColBarCharSizeF) EQ 1    THEN SELF.ColBarCharSizeF = DOUBLE(ColBarCharSizeF)
    IF N_ELEMENTS(ColorBarPosRect) LE 1    THEN SELF.ColorBarPosRect = [0.872,0.305,0.91,0.65] ; [x1,y1,x2,y2] ; <TODO> default value
    IF N_ELEMENTS(ColorBarPosRect) EQ 2    THEN SELF.ColorBarPosRect = DOUBLE([ColorBarPosRect,ColorBarPosRect[0]+0.038,ColorBarPosRect[1]+0.345])
    IF N_ELEMENTS(ColorBarPosRect) EQ 3    THEN SELF.ColorBarPosRect = DOUBLE([ColorBarPosRect,ColorBarPosRect[0]+0.038,ColorBarPosRect[1]+0.345])
    IF N_ELEMENTS(ColorBarPosRect) GE 4    THEN SELF.ColorBarPosRect = DOUBLE(ColorBarPosRect[0:3])    
    IF N_ELEMENTS(CTitlePositionR) LT 2    THEN SELF.CTitlePositionR = [(SELF.ColorBarPosRect[0]+SELF.ColorBarPosRect[2])/2.0+0.02,$
                                                                    MAX([SELF.ColorBarPosRect[1],SELF.ColorBarPosRect[3]])+0.03]
    IF N_ELEMENTS(CTitlePositionR) GE 2    THEN SELF.CTitlePositionR = DOUBLE(CTitlePositionR[0:1])
                                                                     ; colorbar title position is caculated according to colorbar position
    IF N_ELEMENTS(ColBarFormatSTR) EQ 1    THEN SELF.ColBarFormatSTR = STRTRIM(ColBarFormatSTR,2)
    
    IF N_ELEMENTS(LegendCharThick) EQ 1    THEN SELF.LegendCharThick = DOUBLE(LegendCharThick)
    IF N_ELEMENTS(LegendCharSizeF) EQ 1    THEN SELF.LegendCharSizeF = DOUBLE(LegendCharSizeF)
    IF N_ELEMENTS(LegendPositionR) GE 2    THEN SELF.LegendPositionR = DOUBLE(LegendPositionR[0:1])
    
    ;;
    IF SIZE(XUnits,/TNAME) EQ 'STRING'  THEN SELF.XUnits = STRTRIM(XUnits,2)
    IF SIZE(YUnits,/TNAME) EQ 'STRING'  THEN SELF.YUnits = STRTRIM(YUnits,2)
    IF N_ELEMENTS(XStyle)  EQ 1         THEN SELF.XStyle = FIX(XStyle)
    IF N_ELEMENTS(YStyle)  EQ 1         THEN SELF.YStyle = FIX(YStyle)
    IF N_ELEMENTS(RStyle)  EQ 1         THEN SELF.RStyle = FIX(RStyle)
    ;;
    IF KEYWORD_SET(NoXTicks) THEN XTicksTextArray = REPLICATE(' ',50)
    IF KEYWORD_SET(NoYTicks) THEN YTicksTextArray = REPLICATE(' ',50)
    ;;
    IF N_ELEMENTS(XTickFormat) EQ 1 THEN SELF.XTicksFormatSTR = STRTRIM(XTickFormat,2)
    IF N_ELEMENTS(YTickFormat) EQ 1 THEN SELF.YTicksFormatSTR = STRTRIM(YTickFormat,2)
    ;;
    IF N_ELEMENTS(XTicksTextArray) GE 1 THEN *(SELF.XTicksTextArray) = XTicksTextArray
    IF N_ELEMENTS(XTicksValueArray) GE 1 THEN *(SELF.XTicksValueArray) = XTicksValueArray
    IF N_ELEMENTS(XTicksCharThick) EQ 1 THEN SELF.XTicksCharThick = DOUBLE(XTicksCharThick)
    IF N_ELEMENTS(XTicksCharSizeF) EQ 1 THEN SELF.XTicksCharSizeF = DOUBLE(XTicksCharSizeF)
    IF N_ELEMENTS(XTicksFormatSTR) EQ 1 THEN SELF.XTicksFormatSTR = STRTRIM(XTicksFormatSTR,2)
    ;;
    IF N_ELEMENTS(YTicksTextArray) GE 1 THEN *(SELF.YTicksTextArray) = YTicksTextArray
    IF N_ELEMENTS(YTicksValueArray) GE 1 THEN *(SELF.YTicksValueArray) = YTicksValueArray
    IF N_ELEMENTS(YTicksCharThick) EQ 1 THEN SELF.YTicksCharThick = DOUBLE(YTicksCharThick)
    IF N_ELEMENTS(YTicksCharSizeF) EQ 1 THEN SELF.YTicksCharSizeF = DOUBLE(YTicksCharSizeF)
    IF N_ELEMENTS(YTicksFormatSTR) EQ 1 THEN SELF.YTicksFormatSTR = STRTRIM(YTicksFormatSTR,2)
    ;;
    IF N_ELEMENTS(RTicksTextArray) GE 1 THEN *(SELF.RTicksTextArray) = RTicksTextArray
    IF N_ELEMENTS(RTicksCharThick) EQ 1 THEN SELF.RTicksCharThick = DOUBLE(RTicksCharThick)
    IF N_ELEMENTS(RTicksCharSizeF) EQ 1 THEN SELF.RTicksCharSizeF = DOUBLE(RTicksCharSizeF)
    IF N_ELEMENTS(RTicksFormatSTR) EQ 1 THEN SELF.RTicksFormatSTR = STRTRIM(RTicksFormatSTR,2)
    ;;
    IF N_ELEMENTS(XMinor)  EQ 1         THEN SELF.XMinor = FIX(XMinor)
    IF N_ELEMENTS(YMinor)  EQ 1         THEN SELF.YMinor = FIX(YMinor)
    IF N_ELEMENTS(XMajor)  EQ 1         THEN SELF.XMajor = FIX(XMajor)
    IF N_ELEMENTS(YMajor)  EQ 1         THEN SELF.YMajor = FIX(YMajor)
    IF N_ELEMENTS(XIntev)  EQ 1         THEN SELF.XIntev = DOUBLE(XIntev)
    IF N_ELEMENTS(YIntev)  EQ 1         THEN SELF.YIntev = DOUBLE(YIntev)
    IF N_ELEMENTS(XTkLen)  EQ 1         THEN SELF.XTkLen = XTkLen
    IF N_ELEMENTS(YTkLen)  EQ 1         THEN SELF.YTkLen = YTkLen
    IF N_ELEMENTS(XThick)  EQ 1         THEN SELF.XThick = XThick
    IF N_ELEMENTS(YThick)  EQ 1         THEN SELF.YThick = YThick
    IF N_ELEMENTS(XRange)  EQ 2         THEN SELF.XRange = XRange
    IF N_ELEMENTS(YRange)  EQ 2         THEN SELF.YRange = YRange
    IF N_ELEMENTS(RRange)  EQ 2         THEN SELF.RRange = RRange
    IF N_ELEMENTS(CRange)  EQ 2         THEN SELF.CRange = CRange
    IF N_ELEMENTS(XLog)    EQ 1         THEN SELF.XLog   = XLog
    IF N_ELEMENTS(YLog)    EQ 1         THEN SELF.YLog   = YLog
    IF N_ELEMENTS(RLog)    EQ 1         THEN SELF.RLog   = RLog
    IF N_ELEMENTS(CLog)    EQ 1         THEN SELF.CLog   = CLog
    IF N_ELEMENTS(Note)    EQ 1         THEN SELF.Note   = Note
    IF N_ELEMENTS(Version) EQ 1         THEN SELF.Version= Version
    ;;
    ; xy minor ticket number according to xlog ylog 
    ; <Corrected><20140104><DzLiu> must set N_ELEMENTS(XLog) EQ 1 
    IF N_ELEMENTS(XLog) EQ 1 AND KEYWORD_SET(XLog) EQ 0 AND N_ELEMENTS(XMinor) EQ 0 THEN SELF.XMinor = 10 ; <Corrected><20131105><DzLiu>
    IF N_ELEMENTS(XLog) EQ 1 AND KEYWORD_SET(XLog) EQ 1 AND N_ELEMENTS(XMinor) EQ 0 THEN SELF.XMinor = 9
    IF N_ELEMENTS(XLog) EQ 1 AND KEYWORD_SET(XLog) EQ 1 AND N_ELEMENTS(XIntev) EQ 0 THEN SELF.XIntev = 1.0D
    IF N_ELEMENTS(YLog) EQ 1 AND KEYWORD_SET(YLog) EQ 0 AND N_ELEMENTS(YMinor) EQ 0 THEN SELF.YMinor = 10 ; <TODO> PS and WIN have diff. here???
    IF N_ELEMENTS(YLog) EQ 1 AND KEYWORD_SET(YLog) EQ 1 AND N_ELEMENTS(YMinor) EQ 0 THEN SELF.YMinor = 9
    IF N_ELEMENTS(YLog) EQ 1 AND KEYWORD_SET(YLog) EQ 1 AND N_ELEMENTS(YIntev) EQ 0 THEN SELF.YIntev = 1.0D
    ;; 
    ; Check XRange
    XRange = SELF->checkXRange()
    ; Check YRange
    YRange = SELF->checkYRange()
    ; Check RRange
    RRange = SELF->checkRRange()
    ; Check CRange
    ; CRange = SELF->checkCRange()
    ; 
END






PRO CrabFigureDataStructure::addDataPoints,     Verbose = Verbose,     $
                                                 XValue = XValue,      $
                                                 YValue = YValue,      $
                                                 XError = XError,      $
                                                 YError = YError,      $
                                                SymSize = SymSize,     $ ; SymSize 
                                                SymType = SymType,     $ ; Symbol
                                                SymFill = SymFill,     $ ; filled or not
                                                PtThick = PtThick,     $ ; Thickness
                                                PtColor = PtColor,     $ ; Color  
                                                PtLabel = PtLabel,     $ ; Label 
                                                PtLSize = PtLSize,     $ ; Label SizeF
                                                PtLThic = PtLThic,     $ ; Label Thick
                                                PtLRota = PtLRota,     $ ; Label Rotation
                                                 PtNote = PtNote,      $ ; additional note
                                                AddVar1 = AddVar1,     $
                                                AddVar2 = AddVar2,     $
                                                AddVar3 = AddVar3,     $
                                                AddVar4 = AddVar4,     $
                                                AddVar5 = AddVar5,     $
                                                AddVar6 = AddVar6,     $
                                                  Debug = Debug
                       SELF->addDataPoint,      Verbose = Verbose,     $
                                                 XValue = XValue,      $
                                                 YValue = YValue,      $
                                                 XError = XError,      $
                                                 YError = YError,      $
                                                SymSize = SymSize,     $ ; SymSize 
                                                SymType = SymType,     $ ; Symbol
                                                SymFill = SymFill,     $ ; filled or not
                                                PtThick = PtThick,     $ ; Thickness
                                                PtColor = PtColor,     $ ; Color  
                                                PtLabel = PtLabel,     $ ; Label 
                                                PtLSize = PtLSize,     $ ; Label SizeF
                                                PtLThic = PtLThic,     $ ; Label Thick
                                                PtLRota = PtLRota,     $ ; Label Rotation
                                                 PtNote = PtNote,      $ ; additional note
                                                AddVar1 = AddVar1,     $
                                                AddVar2 = AddVar2,     $
                                                AddVar3 = AddVar3,     $
                                                AddVar4 = AddVar4,     $
                                                AddVar5 = AddVar5,     $
                                                AddVar6 = AddVar6,     $
                                                  Debug = Debug
END



PRO CrabFigureDataStructure::addDataPoint,      Verbose = Verbose,     $
                                                 XValue = XValue,      $
                                                 YValue = YValue,      $
                                                 XError = XError,      $
                                                 YError = YError,      $
                                                SymSize = SymSize,     $ ; SymSize 
                                                SymType = SymType,     $ ; Symbol
                                                SymFill = SymFill,     $ ; filled or not
                                                PtThick = PtThick,     $ ; Thickness
                                                PtColor = PtColor,     $ ; Color  
                                                PtLabel = PtLabel,     $ ; Label 
                                                PtLSize = PtLSize,     $ ; Label SizeF
                                                PtLThic = PtLThic,     $ ; Label Thick
                                                PtLRota = PtLRota,     $ ; Label Rotation
                                                 PtNote = PtNote,      $ ; additional note
                                                AddVar1 = AddVar1,     $
                                                AddVar2 = AddVar2,     $
                                                AddVar3 = AddVar3,     $
                                                AddVar4 = AddVar4,     $
                                                AddVar5 = AddVar5,     $
                                                AddVar6 = AddVar6,     $
                                                  Debug = Debug
    ;;
    IF N_ELEMENTS(XValue) GE 1 AND N_ELEMENTS(YValue) GE 1 AND N_ELEMENTS(XValue) EQ N_ELEMENTS(YValue) THEN BEGIN
        ;;
        ;  XValue and YValue can be arrays, thus multiple data points can be stored once.
        ;;
        DataPointCount = N_ELEMENTS(XValue)
        DataPointAdded = 0
        XValue = DOUBLE([XValue])
        YValue = DOUBLE([YValue])
        IF N_ELEMENTS(XError) GT 1 AND N_ELEMENTS(XError) NE DataPointCount THEN XError = !NULL
        IF N_ELEMENTS(XError) EQ 0 THEN XError = 0.D
        IF N_ELEMENTS(XError) EQ 1 THEN XError = REPLICATE(DOUBLE(XError),DataPointCount)
        IF N_ELEMENTS(YError) GT 1 AND N_ELEMENTS(YError) NE DataPointCount THEN YError = !NULL
        IF N_ELEMENTS(YError) EQ 0 THEN YError = 0.D
        IF N_ELEMENTS(YError) EQ 1 THEN YError = REPLICATE(DOUBLE(YError),DataPointCount)
        
        IF N_ELEMENTS(SymSize) EQ 0 THEN m_SymSize = REPLICATE(2.0,DataPointCount) ; default SymSize
        IF N_ELEMENTS(SymSize) EQ 1 THEN m_SymSize = REPLICATE(SymSize,DataPointCount)
        IF N_ELEMENTS(SymSize) GT 1 AND N_ELEMENTS(SymSize) NE DataPointCount THEN m_SymSize = REPLICATE(SymSize[0],DataPointCount)
        IF N_ELEMENTS(SymSize) GT 1 AND N_ELEMENTS(SymSize) EQ DataPointCount THEN m_SymSize = SymSize
        
        IF N_ELEMENTS(SymType) EQ 0 THEN m_SymType = REPLICATE('Circle',DataPointCount) ; default SymType
        IF N_ELEMENTS(SymType) EQ 1 THEN m_SymType = REPLICATE(SymType,DataPointCount)
        IF N_ELEMENTS(SymType) GT 1 AND N_ELEMENTS(SymType) NE DataPointCount THEN m_SymType = REPLICATE(SymType[0],DataPointCount)
        IF N_ELEMENTS(SymType) GT 1 AND N_ELEMENTS(SymType) EQ DataPointCount THEN m_SymType = SymType
        
        IF N_ELEMENTS(SymFill) EQ 0 THEN m_SymFill = REPLICATE(0,DataPointCount)
        IF N_ELEMENTS(SymFill) EQ 1 THEN m_SymFill = REPLICATE(SymFill,DataPointCount)
        IF N_ELEMENTS(SymFill) GT 1 AND N_ELEMENTS(SymFill) NE DataPointCount THEN m_SymFill = REPLICATE(SymFill[0],DataPointCount)
        IF N_ELEMENTS(SymFill) GT 1 AND N_ELEMENTS(SymFill) EQ DataPointCount THEN m_SymFill = SymFill
        
        IF N_ELEMENTS(PtThick) EQ 0 THEN m_PtThick = REPLICATE(1.0,DataPointCount)
        IF N_ELEMENTS(PtThick) EQ 1 THEN m_PtThick = REPLICATE(PtThick,DataPointCount)
        IF N_ELEMENTS(PtThick) GT 1 AND N_ELEMENTS(PtThick) NE DataPointCount THEN m_PtThick = REPLICATE(PtThick[0],DataPointCount)
        IF N_ELEMENTS(PtThick) GT 1 AND N_ELEMENTS(PtThick) EQ DataPointCount THEN m_PtThick = PtThick
        
        IF N_ELEMENTS(PtColor) EQ 0 THEN m_PtColor = REPLICATE(0.0,DataPointCount) ; 'BLUE'
        IF N_ELEMENTS(PtColor) EQ 1 THEN m_PtColor = REPLICATE(PtColor,DataPointCount)
        IF N_ELEMENTS(PtColor) GT 1 AND N_ELEMENTS(PtColor) NE DataPointCount THEN m_PtColor = REPLICATE(PtColor[0],DataPointCount)
        IF N_ELEMENTS(PtColor) GT 1 AND N_ELEMENTS(PtColor) EQ DataPointCount THEN m_PtColor = PtColor
        
        IF N_ELEMENTS(PtLabel) EQ 0 THEN m_PtLabel = REPLICATE('',DataPointCount)
        IF N_ELEMENTS(PtLabel) EQ 1 THEN m_PtLabel = REPLICATE(PtLabel,DataPointCount)
        IF N_ELEMENTS(PtLabel) GT 1 AND N_ELEMENTS(PtLabel) NE DataPointCount THEN m_PtLabel = REPLICATE(PtLabel[0],DataPointCount)
        IF N_ELEMENTS(PtLabel) GT 1 AND N_ELEMENTS(PtLabel) EQ DataPointCount THEN m_PtLabel = PtLabel
        
        IF N_ELEMENTS(PtLSize) EQ 0 THEN m_PtLSize = REPLICATE(0.25000,DataPointCount) ; default PtLabel size
        IF N_ELEMENTS(PtLSize) EQ 1 THEN m_PtLSize = REPLICATE(PtLSize,DataPointCount)
        IF N_ELEMENTS(PtLSize) GT 1 AND N_ELEMENTS(PtLSize) NE DataPointCount THEN m_PtLSize = REPLICATE(PtLSize[0],DataPointCount)
        IF N_ELEMENTS(PtLSize) GT 1 AND N_ELEMENTS(PtLSize) EQ DataPointCount THEN m_PtLSize = PtLSize
        
        IF N_ELEMENTS(PtLThic) EQ 0 THEN m_PtLThic = REPLICATE(0.25000,DataPointCount) ; default PtLabel thick
        IF N_ELEMENTS(PtLThic) EQ 1 THEN m_PtLThic = REPLICATE(PtLThic,DataPointCount)
        IF N_ELEMENTS(PtLThic) GT 1 AND N_ELEMENTS(PtLThic) NE DataPointCount THEN m_PtLThic = REPLICATE(PtLThic[0],DataPointCount)
        IF N_ELEMENTS(PtLThic) GT 1 AND N_ELEMENTS(PtLThic) EQ DataPointCount THEN m_PtLThic = PtLThic
        
        IF N_ELEMENTS(PtLRota) EQ 0 THEN m_PtLRota = REPLICATE(0.00000,DataPointCount) ; default PtLabel rotation
        IF N_ELEMENTS(PtLRota) EQ 1 THEN m_PtLRota = REPLICATE(PtLRota,DataPointCount)
        IF N_ELEMENTS(PtLRota) GT 1 AND N_ELEMENTS(PtLRota) NE DataPointCount THEN m_PtLRota = REPLICATE(PtLRota[0],DataPointCount)
        IF N_ELEMENTS(PtLRota) GT 1 AND N_ELEMENTS(PtLRota) EQ DataPointCount THEN m_PtLRota = PtLRota
        
        IF N_ELEMENTS(PtNote)  EQ 0 THEN m_PtNote = REPLICATE('',DataPointCount)
        IF N_ELEMENTS(PtNote)  EQ 1 THEN m_PtNote = REPLICATE(PtNote,DataPointCount)
        IF N_ELEMENTS(PtNote)  GT 1 AND N_ELEMENTS(PtNote) NE DataPointCount THEN m_PtNote = REPLICATE(PtNote[0],DataPointCount)
        IF N_ELEMENTS(PtNote)  GT 1 AND N_ELEMENTS(PtNote) EQ DataPointCount THEN m_PtNote = PtNote
        ;
        IF N_ELEMENTS(AddVar1) EQ 0 THEN m_AddVar1 = REPLICATE(0.00000,DataPointCount) ; additional var for other uses
        IF N_ELEMENTS(AddVar1) EQ 1 THEN m_AddVar1 = REPLICATE(AddVar1,DataPointCount)
        IF N_ELEMENTS(AddVar1) GT 1 AND N_ELEMENTS(AddVar1) NE DataPointCount THEN m_AddVar1 = REPLICATE(AddVar1[0],DataPointCount)
        IF N_ELEMENTS(AddVar1) GT 1 AND N_ELEMENTS(AddVar1) EQ DataPointCount THEN m_AddVar1 = AddVar1
        ;
        IF N_ELEMENTS(AddVar2) EQ 0 THEN m_AddVar2 = REPLICATE(0.00000,DataPointCount)
        IF N_ELEMENTS(AddVar2) EQ 1 THEN m_AddVar2 = REPLICATE(AddVar2,DataPointCount)
        IF N_ELEMENTS(AddVar2) GT 1 AND N_ELEMENTS(AddVar2) NE DataPointCount THEN m_AddVar2 = REPLICATE(AddVar2[0],DataPointCount)
        IF N_ELEMENTS(AddVar2) GT 1 AND N_ELEMENTS(AddVar2) EQ DataPointCount THEN m_AddVar2 = AddVar2
        ;
        IF N_ELEMENTS(AddVar3) EQ 0 THEN m_AddVar3 = REPLICATE(0.00000,DataPointCount)
        IF N_ELEMENTS(AddVar3) EQ 1 THEN m_AddVar3 = REPLICATE(AddVar3,DataPointCount)
        IF N_ELEMENTS(AddVar3) GT 1 AND N_ELEMENTS(AddVar3) NE DataPointCount THEN m_AddVar3 = REPLICATE(AddVar3[0],DataPointCount)
        IF N_ELEMENTS(AddVar3) GT 1 AND N_ELEMENTS(AddVar3) EQ DataPointCount THEN m_AddVar3 = AddVar3
        ;
        IF N_ELEMENTS(AddVar4) EQ 0 THEN m_AddVar4 = REPLICATE(0.00000,DataPointCount)
        IF N_ELEMENTS(AddVar4) EQ 1 THEN m_AddVar4 = REPLICATE(AddVar4,DataPointCount)
        IF N_ELEMENTS(AddVar4) GT 1 AND N_ELEMENTS(AddVar4) NE DataPointCount THEN m_AddVar4 = REPLICATE(AddVar4[0],DataPointCount)
        IF N_ELEMENTS(AddVar4) GT 1 AND N_ELEMENTS(AddVar4) EQ DataPointCount THEN m_AddVar4 = AddVar4
        ;
        IF N_ELEMENTS(AddVar5) EQ 0 THEN m_AddVar5 = REPLICATE(0.00000,DataPointCount)
        IF N_ELEMENTS(AddVar5) EQ 1 THEN m_AddVar5 = REPLICATE(AddVar5,DataPointCount)
        IF N_ELEMENTS(AddVar5) GT 1 AND N_ELEMENTS(AddVar5) NE DataPointCount THEN m_AddVar5 = REPLICATE(AddVar5[0],DataPointCount)
        IF N_ELEMENTS(AddVar5) GT 1 AND N_ELEMENTS(AddVar5) EQ DataPointCount THEN m_AddVar5 = AddVar5
        ;
        IF N_ELEMENTS(AddVar6) EQ 0 THEN m_AddVar6 = REPLICATE(0.00000,DataPointCount)
        IF N_ELEMENTS(AddVar6) EQ 1 THEN m_AddVar6 = REPLICATE(AddVar6,DataPointCount)
        IF N_ELEMENTS(AddVar6) GT 1 AND N_ELEMENTS(AddVar6) NE DataPointCount THEN m_AddVar6 = REPLICATE(AddVar6[0],DataPointCount)
        IF N_ELEMENTS(AddVar6) GT 1 AND N_ELEMENTS(AddVar6) EQ DataPointCount THEN m_AddVar6 = AddVar6
        ;
        IF SIZE(m_PtColor,/TNAME)EQ 'STRING' THEN BEGIN
            TempColor = m_PtColor & m_PtColor = MAKE_ARRAY(N_ELEMENTS(TempColor),/LONG)
            m_PtColor = cgColor(TempColor)
        ENDIF ELSE IF SIZE(m_PtColor,/TNAME)EQ 'INT' AND MAX(m_PtColor,/NAN) LE 255 THEN BEGIN
            ; TempColor = PtColor & PtColor = MAKE_ARRAY(N_ELEMENTS(TempColor),/LONG)
            ; PtColor = cgColor(TempColor)
            ; <TODO>
        ENDIF
        ;;
        FOR DPId=0,DataPointCount-1 DO BEGIN
            ;;
            PlotDataPoint = { CrabFigureDataStructurePoint, XValue : XValue[DPId],  $
                                                            YValue : YValue[DPId],  $
                                                            XError : XError[DPId],  $
                                                            YError : YError[DPId],  $
                                                           SymSize : m_SymSize[DPId], $
                                                           SymType : m_SymType[DPId], $
                                                           SymFill : m_SymFill[DPId], $
                                                           PtThick : m_PtThick[DPId], $
                                                           PtColor : m_PtColor[DPId], $
                                                           PtLabel : m_PtLabel[DPId], $
                                                           PtLSize : m_PtLSize[DPId], $
                                                           PtLThic : m_PtLThic[DPId], $
                                                           PtLRota : m_PtLRota[DPId], $
                                                            PtNote : m_PtNote[DPId],  $
                                                           AddVar1 : m_AddVar1[DPId], $
                                                           AddVar2 : m_AddVar2[DPId], $
                                                           AddVar3 : m_AddVar3[DPId], $
                                                           AddVar4 : m_AddVar4[DPId], $
                                                           AddVar5 : m_AddVar5[DPId], $
                                                           AddVar6 : m_AddVar6[DPId]  }
            ;;
            *(SELF.DataPoints) = [ *(SELF.DataPoints), PlotDataPoint ]
            DataPointAdded = DataPointAdded + 1
        ENDFOR
    ENDIF
    ; Verbose
    IF KEYWORD_SET(Verbose) THEN BEGIN
        NewDataPointCount = N_ELEMENTS(*(SELF.DataPoints))
        PRINT, 'CrabFigureDataStructure::addDataPoint ' + STRING(DataPointAdded,FORMAT='(I0)') + $
                         ' new data points, add up to ' + STRING(NewDataPointCount,FORMAT='(I0)') + ' data points. '
    ENDIF
    RETURN
END



PRO CrabFigureDataStructure::setDataPoint,                Index,       $
                                                Verbose = Verbose,     $
                                                 XValue = XValue,      $
                                                 YValue = YValue,      $
                                                 XError = XError,      $
                                                 YError = YError,      $
                                                SymSize = SymSize,     $ ; SymSize 
                                                SymType = SymType,     $ ; Symbol 
                                                SymFill = SymFill,     $ ; Symbol
                                                PtThick = PtThick,     $ ; Thickness
                                                PtColor = PtColor,     $ ; Color 
                                                PtLabel = PtLabel,     $ ; Label 
                                                PtLSize = PtLSize,     $ ; Label Size
                                                PtLThic = PtLThic,     $ ; Label Thick
                                                PtLRota = PtLRota,     $ ; Label Rotation
                                                 PtNote = PtNote,      $ ; additional note
                                                AddVar1 = AddVar1,     $ 
                                                AddVar2 = AddVar2,     $ 
                                                AddVar3 = AddVar3,     $
                                                AddVar4 = AddVar4,     $
                                                AddVar5 = AddVar5,     $
                                                AddVar6 = AddVar6,     $
                                                  Debug = Debug
    ;;
    IF Index GE 0 AND Index LT N_ELEMENTS(*(SELF.DataPoints)) THEN BEGIN
        ;;
        OldDataPoint = (*(SELF.DataPoints))[Index]
        IF N_ELEMENTS(XValue)  EQ 1 THEN XValue = DOUBLE(XValue) ELSE XValue = OldDataPoint.XValue
        IF N_ELEMENTS(YValue)  EQ 1 THEN YValue = DOUBLE(YValue) ELSE YValue = OldDataPoint.YValue
        IF N_ELEMENTS(XError)  EQ 1 THEN XError = DOUBLE(XError) ELSE XError = OldDataPoint.XError
        IF N_ELEMENTS(YError)  EQ 1 THEN YError = DOUBLE(YError) ELSE YError = OldDataPoint.YError
        IF N_ELEMENTS(SymSize) EQ 1 THEN SymSize = SymSize ELSE SymSize = OldDataPoint.SymSize
        IF N_ELEMENTS(SymType) EQ 1 THEN SymType = SymType ELSE SymType = OldDataPoint.SymType
        IF N_ELEMENTS(SymFill) EQ 1 THEN SymFill = SymFill ELSE SymFill = OldDataPoint.SymFill
        IF N_ELEMENTS(PtThick) EQ 1 THEN PtThick = PtThick ELSE PtThick = OldDataPoint.PtThick
        IF N_ELEMENTS(PtColor) EQ 1 THEN PtColor = PtColor ELSE PtColor = OldDataPoint.PtColor
        IF N_ELEMENTS(PtLabel) EQ 1 THEN PtLabel = PtLabel ELSE PtLabel = OldDataPoint.PtLabel
        IF N_ELEMENTS(PtLSize) EQ 1 THEN PtLSize = PtLSize ELSE PtLSize = OldDataPoint.PtLSize
        IF N_ELEMENTS(PtLThic) EQ 1 THEN PtLThic = PtLThic ELSE PtLThic = OldDataPoint.PtLThic
        IF N_ELEMENTS(PtLRota) EQ 1 THEN PtLRota = PtLRota ELSE PtLRota = OldDataPoint.PtLRota
        IF N_ELEMENTS(PtNote)  EQ 1 THEN PtNote = PtNote   ELSE PtNote  = OldDataPoint.PtNote
        IF N_ELEMENTS(AddVar1) EQ 1 THEN AddVar1 = AddVar1 ELSE AddVar1 = OldDataPoint.AddVar1
        IF N_ELEMENTS(AddVar2) EQ 1 THEN AddVar2 = AddVar2 ELSE AddVar2 = OldDataPoint.AddVar2
        IF N_ELEMENTS(AddVar3) EQ 1 THEN AddVar3 = AddVar3 ELSE AddVar3 = OldDataPoint.AddVar3
        IF N_ELEMENTS(AddVar4) EQ 1 THEN AddVar4 = AddVar4 ELSE AddVar4 = OldDataPoint.AddVar4
        IF N_ELEMENTS(AddVar5) EQ 1 THEN AddVar5 = AddVar5 ELSE AddVar5 = OldDataPoint.AddVar5
        IF N_ELEMENTS(AddVar6) EQ 1 THEN AddVar6 = AddVar6 ELSE AddVar6 = OldDataPoint.AddVar6
        ;;
        FOR DPId=0,N_ELEMENTS(*(SELF.DataPoints))-1 DO BEGIN
            ;;
            IF DpId NE Index THEN CONTINUE
            ;;
            PlotDataPoint = { CrabFigureDataStructurePoint, XValue : XValue,  $
                                                            YValue : YValue,  $
                                                            XError : XError,  $
                                                            YError : YError,  $
                                                           SymSize : SymSize, $
                                                           SymType : SymType, $
                                                           SymFill : SymFill, $
                                                           PtThick : PtThick, $
                                                           PtColor : PtColor, $
                                                           PtLabel : PtLabel, $
                                                           PtLSize : PtLSize, $
                                                           PtLThic : PtLThic, $
                                                           PtLRota : PtLRota, $
                                                            PtNote : PtNote,  $
                                                           AddVar1 : AddVar1, $
                                                           AddVar2 : AddVar2, $
                                                           AddVar3 : AddVar3, $
                                                           AddVar4 : AddVar4, $
                                                           AddVar5 : AddVar5, $
                                                           AddVar6 : AddVar6  }
            ;;
            (*(SELF.DataPoints))[Index] = PlotDataPoint
        ENDFOR
    ENDIF
    RETURN
END



PRO CrabFigureDataStructure::addAnnotation,      Verbose = Verbose,    $
                                                Position = Position,   $
                                                  Normal = Normal,     $
                                                    Data = Data,       $
                                                    Text = Text,       $
                                                   Color = Color,      $ 
                                                CharSize = CharSize,   $
                                               CharThick = CharThick,  $
                                               Alignment = Alignment,  $
                                                Rotation = Rotation
    ;;
    IF N_ELEMENTS(Position) GE 2 AND N_ELEMENTS(Text) GE 1 AND N_ELEMENTS(Position) EQ 2*N_ELEMENTS(Text) THEN BEGIN
        ;;
        AnnotationCount = 1
        AnnotationAdded = 0
        ;;
        IF N_ELEMENTS(Normal)    LE 0 THEN Normal    = 0
        IF N_ELEMENTS(Normal)    GE 1 THEN Normal    = Normal[0]
        ;
        IF N_ELEMENTS(Data)      LE 0 THEN Data      = 0
        IF N_ELEMENTS(Data)      GE 1 THEN Data      = Data[0]
        ;
        IF N_ELEMENTS(Color)     LE 0 THEN Color     = 0.0
        IF N_ELEMENTS(Color)     GE 1 THEN Color     = Color[0]
        ;
        IF N_ELEMENTS(CharSize)  LE 0 THEN CharSize  = 1.0
        IF N_ELEMENTS(CharSize)  GE 1 THEN CharSize  = FLOAT(CharSize[0])
        ;
        IF N_ELEMENTS(CharThick) LE 0 THEN CharThick = 1.0
        IF N_ELEMENTS(CharThick) GE 1 THEN CharThick = FLOAT(CharThick[0])
        ;
        IF N_ELEMENTS(Alignment) LE 0 THEN Alignment = 0.5
        IF N_ELEMENTS(Alignment) GE 1 THEN Alignment = FLOAT(Alignment[0])
        ;
        IF N_ELEMENTS(Rotation)  LE 0 THEN Rotation  = 0.0
        IF N_ELEMENTS(Rotation)  GE 1 THEN Rotation  = FLOAT(Rotation[0])
        ;; 
        NewAnnotation = { CrabFigureDataStructureAnnotation, Position : Position,  $
                                                               Normal : Normal,    $ ; XYOUTS, /NORMAL
                                                                 Data : Data,      $ ; XYOUTS, /DATA
                                                                 Text : Text,      $
                                                                Color : Color,     $
                                                             CharSize : CharSize,  $
                                                            CharThick : CharThick, $
                                                            Alignment : Alignment, $
                                                             Rotation : Rotation   }
        ;;
        *(SELF.Annotations) = [ *(SELF.Annotations), NewAnnotation ]
        AnnotationAdded = 1
    ENDIF
END



PRO CrabFigureDataStructure::setAnnotation,                Index,      $
                                                 Verbose = Verbose,    $
                                                Position = Position,   $
                                                  Normal = Normal,     $
                                                    Data = Data,       $
                                                    Text = Text,       $
                                                   Color = Color,      $
                                                CharSize = CharSize,   $
                                               CharThick = CharThick,  $
                                               Alignment = Alignment,  $
                                                Rotation = Rotation
    ;;
    IF Index GE 0 AND Index LT N_ELEMENTS(*(SELF.Annotations)) THEN BEGIN
        ;;
        OldAnnotation = (*(SELF.Annotations))[Index]
        ;;
        IF N_ELEMENTS(Position)  GE 2 THEN Position=Position[0:1] ELSE Position=OldAnnotation.Position
        IF N_ELEMENTS(Normal)    GE 1 THEN Normal=Normal[0]       ELSE Normal=OldAnnotation.Normal
        IF N_ELEMENTS(Data)      GE 1 THEN Data=Data[0]           ELSE Data=OldAnnotation.Data
        IF N_ELEMENTS(Text)      GE 1 THEN Text=Text[0]           ELSE Text=OldAnnotation.Text
        IF N_ELEMENTS(Color)     GE 1 THEN Color=Color[0]         ELSE Color=OldAnnotation.Color
        IF N_ELEMENTS(CharSize)  GE 1 THEN CharSize=CharSize[0]   ELSE CharSize=OldAnnotation.CharSize
        IF N_ELEMENTS(CharThick) GE 1 THEN CharThick=CharThick[0] ELSE CharThick=OldAnnotation.CharThick
        IF N_ELEMENTS(Alignment) GE 1 THEN Alignment=Alignment[0] ELSE Alignment=OldAnnotation.Alignment
        IF N_ELEMENTS(Rotation)  GE 1 THEN Rotation=Rotation[0]   ELSE Rotation=OldAnnotation.Rotation
        ;; 
        FOR ANId=0,N_ELEMENTS(*(SELF.Annotations))-1 DO BEGIN
            ;;
            IF ANId NE Index THEN CONTINUE
            ;;
            NewAnnotation = { CrabFigureDataStructureAnnotation, Position : Position,  $
                                                                   Normal : Normal,    $ ; XYOUTS, /NORMAL
                                                                     Data : Data,      $ ; XYOUTS, /DATA
                                                                     Text : Text,      $
                                                                    Color : Color,     $
                                                                 CharSize : CharSize,  $
                                                                CharThick : CharThick, $
                                                                Alignment : Alignment, $
                                                                 Rotation : Rotation   }
            ;;
            (*(SELF.Annotations))[Index] = NewAnnotation
        ENDFOR
    ENDIF
END



PRO CrabFigureDataStructure::addPolyline,        Verbose = Verbose, $ 
                                                  XArray = XArray,  $ 
                                                  YArray = YArray,  $ 
                                                   Color = Color,   $ 
                                                   Style = Style,   $ 
                                                   Thick = Thick,   $ 
                                                    Note = Note
    ;;
    IF N_ELEMENTS(XArray) GE 1 AND N_ELEMENTS(YArray) GE 1 AND N_ELEMENTS(XArray) EQ N_ELEMENTS(YArray) THEN BEGIN
        ;;
        PolylineCount = 1
        PolylineAdded = 0
        ;;
        IF N_ELEMENTS(Color)     GE 1 THEN Color = Color[0]
        IF N_ELEMENTS(Color)     EQ 0 THEN Color = 0.0
        ;
        IF N_ELEMENTS(Style)     GE 1 THEN Style = Style[0]
        IF N_ELEMENTS(Style)     EQ 0 THEN Style = 0
        ;
        IF N_ELEMENTS(Thick)     GE 1 THEN Thick = Thick[0]
        IF N_ELEMENTS(Thick)     EQ 0 THEN Thick = 1.0
        ;
        IF N_ELEMENTS(Note)      GE 1 THEN Note = Note[0]
        IF N_ELEMENTS(Note)      EQ 0 THEN Note = ''
        ;; 
        FOR PLId=0,0 DO BEGIN
            NewPolyline = { CrabFigureDataStructurePolyline, XArray : XArray,  $
                                                             YArray : YArray,  $
                                                              Color : Color,   $
                                                              Style : Style,   $
                                                              Thick : Thick,   $
                                                               Note : Note     }
            ;;
            *(SELF.Polylines) = [ *(SELF.Polylines), NewPolyline ]
            PolylineAdded = PolylineAdded + 1
        ENDFOR
    ENDIF
END



PRO CrabFigureDataStructure::setPolyline,                  Index,   $
                                                 Verbose = Verbose, $
                                                  XArray = XArray,  $
                                                  YArray = YArray,  $
                                                   Color = Color,   $ 
                                                   Style = Style,   $
                                                   Thick = Thick,   $
                                                    Note = Note
    ;;
    IF Index GE 0 AND Index LT N_ELEMENTS(*(SELF.Polylines)) THEN BEGIN
        ;; 
        OldPolyline = (*(SELF.Polylines))[Index]
        ;; 
        IF N_ELEMENTS(XArray)    GE 1 THEN XArray=XArray ELSE XArray=OldPolyline.XArray
        IF N_ELEMENTS(YArray)    GE 1 THEN YArray=YArray ELSE YArray=OldPolyline.YArray
        IF N_ELEMENTS(Color)     GE 1 THEN Color=Color   ELSE Color=OldPolyline.Color
        IF N_ELEMENTS(Style)     GE 1 THEN Style=Style   ELSE Style=OldPolyline.Style
        IF N_ELEMENTS(Thick)     GE 1 THEN Thick=Thick   ELSE Thick=OldPolyline.Thick
        IF N_ELEMENTS(Note)      GE 1 THEN Note=Note     ELSE Note=OldPolyline.Note
        ;; 
        FOR PLId=0,N_ELEMENTS(*(SELF.Polylines))-1 DO BEGIN
            ;;
            IF PLId NE Index THEN CONTINUE
            ;;
            NewPolyline = { CrabFigureDataStructurePolyline, XArray : XArray,  $
                                                             YArray : YArray,  $
                                                              Color : Color,   $
                                                              Style : Style,   $
                                                              Thick : Thick,   $
                                                               Note : Note     }
            ;;
            (*(SELF.Polylines))[Index] = NewPolyline
        ENDFOR
    ENDIF
END














FUNCTION CrabFigureDataStructure::checkXRange
    IF SELF->count() LE 0 THEN RETURN, []
    TempRange = SELF->xRange()
    IF TempRange EQ !NULL THEN BEGIN
        TempRange = CrabMinMax(SELF->xValue(),/NoZero)
        TempDiff = 0.0
        IF KEYWORD_SET(SELF->xLog()) THEN BEGIN
            TempDiff = ALOG10(TempRange[1])-ALOG10(TempRange[0])
            TempRange[0] = ALOG10(TempRange[0]) - 0.06*TempDiff
            TempRange[1] = ALOG10(TempRange[1]) + 0.06*TempDiff
            TempRange[0] = 10^(TempRange[0])
            TempRange[1] = 10^(TempRange[1])
        ENDIF ELSE BEGIN
            TempDiff = TempRange[1] - TempRange[0]
            TempRange[0] = TempRange[0] - 0.06*TempDiff
            TempRange[1] = TempRange[1] + 0.06*TempDiff
        ENDELSE
        SELF.XRange = TempRange
    ENDIF
    RETURN, TempRange
END
FUNCTION CrabFigureDataStructure::checkYRange
    IF SELF->count() LE 0 THEN RETURN, []
    TempRange = SELF->yRange()
    IF TempRange EQ !NULL THEN BEGIN
        TempRange = CrabMinMax(SELF->yValue(),/NoZero)
        TempDiff = 0.0
        IF KEYWORD_SET(SELF->yLog()) THEN BEGIN
            TempDiff = ALOG10(TempRange[1])-ALOG10(TempRange[0])
            TempRange[0] = ALOG10(TempRange[0]) - 0.06*TempDiff
            TempRange[1] = ALOG10(TempRange[1]) + 0.06*TempDiff
            TempRange[0] = 10^(TempRange[0])
            TempRange[1] = 10^(TempRange[1])
        ENDIF ELSE BEGIN
            TempDiff = TempRange[1] - TempRange[0]
            TempRange[0] = TempRange[0] - 0.06*TempDiff
            TempRange[1] = TempRange[1] + 0.06*TempDiff
        ENDELSE
        SELF.YRange = TempRange
    ENDIF
    RETURN, TempRange
END
FUNCTION CrabFigureDataStructure::checkRRange
    IF SELF->count() LE 0 THEN RETURN, [] ; <TODO> R Range is the right Y axis data range
    IF SELF->rRange() EQ !NULL AND STRTRIM(SELF->rTitle(),2) NE '' THEN BEGIN
        XMargin[1] = XMargin[0]
        IF N_ELEMENTS(SELF->rRange()) EQ 2 THEN BEGIN
            SELF.YStyle=8+1
            SELF.RStyle=8+1
            SELF.RStyle=8+1
           ;RLog=1 ; RTicksFormatSTR='(F0.3)'
        ENDIF
    ENDIF
    RETURN, SELF->rRange()
END
FUNCTION CrabFigureDataStructure::checkCRange
    IF SELF->count() LE 0 THEN RETURN, [] ; <TODO> C Range is the point color range
                                          ; <TODO> 
    TempRange = SELF->cRange() ; the color bar value range
    IF TempRange EQ !NULL THEN BEGIN
        TempRange = CrabMinMax(SELF->ptColor())
        TempDiff = TempRange[1] - TempRange[0] + 50
        TempRange[0] = TempRange[0] - 0.1*TempDiff
        TempRange[1] = TempRange[1] + 0.1*TempDiff
        SELF.CRange = TempRange
    ENDIF
    RETURN, TempRange
END






















PRO CrabFigureDataStructure::beginPS, PSFilePath, PSDimensions=PSDimensions, PSFont=PSFont, OverPlot=OverPlot
    IF N_ELEMENTS(PSDimensions) LT 2 THEN BEGIN
        PSDimensions = [20,16.5] ; <TODO> default dimensions
    ENDIF ELSE BEGIN
        PSDimensions = PSDimensions[0:1]
    ENDELSE
    IF SIZE(PSFilePath,/TNAME) EQ 'STRING' THEN BEGIN
        IF STRTRIM(PSFilePath,2) NE '' THEN BEGIN
            ; set plot PS
            IF NOT KEYWORD_SET(OverPlot) THEN BEGIN
                SET_PLOT, 'PS'
                DEVICE, FILENAME=PSFilePath, /COLOR, /ENCAPSULATED, BITS=8, $
                        XSIZE=PSDimensions[0], YSIZE=PSDimensions[1] ;, FONT_SIZE=9, BITS=8, 
                ;DEVICE, SET_FONT='DejaVuSans', /TT_FONT
                ;DEVICE, SET_FONT='NGC', /TT_FONT
                IF N_ELEMENTS(PSFont) GT 0 THEN BEGIN 
                    DEVICE, SET_FONT=PSFont, /TT_FONT
                ENDIF
            ENDIF
            SetDecomposedState, 1, CurrentState=currentState, DEPTH=24 ; <TODO> otherwise cgDefaultColor gets error
            NULL = GetDecomposedState() ; <TODO> otherwise cgDefaultColor gets error
            ; enhance char size and char thick
            SELF.TitleCharThick  = SELF.TitleCharThick  * 4.0
            SELF.TitleCharSizeF  = SELF.TitleCharSizeF  * 3.00 ; default title char size
            SELF.XTitleCharThick = SELF.XTitleCharThick * 4.0
            SELF.XTitleCharSizeF = SELF.XTitleCharSizeF * 3.00 ; default xtitle char size
            SELF.YTitleCharThick = SELF.YTitleCharThick * 4.0
            SELF.YTitleCharSizeF = SELF.YTitleCharSizeF * 3.00 ; default ytitle char size
            SELF.RTitleCharThick = SELF.RTitleCharThick * 4.0
            SELF.RTitleCharSizeF = SELF.RTitleCharSizeF * 3.00 ; default rtitle char size
            SELF.CTitleCharThick = SELF.CTitleCharThick * 4.0
            SELF.CTitleCharSizeF = SELF.CTitleCharSizeF * 2.50 ; default ctitle char size
            SELF.ColBarCharThick = SELF.ColBarCharThick * 3.0
            SELF.ColBarCharSizeF = SELF.ColBarCharSizeF * 1.25
            SELF.LegendCharThick = SELF.LegendCharThick * 5.0
            SELF.LegendCharSizeF = SELF.LegendCharSizeF * 2.50 ; default legend char size
            SELF.XTicksCharThick = SELF.XTicksCharThick * 3.5
            SELF.XTicksCharSizeF = SELF.XTicksCharSizeF * 2.50 ; default XTicksCharSizeF
            SELF.YTicksCharThick = SELF.YTicksCharThick * 3.5
            SELF.YTicksCharSizeF = SELF.YTicksCharSizeF * 2.50 ; default YTicksCharSizeF
            SELF.RTicksCharThick = SELF.RTicksCharThick * 3.5
            SELF.RTicksCharSizeF = SELF.RTicksCharSizeF * 2.30
            SELF.XThick = SELF.XThick * 7.5
            SELF.YThick = SELF.YThick * 7.5
;            ; repair xminor <TODO>
;            SELF.XMinor = SELF.XMinor-1
;            PRINT, SELF.XMinor
            ; return here
            RETURN
        ENDIF
    ENDIF
    MESSAGE, 'CrabFigureDataStructure::beginPS failed! Input SaveFile is invalid!'
END



PRO CrabFigureDataStructure::finishPS, PSFilePath
    DEVICE, /CLOSE
    IF SELF.DefaultDevice NE '' THEN BEGIN
        SET_PLOT, SELF.DefaultDevice
    ENDIF
    IF SIZE(PSFilePath,/TNAME) EQ 'STRING' THEN BEGIN
        IF STRTRIM(PSFilePath,2) NE '' THEN BEGIN
            ; convert ps to pdf
            ConvertPS2PDF, PSFilePath
            ; de-enhance char size and char thick ; <TODO>
            SELF.TitleCharThick  = SELF.TitleCharThick  / 4.0
            SELF.TitleCharSizeF  = SELF.TitleCharSizeF  / 1.25
            SELF.XTitleCharThick = SELF.XTitleCharThick / 2.0
            SELF.XTitleCharSizeF = SELF.XTitleCharSizeF / 1.25
            SELF.YTitleCharThick = SELF.YTitleCharThick / 2.0
            SELF.YTitleCharSizeF = SELF.YTitleCharSizeF / 1.25
            SELF.RTitleCharThick = SELF.RTitleCharThick / 2.0
            SELF.RTitleCharSizeF = SELF.RTitleCharSizeF / 1.25
            SELF.CTitleCharThick = SELF.CTitleCharThick / 2.0
            SELF.CTitleCharSizeF = SELF.CTitleCharSizeF / 1.25
            SELF.ColBarCharThick = SELF.ColBarCharThick / 2.0
            SELF.ColBarCharSizeF = SELF.ColBarCharSizeF / 1.25
            SELF.LegendCharThick = SELF.LegendCharThick / 2.0
            SELF.LegendCharSizeF = SELF.LegendCharSizeF / 1.25
            SELF.XTicksCharThick = SELF.XTicksCharThick / 2.5
            SELF.XTicksCharSizeF = SELF.XTicksCharSizeF / 1.50
            SELF.YTicksCharThick = SELF.YTicksCharThick / 2.5
            SELF.YTicksCharSizeF = SELF.YTicksCharSizeF / 1.50
            SELF.RTicksCharThick = SELF.RTicksCharThick / 2.5
            SELF.RTicksCharSizeF = SELF.RTicksCharSizeF / 1.50
            SELF.XThick = SELF.XThick / 2.5
            SELF.YThick = SELF.YThick / 2.5
;            ; repair xminor <TODO>
;            SELF.XMinor = SELF.XMinor+1
            ; return here
            RETURN
        ENDIF
    ENDIF
END




















PRO CrabFigureDataStructure::doPlot, Position=Position, Dimensions=Dimensions, Margins=Margins, OverPlot=OverPlot, $
                                     WindowId=WindowId, WindowTitle=WindowTitle, XNoErrorBar=XNoErrorBar, YNoErrorBar=YNoErrorBar, $
                                     ShowPtLabel=ShowPtLabel, ShowPtNote=ShowPtNote, ShowErrorBar=ShowErrorBar, $
                                     ShowXTicks=ShowXTicks, ShowYTicks=ShowYTicks, $
                                     ShowLegend=ShowLegend, $
                                     Silent=Silent, SetColorReverse=SetColorReverse
    
    ; Check DataPoints
    IF SELF->count() EQ 0 THEN BEGIN
        MESSAGE, 'CrabFigureDataStructure::doPlot: this CrabFigureDataStructure contains no data point! Plot failed!'
        RETURN
    ENDIF
    
    ; Prepare Rainbow
    RGBTable = 13
    LoadCT, RGBTable, /SILENT
    LoadCT, RGBTable, NCOLORS=256, RGB_TABLE=RainbowTable, /SILENT
    IF N_ELEMENTS(SetColorReverse) EQ 0 THEN BEGIN
        SetColorReverse = 0
    ENDIF
    IF KEYWORD_SET(SetColorReverse) THEN BEGIN
        RainbowTable[*,0] = REVERSE(RainbowTable[*,0]) ; <TODO> defaultly, RainbowTable 0 means blue and 255 means red. reverse it.
        RainbowTable[*,1] = REVERSE(RainbowTable[*,1]) ; <TODO> defaultly, RainbowTable 0 means blue and 255 means red. reverse it.
        RainbowTable[*,2] = REVERSE(RainbowTable[*,2]) ; <TODO> defaultly, RainbowTable 0 means blue and 255 means red. reverse it.
    ENDIF
    
    ; Prepare Position and Dimensions and Margins
;    IF N_ELEMENTS(Position) EQ 0 THEN BEGIN ; <TODO> set default position ??
;        Position = 
;    ENDIF ELSE BEGIN
;        IF TOTAL(Position) EQ 0 THEN BEGIN
;            Position = 
;        ENDIF
;    ENDELSE
    IF N_ELEMENTS(Dimensions) EQ 0 THEN BEGIN
;       IF STRMATCH(!D.NAME,'*PS*',/F) THEN Dimensions=[10,9] ; <TODO> Dimensions=[20,16.5]|[20,18] if with TITLE
        IF STRMATCH(!D.NAME,'*WIN*',/F) THEN Dimensions=[720,594]
        IF STRMATCH(!D.NAME,'*X*',/F) THEN Dimensions=[720,594]
    ENDIF
    IF N_ELEMENTS(Margins) NE 4 THEN BEGIN
        IF STRMATCH(!D.NAME,'*PS*',/F) THEN Margins=[10,6,6,4.5] ; [0.2,0.2,0.1,0.05] ; [left, bottom, right, top] ; <TODO> TOP=0.2 if with TITLE
        IF STRMATCH(!D.NAME,'*WIN*',/F) THEN Margins=[8,4,4,3] ; [left, bottom, right, top] for WIN rather than PS
        IF STRMATCH(!D.NAME,'*X*',/F) THEN Margins=[8,4,4,3] ; [left, bottom, right, top] for X rather than PS
        IF STRMATCH(!D.NAME,'*PS*',/F) AND STRMATCH(!VERSION.OS_NAME,'*MAC*',/F)  THEN Margins=[13,6,8,5]
    ENDIF
    IF N_ELEMENTS(Margins) EQ 4 THEN BEGIN
        XMargin=[Margins[0],Margins[2]] ; [left, right] ; idl default [10,3]
        YMargin=[Margins[1],Margins[3]] ; [bottom, top] ; idl default [4, 2]
    ENDIF
    
    ; Check XRange
    XRange = SELF->checkXRange()
    
    ; Check YRange
    YRange = SELF->checkYRange()
    
    ; Check RRange
    RRange = SELF->checkRRange()
    
    ; Check CRange
    ; CRange = SELF->checkCRange()
    
    ; Check ShowXTicks
    XTICKFORMAT = SELF->xTickFormat()
    XTICKNAME = SELF->xTicksTextArray()
    IF N_ELEMENTS(ShowXTicks) EQ 1 THEN BEGIN
        IF ShowXTicks LE 0 THEN BEGIN
            XTICKFORMAT = '(A1)'
            XTICKNAME = ' '
        ENDIF
    ENDIF
    
    ; Check ShowYTicks
    YTICKFORMAT = SELF->yTickFormat()
    YTICKNAME = SELF->yTicksTextArray()
    IF N_ELEMENTS(ShowYTicks) EQ 1 THEN BEGIN
        IF ShowYTicks LE 0 THEN BEGIN
            YTICKFORMAT = '(A1)'
            YTICKNAME = ' '
        ENDIF
    ENDIF
    
    
    
    ; Plot Window
    IF STRMATCH(!D.NAME,'*WIN*',/F) OR STRMATCH(!D.NAME,'*X*',/F) THEN BEGIN
        IF N_ELEMENTS(WindowId) EQ 0 THEN WindowId=1
        Window, WindowId, TITLE=WindowTitle, XSIZE=Dimensions[0], YSIZE=Dimensions[1]
    ENDIF
    
    
    
    ; Plot Frame
    PLOT, [0.0], [0.0],  POSITION=Position,XMargin=XMargin,YMargin=YMargin,/NoData,/NoErase,$ ; /NoErase
                         XTHICK    = SELF->xThick(),   $
                         YTHICK    = SELF->yThick(),   $
                         XCHARSIZE = SELF->xTicksCharSize(), $
                         YCHARSIZE = SELF->yTicksCharSize(), $
                         CHARTHICK = SELF->xTicksCharThick(),$
                            XTICKS = SELF->xMajor(),   $
                            YTICKS = SELF->yMajor(),   $
                            XTICKV = SELF->xTicksValueArray(),   $
                            YTICKV = SELF->yTicksValueArray(),   $
                         XTICKNAME = XTICKNAME,   $
                         YTICKNAME = YTICKNAME,   $
                         XTICKLEN  = SELF->xTickLen(), $
                         YTICKLEN  = SELF->yTickLen(), $
                       XTICKFORMAT = XTICKFORMAT, $
                       YTICKFORMAT = YTICKFORMAT, $
                         XStyle    = SELF->xStyle(),   $
                         YStyle    = SELF->yStyle(),   $
                         XMinor    = SELF->xMinor(),   $
                         YMinor    = SELF->yMinor(),   $
                  XTICKINTERVAL    = SELF->xIntev(),   $
                  YTICKINTERVAL    = SELF->yIntev(),   $
                         XRange    = SELF->xRange(),   $
                         YRange    = SELF->yRange(),   $
                         XLog      = SELF->xLog(),     $
                         YLog      = SELF->yLog(),     $
                         XTICK_GET = XTICK_GET, $ ; <20160517><dzliu>
                         YTICK_GET = YTICK_GET, $ ; <20160517><dzliu>
                         FONT      = 1
    
    ;; Fix Log Axis Major label problem
;    IF SELF->xLog() EQ 1 AND N_ELEMENTS(SELF->xTicksValueArray()) GT 0 THEN BEGIN
;        PRINT, SELF->xTicksValueArray()
;        PRINT, SELF->xMajor()
;    ENDIF
    
    ;; Plot main title
    IF STRTRIM(SELF->title(),2) NE '' THEN BEGIN
        XYOUTS, !X.Window[0] + SELF->titlePosition(0) * (!X.Window[1]-!X.Window[0]), $
                !Y.Window[0] + SELF->titlePosition(1) * (!Y.Window[1]-!Y.Window[0]), $
                SELF->title(), /NORMAL, ALIGNMENT=0.5, CHARSIZE=SELF->titleCharSize(), CHARTHICK=SELF->titleCharThick(), FONT=1
    ENDIF
    ;; Plot X title
    IF N_ELEMENTS(ShowXTicks) EQ 0 OR KEYWORD_SET(ShowXTicks) EQ 1 THEN BEGIN
      IF STRTRIM(SELF->xTitle(),2) NE '' THEN BEGIN
        XTitlePosX = !X.Window[0] + SELF->xTitleAlignment() * (!X.Window[1]-!X.Window[0])
        XTitlePosY = 0.025
        XYOUTS, XTitlePosX, XTitlePosY, $
                SELF->xTitle(), /NORMAL, ALIGNMENT=0.5, CHARSIZE=SELF->xTitleCharSize(), CHARTHICK=SELF->xTitleCharThick(), FONT=1
      ENDIF
    ENDIF
    ;; Plot Y title
    IF N_ELEMENTS(ShowYTicks) EQ 0 OR KEYWORD_SET(ShowYTicks) EQ 1 THEN BEGIN
      IF STRTRIM(SELF->yTitle(),2) NE '' THEN BEGIN
        YTitlePosX = 0.035
        YTitlePosY = !Y.Window[0] + SELF->yTitleAlignment() * (!Y.Window[1]-!Y.Window[0])
        XYOUTS, YTitlePosX, YTitlePosY, ORIENTATION=90, $
                SELF->yTitle(), /NORMAL, ALIGNMENT=0.5, CHARSIZE=SELF->yTitleCharSize(), CHARTHICK=SELF->yTitleCharThick(), FONT=1
      ENDIF
    ENDIF
    ;; Plot Y2 axis
    IF N_ELEMENTS(SELF->rRange()) EQ 2 THEN BEGIN
        AXIS,   YAxis = 1, SAVE = 0, YTHICK = SELF->yThick(), CHARSIZE = SELF->yTicksCharSize(), CHARTHICK = SELF->yTicksCharThick(),$
                YStyle = SELF->rStyle(), YRange = SELF->rRange(), YTICKFORMAT = SELF->rTicksFormat(), YLog = SELF->rLog()
            ;   YTICKLEN = SELF->yTickLen()
    ENDIF
    ;; Plot Y2 title
    IF STRTRIM(SELF->rTitle(),2) NE '' THEN BEGIN
        YTitlePosX = 0.97
        YTitlePosY = !Y.Window[0] + SELF->yTitleAlignment() * (!Y.Window[1]-!Y.Window[0])
        XYOUTS, YTitlePosX, YTitlePosY, ORIENTATION=-90, $
                SELF->rTitle(), /NORMAL, ALIGNMENT=0.5, CHARSIZE=SELF->yTitleCharSize(), CHARTHICK=SELF->yTitleCharThick(), FONT=1
    ENDIF
    
    
    
    ; Prepare arrays for legend
    LegendUniqueIndex = [] ; UNIQ((SELF->symType()))
    LegendSymTypes = []
    LegendSymSizes = []
    LegendSymFills = []
    LegendPtColors = []
    LegendPtThicks = []
    LegendPtUppers = []
    
    
    
    ; Plot data points
    DataPointCount = SELF->count()
    ValidPointCount = 0
    DetectedPointCount = 0
    UndetectPointCount = 0
    OutRangePointCount = 0
    XUpLimitPointCount = 0
    YUpLimitPointCount = 0
    FOR DPId = 0, DataPointCount-1 DO BEGIN
        XValue  = (SELF->xValue())[DPId:DPId]
        YValue  = (SELF->yValue())[DPId:DPId]
        XError  = (SELF->xError())[DPId:DPId]
        YError  = (SELF->yError())[DPId:DPId]
        SymSize = (SELF->symSize(DPId))
        SymType = (SELF->symType(DPId))
        SymFill = (SELF->symFill(DPId))
        PtThick = (SELF->ptThick(DPId))
        PtColor = (SELF->ptColor(DPId))
        PtLabel = (SELF->ptLabel(DPId))
        PtLSize = (SELF->PtLabelSize())[DPId:DPId]
        PtLThic = (SELF->ptLabelThick())[DPId:DPId]
        PtLRota = (SELF->ptLabelRotation())[DPId:DPId]
        PtNote  = (SELF->ptNote())[DPId:DPId]
        AddVar1 = (SELF->AddVar1())[DPId:DPId]
        AddVar2 = (SELF->AddVar2())[DPId:DPId]
        AddVar3 = (SELF->AddVar3())[DPId:DPId]
        AddVar4 = (SELF->AddVar4())[DPId:DPId]
        AddVar5 = (SELF->AddVar5())[DPId:DPId]
        AddVar6 = (SELF->AddVar6())[DPId:DPId]
        
        ; silent
        IF NOT KEYWORD_SET(Silent) THEN BEGIN
            StrPrint = STRING(FORMAT='(A-0," ",A-20,"X ",E-10.3,"(+-)",E-12.3,"Y ",E-10.3,"(+-)",E-12.3,"C ",F0.3)',SELF->title(),PtLabel,XValue,XError,YValue,YError,PtColor)
            IF PtLabel NE "" THEN StrPrint = StrPrint+" S "+PtLabel
            IF KEYWORD_SET(ShowPtNote) THEN StrPrint = StrPrint + " " + " " + PtNote + " "
            PRINT, 'CrabFigureDataStructure::doPlot: ' + StrPrint
        ENDIF
        
        ; convert BYTE PtColor into RGB color with RainbowTable and ColorRange(CRange) (REVERSEd the Rainbow Color Here!)
        IF SELF->cRange() NE !NULL THEN BEGIN
            CRange = SELF->cRange()
            IF CRange[1] GE CRange[0] THEN BEGIN
                PtColorRGB = [ RainbowTable[BYTSCL(PtColor,MAX=CRange[1],MIN=CRange[0],/NAN),0], $
                               RainbowTable[BYTSCL(PtColor,MAX=CRange[1],MIN=CRange[0],/NAN),1], $
                               RainbowTable[BYTSCL(PtColor,MAX=CRange[1],MIN=CRange[0],/NAN),2]  ]
            ENDIF ELSE BEGIN
                PtColorRGB = [ RainbowTable[255-BYTSCL(PtColor,MAX=CRange[0],MIN=CRange[1],/NAN),0], $
                               RainbowTable[255-BYTSCL(PtColor,MAX=CRange[0],MIN=CRange[1],/NAN),1], $
                               RainbowTable[255-BYTSCL(PtColor,MAX=CRange[0],MIN=CRange[1],/NAN),2]  ]
            ENDELSE
            PtColor = cgColor24(PtColorRGB)
        ENDIF ELSE BEGIN
            ;PtColor = cgColor(PtColorBYT) ; PtColor 0~255 (?)
        ENDELSE
        
        
        ; get uniqueness for legend symbols plot
        LegendUniqueCheck = 0
        IF N_ELEMENTS(LegendUniqueIndex) EQ 0 THEN BEGIN
            LegendUniqueCheck = 1
        ENDIF ELSE BEGIN
            IF N_ELEMENTS(WHERE(LegendSymTypes EQ SymType, /NULL)) EQ 0 OR $
               N_ELEMENTS(WHERE(LegendSymFills EQ SymFill, /NULL)) EQ 0 OR $
               N_ELEMENTS(WHERE(LegendPtColors EQ PtColor, /NULL)) EQ 0 THEN BEGIN
                LegendUniqueCheck = 1
            ENDIF
        ENDELSE
        IF LegendUniqueCheck EQ 1 THEN BEGIN
            LegendUniqueIndex = [LegendUniqueIndex, DPId]
            LegendSymTypes = [LegendSymTypes, SymType]
            LegendSymSizes = [LegendSymSizes, SymSize]
            LegendSymFills = [LegendSymFills, SymFill]
            LegendPtColors = [LegendPtColors, PtColor]
            LegendPtThicks = [LegendPtThicks, PtThick]
            LegendPtUppers = [LegendPtUppers, 0]
        ENDIF
        
        
        ; convert STRING SymType for PLOT or PLOT_Procedure <TODO>
        ; IF STRMATCH(SymType,'*DOWN*TRIANGLE',/F) THEN BEGIN
        ;     PRINT, 'DEBUG!SymType@!'
        ; ENDIF
        SymType = CrabSymbol(SymType,FILLED=SymFill,COLOR=PtColor,THICK=PtThick) ;<Corrected><20140327:00><DZLIU> PtThick!
        
        
        ; plot each data point
;       IF XValue GT 0.0 AND YValue GT 0.0 THEN BEGIN ; <TODO> ; <20140319> ;
        IF FINITE(XValue) AND FINITE(YValue) THEN BEGIN
            
            
            ; CheckPlotRange
            IF XValue LT (SELF->xRange())[0] OR YValue LT (SELF->yRange())[0] OR $
               XValue GT (SELF->xRange())[1] OR YValue GT (SELF->yRange())[1] THEN BEGIN
                OutRangePointCount++
                CONTINUE ; do not plot out-side data points
            ENDIF
            
            
            ; ShowErrorBar
            DoShowErrorBar = 0 ; defaultly we do not show errorbar <TODO>
            IF N_ELEMENTS(ShowErrorBar) GT 0 THEN BEGIN
                IF SIZE(ShowErrorBar,/TNAME) EQ 'STRING' THEN BEGIN
                    IF CrabStringMatch(ShowErrorBar,PtLabel,/YES_OR_NO) THEN BEGIN
                        DoShowErrorBar = 1
                    ENDIF
                ENDIF ELSE BEGIN
                    DoShowErrorBar = KEYWORD_SET(ShowErrorBar)
                ENDELSE
            ENDIF
            
            
            ; ShowUpLimit
            DoShowUpLimit = 0 ; initilize the parameter DoShowUpLimit <TODO>
            IF (TOTAL(SELF->xError())+TOTAL(SELF->yError())) EQ 0.0 THEN BEGIN
                DoShowUpLimit = 0 ; if input data do not contain error info, then do not show uplimits (upper limits)
            ENDIF ELSE BEGIN
                IF XError LE 0.0 THEN BEGIN ; <TODO>    LE 0.0    LT 0.0
                    IF YError LE 0.0 AND NOT KEYWORD_SET(YNoErrorBar) THEN BEGIN
                        DoShowUpLimit = 3 ; Show XY UpLimit
                    ENDIF ELSE BEGIN
                        DoShowUpLimit = 1 ; Show X UpLimit Only
                    ENDELSE
                ENDIF ELSE IF YError LE 0.0 AND NOT KEYWORD_SET(YNoErrorBar) THEN BEGIN
                        DoShowUpLimit = 2 ; Show Y UpLimit Only
                ENDIF
            ENDELSE
            
            
            ; PlotErrorBar
            IF DoShowUpLimit EQ 0 THEN BEGIN
                
;                OPLOT,XValue,YValue,PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,THICK=PtThick
;                DetectedPointCount++
                 
                 IF DoShowErrorBar EQ 1 THEN BEGIN
                     IF KEYWORD_SET(XNoErrorBar) THEN BEGIN
                         OPLOTERROR, XValue, YValue, YError, $
                                     PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,$ ; 
                                     THICK=PtThick,ERRTHICK=PtThick,HATLENGTH=!D.X_VSIZE/360 ;,ERRCOLOR=PtColor,_EXTRA={COLOR:PtColor}
                     ENDIF ELSE BEGIN
                         OPLOTERROR, XValue, YValue, XError, YError, $
                                     PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,$ ; 
                                     THICK=PtThick,ERRTHICK=PtThick,HATLENGTH=!D.X_VSIZE/360 ;,ERRCOLOR=PtColor,_EXTRA={COLOR:PtColor}
                     ENDELSE
                 ENDIF ELSE BEGIN
                     OPLOT,      XValue, YValue, $
                                 PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,$
                                 THICK=PtThick
                 ENDELSE
                 
                 DetectedPointCount++ ; Solid Detection
                 
;                IF XError GT 0.0 AND YError GT 0.0 THEN BEGIN                                                           ; Both XYError
;                    DetectedPointCount++
;                ENDIF ELSE IF XError LE 0.0 AND YError GT 0.0 AND NOT KEYWORD_SET(YNoErrorBar) THEN BEGIN               ; Only YError
;                    UndetectPointCount++
;                ENDIF ELSE IF XError LE 0.0 AND YError GT 0.0 AND     KEYWORD_SET(YNoErrorBar) THEN BEGIN               ; Only YError
;                    DetectedPointCount++
;                ENDIF ELSE IF XError GT 0.0 AND YError LE 0.0 THEN BEGIN                                                ; Only XError (undetection)
;                    UndetectPointCount++
;                ENDIF ELSE IF XError LE 0.0 AND YError LE 0.0 AND NOT KEYWORD_SET(YNoErrorBar) THEN BEGIN               ; No Error (undetection)
;                    UndetectPointCount++
;                ENDIF ELSE IF XError LE 0.0 AND YError LE 0.0 AND     KEYWORD_SET(YNoErrorBar) THEN BEGIN               ; No Error (undetection)
;                    UndetectPointCount++
;                ENDIF
                
            ENDIF ELSE BEGIN
;                IF XError GT 0.0 AND YError GT 0.0 THEN BEGIN                                                           ; Both XYError
;                    OPLOTERROR, XValue, YValue, XError, YError, $                                                       ; Solid Detection
;                                        PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,THICK=PtThick,HATLENGTH=!D.X_VSIZE/360
;                    DetectedPointCount++
;                ENDIF ELSE IF XError LE 0.0 AND YError GT 0.0 AND NOT KEYWORD_SET(YNoErrorBar) THEN BEGIN               ; Only YError
;                    OPLOTERROR, XValue, YValue, YError, $                                                               ; Show YErrorBar
;                                        PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,THICK=PtThick,HATLENGTH=!D.X_SIZE/360
;                    UndetectPointCount++
;                ENDIF ELSE IF XError LE 0.0 AND YError GT 0.0 AND     KEYWORD_SET(YNoErrorBar) THEN BEGIN               ; Only YError
;                    OPLOT,XValue,YValue,PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,THICK=PtThick                        ; Do Not Show YErrorBar
;                    DetectedPointCount++
;                ENDIF ELSE IF XError GT 0.0 AND YError LE 0.0 THEN BEGIN                                                ; Only XError (undetection)
;                    OPLOT,XValue,YValue,PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,THICK=PtThick                        ; Show XErrorBar
;                    UndetectPointCount++
;                ENDIF ELSE IF XError LE 0.0 AND YError LE 0.0 AND NOT KEYWORD_SET(YNoErrorBar) THEN BEGIN               ; No Error (undetection)
;                    OPLOT,XValue,YValue,PSYM=SymType,COLOR=PtColor,SYMSIZE=SymSize,THICK=PtThick                        ; Show XYUpLimit
;                    UndetectPointCount++
;                ENDIF ELSE IF XError LE 0.0 AND YError LE 0.0 AND     KEYWORD_SET(YNoErrorBar) THEN BEGIN               ; No Error (undetection)
;                    ; USERSYM,[-1.3,-1.3,1.3,1.3],[-0.07,0.07,0.07,-0.07],COLOR=PtColor,THICK=PtThick,/FILL               ; Show XUpLimit
;                    ; OPLOT,XValue,YValue,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick                          ; Show XUpLimit
;                    ; UndetectPointCount++
;                ENDIF
            ENDELSE
            
            
            ; PlotUpLimit
            IF DoShowUpLimit GT 0 THEN BEGIN
                mArL = 3.0  ;; arrow root-to-top height/length
                mArS = 2.8  ;; arrow root-to-hat height/length
                mArH = 1.5  ;; arrow root-to-shouder height/length 
                mArW = 0.6  ;; arrow shouder width
                mArT = 0.02 ;; arrow root thick
                IF DoShowUpLimit EQ 3 THEN BEGIN                                                                                               ; Left-Down Arrow Symbol
                    USERSYM,[-0.06,-3.26,-2.8,-3.5,-1.0,-3.14,+0.04],[+0.06,-3.14,-1.0,-3.5,-2.8,-3.26,-0.06],COLOR=PtColor,THICK=PtThick*0.11 ; Left-Down Arrow Symbol /FILL
                    OPLOT,XValue,YValue,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                            ; Show XYUpLimit
                    XUpLimitPointCount++
                    YUpLimitPointCount++
                ENDIF ELSE IF DoShowUpLimit EQ 2 THEN BEGIN                                                                                 ; Down Arrow Symbol
                    USERSYM,[-1.3,-1.3,1.3,1.3],[-0.07,0.07,0.07,-0.07],COLOR=PtColor,THICK=PtThick*0.11,/FILL                              ; Down Arrow Symbol
                    OPLOT,XValue,YValue,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                         ; Down Arrow Symbol
                    USERSYM,[-mArT,-mArT,-mArW,+0,+mArW,+mArT,+mArT],[+0,-mArS,-mArH,-mArL,-mArH,-mArS,+0],COLOR=PtColor,THICK=PtThick*0.11 ; Down Arrow Symbol /FILL
                    OPLOT,XValue,YValue,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                         ; Show YUpLimit
                    YUpLimitPointCount++
                ENDIF ELSE IF DoShowUpLimit EQ 1 THEN BEGIN                                                                                 ; Left Arrow Symbol
                   ;USERSYM,[-0.07,0.07,0.07,-0.07],[-1.3,-1.3,1.3,1.3],COLOR=PtColor,THICK=PtThick*0.11,/FILL                              ; Left Arrow Symbol
                   ;OPLOT,XValue,YValue,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                         ; Left Arrow Symbol
                   ;USERSYM,[+0,-mArS,-mArH,-mArL,-mArH,-mArS,+0],[-mArT,-mArT,-mArW,+0,+mArW,+mArT,+mArT],COLOR=PtColor,THICK=PtThick*0.11 ; Left Arrow Symbol /FILL
                    USERSYM,[0,0],[+mArW,-mArW],COLOR=PtColor,THICK=PtThick*0.11                                                            ; Show XUpLimit
                    OPLOT,XValue,YValue,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                         ; Show XUpLimit
                    USERSYM,[+0,-mArS],[0,0],COLOR=PtColor,THICK=PtThick*0.11                                                               ; Show XUpLimit
                    OPLOT,XValue,YValue,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                         ; Show XUpLimit
                    USERSYM,[-mArH,-mArS,-mArH],[+mArW,0,-mArW],COLOR=PtColor,THICK=PtThick*0.11                                            ; Show XUpLimit
                    OPLOT,XValue,YValue,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                         ; Show XUpLimit
                    XUpLimitPointCount++
                ENDIF
                UndetectPointCount++
            ENDIF
            
            
            ; ShowPtLabel & PlotPtLabel
            IF KEYWORD_SET(ShowPtLabel) AND N_ELEMENTS(PtLabel) GE 1 THEN BEGIN                                         ; PtLabel=GalaxyName
                IF SIZE(ShowPtLabel,/TNAME) EQ 'STRING' THEN BEGIN ; ShowPtLabel can be ['NGC6240','M82',...]
                    IF NOT CrabStringMatch(STRTRIM(PtLabel,2),ShowPtLabel,/FOLD_CASE,/YES_OR_NO) THEN PtLabel = ''
                ENDIF
                IF STRLEN(STRTRIM(PtLabel,2)) GT 0 THEN BEGIN
                    XYOUTS,XValue,YValue,PtLabel,/DATA,COLOR=PtColor,CHARSIZE=PtLSize,CHARTHICK=PtLThic,ORIEN=PtLRota,ALIGN=0.0
                ENDIF
            ENDIF
            
            
            ; get uniqueness for legend symbols plot
            IF LegendUniqueCheck EQ 1 THEN BEGIN
                LegendPtUppers[N_ELEMENTS(LegendPtUppers)-1] = DoShowUpLimit
            ENDIF
            
            
            ValidPointCount++
            
        ENDIF
    ENDFOR
    
    
    
    ; Print the number of valid data points
    PRINT, 'CrabFigureOnePanelPlotProcedure: ' + SELF->title() + $
           ' has plotted ' + STRING(ValidPointCount,FORMAT='(I0)') + ' valid data points. ' + $
                             STRING(DetectedPointCount,FORMAT='("(",I0," detected",")")') + ' ' + $
                             STRING(UndetectPointCount,FORMAT='("(",I0," undetected",")")') + ' ' + $
                             STRING(OutRangePointCount,FORMAT='("(",I0," out of range",")")')
    
    
    
    ; Plot color bar
    IF ValidPointCount GT 0 AND STRTRIM(SELF->cTitle(),2) NE '' AND SELF->cRange() NE !NULL THEN BEGIN
            cgColorBar, RANGE = SELF->cRange(), /VERTICAL, /RIGHT, invertcolors=SetColorReverse, $
                        FORMAT = SELF->colorBarFormat(), $
                        CHARSIZE = SELF->colorBarCharSize(), $
                        CHARTHICK = SELF->colorBarCharThick(), $
                        POSITION = [ !X.Window[0] + SELF->colorBarPosition(0) * (!X.Window[1]-!X.Window[0]), $
                                     !Y.Window[0] + SELF->colorBarPosition(1) * (!Y.Window[1]-!Y.Window[0]), $
                                     !X.Window[0] + SELF->colorBarPosition(2) * (!X.Window[1]-!X.Window[0]), $
                                     !Y.Window[0] + SELF->colorBarPosition(3) * (!Y.Window[1]-!Y.Window[0])  ]
            XYOUTS, !X.Window[0] + SELF->cTitlePosition(0) * (!X.Window[1]-!X.Window[0]), $ 
                    !Y.Window[0] + SELF->cTitlePosition(1) * (!Y.Window[1]-!Y.Window[0]), $ 
                    SELF->cTitle(), /NORMAL, ALIGNMENT=0.5, CHARSIZE=SELF->cTitleCharSize(), CHARTHICK=SELF->cTitleCharThick()
    ENDIF
    
    
    
    ; Plot Annotations
    AnnotationCount = N_ELEMENTS(*(SELF.Annotations))
    FOR ANId = 0, AnnotationCount-1 DO BEGIN
        ; Check Annotation Data Strucuture
        ; PRINT, tag_names(OneAnnotation,/STRUCTURE_NAME)
        AnnotationData = (*(SELF.Annotations))[ANId]
        AnnoColor = AnnotationData.Color
        IF N_ELEMENTS(CRange) EQ 2 THEN BEGIN
            TempColorMIN = MIN(CRange)
            TempColorMAX = MAX(CRange)
            TempColorREX = (CRange[1] LT CRange[0])
            TempColorREV = 2*(CRange[1] GT CRange[0])-1 ;
            AnnoColorRGB = [ RainbowTable[TempColorREX*255+TempColorREV*BYTSCL(AnnotationData.Color,MAX=TempColorMAX,MIN=TempColorMIN,/NAN),0], $
                             RainbowTable[TempColorREX*255+TempColorREV*BYTSCL(AnnotationData.Color,MAX=TempColorMAX,MIN=TempColorMIN,/NAN),1], $
                             RainbowTable[TempColorREX*255+TempColorREV*BYTSCL(AnnotationData.Color,MAX=TempColorMAX,MIN=TempColorMIN,/NAN),2]  ]
            AnnoColor = cgColor24(AnnoColorRGB)
        ENDIF
        XYOUTS, AnnotationData.Position[0], AnnotationData.Position[1], AnnotationData.Text, $
                NORMAL=AnnotationData.Normal, DATA=AnnotationData.Data, COLOR=AnnoColor, $
                CHARSIZE=AnnotationData.CharSize, CHARTHICK=AnnotationData.CharThick, FONT=1, $
                ALIGNMENT=AnnotationData.Alignment, ORIENTATION=AnnotationData.Rotation
    ENDFOR
    
    
    
    ; Plot Polylines
    PolylineCount = N_ELEMENTS(*(SELF.Polylines))
    FOR PLId = 0, PolylineCount-1 DO BEGIN
        PolylineData = (*(SELF.Polylines))[PLId]
        PlotColor = PolylineData.Color
        IF N_ELEMENTS(CRange) EQ 2 THEN BEGIN
            TempColorMIN = MIN(CRange)
            TempColorMAX = MAX(CRange)
            TempColorREX = (CRange[1] LT CRange[0])
            TempColorREV = 2*(CRange[1] GT CRange[0])-1 ;
            PlotColorRGB = [ RainbowTable[TempColorREX*255+TempColorREV*BYTSCL([PolylineData.Color],MAX=TempColorMAX,MIN=TempColorMIN,/NAN),0], $
                             RainbowTable[TempColorREX*255+TempColorREV*BYTSCL([PolylineData.Color],MAX=TempColorMAX,MIN=TempColorMIN,/NAN),1], $
                             RainbowTable[TempColorREX*255+TempColorREV*BYTSCL([PolylineData.Color],MAX=TempColorMAX,MIN=TempColorMIN,/NAN),2]  ]
            PlotColor = cgColor24(PlotColorRGB)
        ENDIF
        OPLOT, PolylineData.XArray, PolylineData.YArray, COLOR=PlotColor, $
               LINESTYLE=PolylineData.Style, THICK=PolylineData.Thick
    ENDFOR
    
    
    
    ; Plot Legend Symbols <20160430>
    LegendUniqueCount = N_ELEMENTS(LegendUniqueIndex)
    LegendUniqueSort = SORT(LegendPtUppers)
    LegendSymTypes = LegendSymTypes[LegendUniqueSort]
    LegendSymSizes = LegendSymSizes[LegendUniqueSort]
    LegendSymFills = LegendSymFills[LegendUniqueSort]
    LegendPtColors = LegendPtColors[LegendUniqueSort]
    LegendPtThicks = LegendPtThicks[LegendUniqueSort]
    LegendPtUppers = LegendPtUppers[LegendUniqueSort]
    LegendLineSpacing = 0.025 * (SELF->legendCharSize())^0.8
    FOR PLId = 0, LegendUniqueCount-1 DO BEGIN
        XValue = [SELF.LegendPositionR[0]] ; [0.225] ; <TODO> Legend Area Position
        YValue = [SELF.LegendPositionR[1]-LegendLineSpacing*PLId] ; [0.775-0.025*PLId] ; <TODO> Legend Area Position
        PtColor = LegendPtColors[PLId]
        PtThick = LegendPtThicks[PLId]
        SymSize = LegendSymSizes[PLId]
        IF SIZE(ShowLegend,/TNAME) EQ 'STRING' AND N_ELEMENTS(ShowLegend) GT PLId THEN BEGIN
          XYOUTS, XValue+0.02, YValue-LegendLineSpacing/5.0, ShowLegend[PLId], /NORMAL, $
                  COLOR=PtColor, CHARSIZE=SELF->legendCharSize(), CHARTHICK=SELF->legendCharThick(), ALIGN=0.0, FONT=1
          ;
          IF LegendPtUppers[PLId] EQ 0 THEN BEGIN
            SymType = CrabSymbol(LegendSymTypes[PLId],FILLED=LegendSymFills[PLId],COLOR=PtColor,THICK=PtThick) ;<Corrected><20140327:00><DZLIU> PtThick!
            PLOTS, XValue, YValue, /NORMAL, PSYM=SymType, SYMSIZE=SymSize, COLOR=PtColor, THICK=PtThick
          ENDIF ELSE BEGIN
            mArL = 3.0  ;; arrow root-to-top height/length
            mArS = 2.8  ;; arrow root-to-hat height/length
            mArH = 1.5  ;; arrow root-to-shouder height/length
            mArW = 0.6  ;; arrow shouder width
            mArT = 0.02 ;; arrow root thick
            IF LegendPtUppers[PLId] EQ 3 THEN BEGIN                                                                                        ; Left-Down Arrow Symbol
                USERSYM,[-0.06,-3.26,-2.8,-3.5,-1.0,-3.14,+0.04],[+0.06,-3.14,-1.0,-3.5,-2.8,-3.26,-0.06],COLOR=PtColor,THICK=PtThick*0.11 ; Left-Down Arrow Symbol /FILL
                PLOTS,XValue,YValue,/NORMAL,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                    ; Show XYUpLimit
            ENDIF ELSE IF LegendPtUppers[PLId] EQ 2 THEN BEGIN                                                                             ; Down Arrow Symbol
                USERSYM,[-1.3,-1.3,1.3,1.3],[-0.07,0.07,0.07,-0.07],COLOR=PtColor,THICK=PtThick*0.11,/FILL                                 ; Down Arrow Symbol
                PLOTS,XValue,YValue,/NORMAL,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                    ; Down Arrow Symbol
                USERSYM,[-mArT,-mArT,-mArW,+0,+mArW,+mArT,+mArT],[+0,-mArS,-mArH,-mArL,-mArH,-mArS,+0],COLOR=PtColor,THICK=PtThick*0.11    ; Down Arrow Symbol /FILL
                PLOTS,XValue,YValue,/NORMAL,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                    ; Show YUpLimit
            ENDIF ELSE IF LegendPtUppers[PLId] EQ 1 THEN BEGIN                                                                             ; Left Arrow Symbol
                USERSYM,[0,0],[+mArW,-mArW],COLOR=PtColor,THICK=PtThick*0.11                                                               ; Show XUpLimit
                PLOTS,XValue,YValue,/NORMAL,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                    ; Show XUpLimit
                USERSYM,[+0,-mArS],[0,0],COLOR=PtColor,THICK=PtThick*0.11                                                                  ; Show XUpLimit
                PLOTS,XValue,YValue,/NORMAL,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                    ; Show XUpLimit
                USERSYM,[-mArH,-mArS,-mArH],[+mArW,0,-mArW],COLOR=PtColor,THICK=PtThick*0.11                                               ; Show XUpLimit
                PLOTS,XValue,YValue,/NORMAL,PSYM=8,COLOR=PtColor,SYMSIZE=SymSize*0.7,THICK=PtThick*0.11                                    ; Show XUpLimit
            ENDIF
          ENDELSE
        ENDIF
    ENDFOR
    
    
END




















PRO CrabFigureDataStructure::appendDataStructure, AnotherDataStructure
    IF AnotherDataStructure NE !NULL THEN BEGIN
        ; append data points
        *(SELF.DataPoints) = [ *(SELF.DataPoints), AnotherDataStructure->dataPoints() ]
;        DataPointAdded = 0
;        FOR DPId=0,AnotherDataStructure->count()-1 DO BEGIN
;            XValue  = (AnotherDataStructure->xValue())[DPId]
;            YValue  = (AnotherDataStructure->yValue())[DPId]
;            XError  = (AnotherDataStructure->xError())[DPId]
;            YError  = (AnotherDataStructure->yError())[DPId]
;            SymSize = (AnotherDataStructure->symSize())[DPId]
;            SymType = (AnotherDataStructure->symType())[DPId]
;            SymFill = (AnotherDataStructure->symFill())[DPId]
;            PtThick = (AnotherDataStructure->ptThick())[DPId]
;            PtColor = (AnotherDataStructure->ptColor())[DPId]
;            PtLabel = (AnotherDataStructure->ptLabel())[DPId]
;            PtLSize = (AnotherDataStructure->PtLabelSize())[DPId]
;            PtLThic = (AnotherDataStructure->ptLabelThick())[DPId]
;            PtLRota = (AnotherDataStructure->ptLabelRotation())[DPId]
;            PtNote  = (AnotherDataStructure->ptNote())[DPId]
;            AddVar1 = (AnotherDataStructure->AddVar1())[DPId]
;            AddVar2 = (AnotherDataStructure->AddVar2())[DPId]
;            AddVar3 = (AnotherDataStructure->AddVar3())[DPId]
;            AddVar4 = (AnotherDataStructure->AddVar4())[DPId]
;            AddVar5 = (AnotherDataStructure->AddVar5())[DPId]
;            AddVar6 = (AnotherDataStructure->AddVar6())[DPId]
;            PlotDataPoint = { CrabFigureDataStructurePoint, XValue : XValue,  $
;                                                            YValue : YValue,  $
;                                                            XError : XError,  $
;                                                            YError : YError,  $
;                                                           SymSize : SymSize, $
;                                                           SymType : SymType, $
;                                                           SymFill : SymFill, $
;                                                           PtThick : PtThick, $
;                                                           PtColor : PtColor, $
;                                                           PtLabel : PtLabel, $
;                                                           PtLSize : PtLSize, $
;                                                           PtLThic : PtLThic, $
;                                                           PtLRota : PtLRota, $
;                                                            PtNote : PtNote,  $
;                                                           AddVar1 : AddVar1, $
;                                                           AddVar2 : AddVar2, $
;                                                           AddVar3 : AddVar3, $
;                                                           AddVar4 : AddVar4, $
;                                                           AddVar5 : AddVar5, $
;                                                           AddVar6 : AddVar6  }
;            *(SELF.DataPoints) = [ *(SELF.DataPoints), PlotDataPoint ]
;            DataPointAdded = DataPointAdded + 1
;        ENDFOR
        
        ; append annotations
        *(SELF.Annotations) = [ *(SELF.Annotations), AnotherDataStructure->annotations() ]
        
        ; append note
        SELF.Note = SELF.Note + STRING(FORMAT='(A,A,I0,A)', SYSTIME(), $
                                              ' - Appended ', DataPointAdded, $
                                              ' data points from another DataStructure; ')
    ENDIF
    RETURN
END






FUNCTION CrabFigureDataStructure::count
    RETURN, N_ELEMENTS( (*(SELF.DataPoints)) )
END


FUNCTION CrabFigureDataStructure::dataPoints
    RETURN, (*(SELF.DataPoints))
END


FUNCTION CrabFigureDataStructure::annotations
    RETURN, (*(SELF.Annotations))
END


FUNCTION CrabFigureDataStructure::polylines
    RETURN, (*(SELF.Polylines))
END


FUNCTION CrabFigureDataStructure::x, Index
    DataArray = [ (*(SELF.DataPoints)).XValue ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::y, Index
    DataArray = [ (*(SELF.DataPoints)).YValue ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::xValue, Index
    DataArray = [ (*(SELF.DataPoints)).XValue ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::yValue, Index
    DataArray = [ (*(SELF.DataPoints)).YValue ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::xError, Index
    DataArray = [ (*(SELF.DataPoints)).XError ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::yError, Index
    DataArray = [ (*(SELF.DataPoints)).YError ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::symSize, Index
    DataArray = [ (*(SELF.DataPoints)).SymSize ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::symType, Index
    MySymTypes = [ (*(SELF.DataPoints)).SymType ]
    IF N_ELEMENTS(Index) GE 1 THEN MySymTypes = MySymTypes[Index]
   ;IF N_ELEMENTS(Index) EQ 1 THEN MySymTypes = MySymTypes[0]
    FOR SId=0,N_ELEMENTS(MySymTypes)-1 DO BEGIN
        TmSymType = MySymTypes[SId]
        ; IF !D.NAME EQ 'PS' AND STRMATCH(MySymTypes[SId],'*Square*',/FOLD_CASE) THEN MySymTypes[SId]='Filled Square'
        ; IF !D.NAME NE 'PS' AND STRMATCH(MySymTypes[SId],'*Square*',/FOLD_CASE) THEN MySymTypes[SId]='SQUARE'
        IF STRMATCH(TmSymType,'*Square*',/FOLD_CASE) THEN MySymTypes[SId]='SQUARE'
        ; IF !D.NAME EQ 'PS' AND STRMATCH(MySymTypes[SId],'*Circle*',/FOLD_CASE) THEN MySymTypes[SId]='Filled Circle'
        ; IF !D.NAME NE 'PS' AND STRMATCH(MySymTypes[SId],'*Circle*',/FOLD_CASE) THEN MySymTypes[SId]='CIRCLE'
        IF STRMATCH(TmSymType,'*Circle*',/FOLD_CASE) THEN MySymTypes[SId]='CIRCLE'
        IF STRMATCH(TmSymType,'*Circle X*',/FOLD_CASE) THEN MySymTypes[SId]='Circle X'
        ; IF !D.NAME EQ 'PS' AND STRMATCH(MySymTypes[SId],'*triangle*',/FOLD_CASE) THEN MySymTypes[SId]='Filled Triangle'
        ; IF !D.NAME NE 'PS' AND STRMATCH(MySymTypes[SId],'*triangle*',/FOLD_CASE) THEN MySymTypes[SId]='TRIANGLE'
        IF STRMATCH(TmSymType,'*triangle*',/FOLD_CASE) THEN MySymTypes[SId]='TRIANGLE'
        ; IF !D.NAME EQ 'PS' AND STRMATCH(MySymTypes[SId],'*down*triangle*',/FOLD_CASE) THEN MySymTypes[SId]='Down Triangle'
        ; IF !D.NAME NE 'PS' AND STRMATCH(MySymTypes[SId],'*down*triangle*',/FOLD_CASE) THEN MySymTypes[SId]='DOWN TRIANGLE'
        IF STRMATCH(TmSymType,'*down*triangle*',/FOLD_CASE) THEN MySymTypes[SId]='DOWN TRIANGLE'
    ENDFOR
    RETURN, MySymTypes
END


FUNCTION CrabFigureDataStructure::symFill, Index
    MySymFills = [ (*(SELF.DataPoints)).SymFill ]
    IF N_ELEMENTS(Index) GE 1 THEN MySymFills = MySymFills[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN MySymFills = MySymFills[0]
    RETURN, MySymFills
END


FUNCTION CrabFigureDataStructure::ptThick, Index
    DataArray = [ (*(SELF.DataPoints)).PtThick ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::ptColor, Index
    DataArray = [ (*(SELF.DataPoints)).PtColor ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::ptLabel, Index
    DataArray = [ (*(SELF.DataPoints)).PtLabel ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::ptLabelSize, Index
    DataArray = [ (*(SELF.DataPoints)).PtLSize ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::ptLabelThick, Index
    DataArray = [ (*(SELF.DataPoints)).PtLThic ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::ptLabelRotation, Index
    DataArray = [ (*(SELF.DataPoints)).PtLRota ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::ptNote, Index
    DataArray = [ (*(SELF.DataPoints)).PtNote ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::AddVar1, Index
    DataArray = [ (*(SELF.DataPoints)).AddVar1 ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::AddVar2, Index
    DataArray = [ (*(SELF.DataPoints)).AddVar2 ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::AddVar3, Index
    DataArray = [ (*(SELF.DataPoints)).AddVar3 ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::AddVar4, Index
    DataArray = [ (*(SELF.DataPoints)).AddVar4 ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::AddVar5, Index
    DataArray = [ (*(SELF.DataPoints)).AddVar5 ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::AddVar6, Index
    DataArray = [ (*(SELF.DataPoints)).AddVar6 ]
    IF N_ELEMENTS(Index) GE 1 THEN DataArray = DataArray[Index]
    IF N_ELEMENTS(Index) EQ 1 THEN DataArray = DataArray[0]
    RETURN, DataArray
END


FUNCTION CrabFigureDataStructure::xRange
    IF SELF.XRange[1] EQ SELF.XRange[0] THEN RETURN, !NULL
    RETURN,   SELF.XRange
END


FUNCTION CrabFigureDataStructure::yRange
    IF SELF.YRange[1] EQ SELF.YRange[0] THEN RETURN, !NULL
    RETURN,   SELF.YRange
END


FUNCTION CrabFigureDataStructure::xStyle
    IF SELF.XStyle LE 0 THEN RETURN, !NULL
    RETURN,   SELF.XStyle
END


FUNCTION CrabFigureDataStructure::yStyle
    IF SELF.YStyle LE 0 THEN RETURN, !NULL
    RETURN,   SELF.YStyle
END


FUNCTION CrabFigureDataStructure::rStyle
    IF SELF.RStyle LE 0 THEN RETURN, !NULL
    RETURN,   SELF.RStyle
END


FUNCTION CrabFigureDataStructure::xTicksTextArray
    IF N_ELEMENTS(*(SELF.XTicksTextArray)) EQ 0 THEN RETURN, !NULL
    RETURN, (*(SELF.XTicksTextArray))
END 


FUNCTION CrabFigureDataStructure::xTicksValueArray
    IF N_ELEMENTS(*(SELF.XTicksValueArray)) EQ 0 THEN RETURN, !NULL
    RETURN, (*(SELF.XTicksValueArray))
END


FUNCTION CrabFigureDataStructure::xTicksCharThick
    IF SELF.XTicksCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.XTicksCharThick
END


FUNCTION CrabFigureDataStructure::xTicksCharSize
    IF SELF.XTicksCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.XTicksCharSizeF
END


FUNCTION CrabFigureDataStructure::xTicksFormat
    IF STRTRIM(SELF.XTicksFormatSTR,2) EQ '' THEN RETURN, !NULL
    RETURN, STRTRIM(SELF.XTicksFormatSTR)
END 
    
    
FUNCTION CrabFigureDataStructure::xTickFormat
    IF STRTRIM(SELF.XTicksFormatSTR,2) EQ '' THEN RETURN, !NULL
    RETURN, STRTRIM(SELF.XTicksFormatSTR)
END


FUNCTION CrabFigureDataStructure::yTicksTextArray
    IF N_ELEMENTS(*(SELF.YTicksTextArray)) EQ 0 THEN RETURN, !NULL
    RETURN, (*(SELF.YTicksTextArray))
END 


FUNCTION CrabFigureDataStructure::yTicksValueArray
    IF N_ELEMENTS(*(SELF.YTicksValueArray)) EQ 0 THEN RETURN, !NULL
    RETURN, (*(SELF.YTicksValueArray))
END


FUNCTION CrabFigureDataStructure::yTicksCharThick
    IF SELF.YTicksCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.YTicksCharThick
END


FUNCTION CrabFigureDataStructure::yTicksCharSize
    IF SELF.YTicksCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.YTicksCharSizeF
END


FUNCTION CrabFigureDataStructure::yTicksFormat
    IF STRTRIM(SELF.YTicksFormatSTR,2) EQ '' THEN RETURN, !NULL
    RETURN, STRTRIM(SELF.YTicksFormatSTR)
END 


FUNCTION CrabFigureDataStructure::yTickFormat
    IF STRTRIM(SELF.YTicksFormatSTR,2) EQ '' THEN RETURN, !NULL
    RETURN, STRTRIM(SELF.YTicksFormatSTR)
END


FUNCTION CrabFigureDataStructure::rTicksTextArray
    IF N_ELEMENTS(*(SELF.RTicksTextArray)) EQ 0 THEN RETURN, !NULL
    RETURN, (*(SELF.RTicksTextArray))
END


FUNCTION CrabFigureDataStructure::rTicksCharThick
    IF SELF.RTicksCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.RTicksCharThick
END


FUNCTION CrabFigureDataStructure::rTicksCharSize
    IF SELF.RTicksCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.RTicksCharSizeF
END


FUNCTION CrabFigureDataStructure::rTicksFormat
    IF STRTRIM(SELF.RTicksFormatSTR,2) EQ '' THEN RETURN, !NULL
    RETURN, STRTRIM(SELF.RTicksFormatSTR)
END 
    
    
FUNCTION CrabFigureDataStructure::xMajor
    IF SELF.XMajor LE 0 THEN RETURN, !NULL
    RETURN, SELF.XMajor
END


FUNCTION CrabFigureDataStructure::yMajor
    IF SELF.YMajor LE 0 THEN RETURN, !NULL
    RETURN, SELF.YMajor
END


FUNCTION CrabFigureDataStructure::xMinor
    IF SELF.XMinor LT 0 THEN RETURN, !NULL
    RETURN, SELF.XMinor
END


FUNCTION CrabFigureDataStructure::yMinor
    IF SELF.YMinor LT 0 THEN RETURN, !NULL
    RETURN, SELF.YMinor
END


FUNCTION CrabFigureDataStructure::xIntev
    IF SELF.XIntev LE 0.0 THEN RETURN, !NULL
    RETURN, SELF.XIntev
END


FUNCTION CrabFigureDataStructure::yIntev
    IF SELF.YIntev LE 0.0 THEN RETURN, !NULL
    RETURN, SELF.YIntev
END


FUNCTION CrabFigureDataStructure::xTickLen
    IF SELF.XTkLen LE 0.0 THEN RETURN, !NULL
    RETURN, SELF.XTkLen
END


FUNCTION CrabFigureDataStructure::yTickLen
    IF SELF.YTkLen LE 0.0 THEN RETURN, !NULL
    RETURN, SELF.YTkLen
END


FUNCTION CrabFigureDataStructure::xThick
    IF SELF.XThick LE 0.0 THEN RETURN, !NULL
    RETURN, SELF.XThick
END


FUNCTION CrabFigureDataStructure::yThick
    IF SELF.YThick LE 0.0 THEN RETURN, !NULL
    RETURN, SELF.YThick
END


FUNCTION CrabFigureDataStructure::rRange
    IF SELF.RRange[1] EQ SELF.RRange[0] THEN RETURN, !NULL
    RETURN, SELF.RRange
END


FUNCTION CrabFigureDataStructure::cRange
    IF SELF.CRange[1] EQ SELF.CRange[0] THEN RETURN, !NULL
    RETURN, SELF.CRange
END


FUNCTION CrabFigureDataStructure::title
    RETURN, SELF.TitleText
END


FUNCTION CrabFigureDataStructure::titleText
    RETURN, SELF.TitleText
END


FUNCTION CrabFigureDataStructure::titlePosition, xory
    IF N_ELEMENTS(xory) EQ 1 THEN BEGIN
        IF xory EQ 0 THEN RETURN, SELF.TitlePositionR[0]
        IF xory EQ 1 THEN RETURN, SELF.TitlePositionR[1]
        IF xory NE 0 AND xory NE 1 THEN RETURN, !NULL
    ENDIF
    RETURN, SELF.TitlePositionR
END


FUNCTION CrabFigureDataStructure::titleCharSize
    IF SELF.TitleCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.TitleCharSizeF
END


FUNCTION CrabFigureDataStructure::titleCharThick
    IF SELF.TitleCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.TitleCharThick
END


FUNCTION CrabFigureDataStructure::xTitle, IncludeUnit=IncludeUnit
    XTitleText = SELF.XTitleText
    IF N_ELEMENTS(IncludeUnit) EQ 0 THEN IncludeUnit = 1 ; IncludeUnit defaultly
    IF KEYWORD_SET(IncludeUnit) AND SELF.XUnits NE '' THEN $
        XTitleText = SELF.XTitleText + ' [' + SELF.XUnits + '] '
    RETURN, XTitleText
END


FUNCTION CrabFigureDataStructure::xTitleCharThick
    IF SELF.XTitleCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.XTitleCharThick
END


FUNCTION CrabFigureDataStructure::xTitleCharSize
    IF SELF.XTitleCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.XTitleCharSizeF
END


FUNCTION CrabFigureDataStructure::xTitleAlignment
    IF SELF.XTitleAlignment LT 0 THEN RETURN, !NULL
    RETURN, SELF.XTitleAlignment
END


FUNCTION CrabFigureDataStructure::yTitle, IncludeUnit=IncludeUnit
    YTitleText = SELF.YTitleText
    IF N_ELEMENTS(IncludeUnit) EQ 0 THEN IncludeUnit = 1 ; IncludeUnit defaultly
    IF KEYWORD_SET(IncludeUnit) AND SELF.YUnits NE '' THEN $
        YTitleText = SELF.YTitleText + ' [' + SELF.YUnits + '] '
    RETURN, YTitleText
END


FUNCTION CrabFigureDataStructure::yTitleCharThick
    IF SELF.YTitleCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.YTitleCharThick
END


FUNCTION CrabFigureDataStructure::yTitleCharSize
    IF SELF.YTitleCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.YTitleCharSizeF
END


FUNCTION CrabFigureDataStructure::yTitleAlignment
    IF SELF.YTitleAlignment LT 0 THEN RETURN, !NULL
    RETURN, SELF.YTitleAlignment
END


FUNCTION CrabFigureDataStructure::cTitle
    CTitleText = SELF.CTitleText
    RETURN, CTitleText
END


FUNCTION CrabFigureDataStructure::cTitleCharThick
    IF SELF.CTitleCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.CTitleCharThick
END


FUNCTION CrabFigureDataStructure::cTitleCharSize
    IF SELF.CTitleCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.CTitleCharSizeF
END 
    
    
FUNCTION CrabFigureDataStructure::colorBarCharThick
    IF SELF.ColBarCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.ColBarCharThick
END


FUNCTION CrabFigureDataStructure::colorBarCharSize
    IF SELF.ColBarCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.ColBarCharSizeF
END


FUNCTION CrabFigureDataStructure::legendCharThick
    IF SELF.LegendCharThick LE 0 THEN RETURN, !NULL
    RETURN, SELF.LegendCharThick
END


FUNCTION CrabFigureDataStructure::legendCharSize
    IF SELF.LegendCharSizeF LE 0 THEN RETURN, !NULL
    RETURN, SELF.LegendCharSizeF
END 
    
    
FUNCTION CrabFigureDataStructure::legendPosition, xory
    IF N_ELEMENTS(xory) EQ 1 THEN BEGIN
        IF xory EQ 0 THEN RETURN, SELF.LegendPositionR[xory]
        IF xory EQ 1 THEN RETURN, SELF.LegendPositionR[xory]
        IF xory NE 0 AND xory NE 1 THEN RETURN, !NULL
    ENDIF
    RETURN, SELF.LegendPositionR
END


FUNCTION CrabFigureDataStructure::colorBarFormat
    IF STRTRIM(SELF.ColBarFormatSTR,2) EQ '' THEN RETURN, !NULL
    RETURN, STRTRIM(SELF.ColBarFormatSTR)
END


FUNCTION CrabFigureDataStructure::cTitlePosition, xory
    IF N_ELEMENTS(xory) EQ 1 THEN BEGIN
        IF xory EQ 0 THEN RETURN, SELF.CTitlePositionR[xory]
        IF xory EQ 1 THEN RETURN, SELF.CTitlePositionR[xory]
        IF xory NE 0 AND xory NE 1 THEN RETURN, !NULL
    ENDIF
    RETURN, SELF.CTitlePositionR
END


FUNCTION CrabFigureDataStructure::colorBarPosition, index
    IF N_ELEMENTS(index) EQ 1 THEN BEGIN
        IF index GE 0 AND index LE 3 THEN RETURN, SELF.ColorBarPosRect[index] ELSE RETURN, !NULL
    ENDIF
    RETURN, SELF.ColorBarPosRect
END


FUNCTION CrabFigureDataStructure::rTitle
    RTitleText = SELF.RTitleText
    RETURN, RTitleText
END


FUNCTION CrabFigureDataStructure::xUnits
    RETURN,   SELF.XUnits
END


FUNCTION CrabFigureDataStructure::yUnits
    RETURN,   SELF.YUnits
END


FUNCTION CrabFigureDataStructure::xLog
    RETURN,   SELF.XLog
END


FUNCTION CrabFigureDataStructure::yLog
    RETURN,   SELF.YLog
END


FUNCTION CrabFigureDataStructure::rLog
    RETURN,   SELF.RLog
END


FUNCTION CrabFigureDataStructure::cLog
    RETURN,   SELF.CLog
END


FUNCTION CrabFigureDataStructure::note
    RETURN,   SELF.Note
END


FUNCTION CrabFigureDataStructure::version
    RETURN,   SELF.Version
END


PRO CrabFigureDataStructure::clearDataPoints
    *(SELF.DataPoints) = []
    RETURN
END


PRO CrabFigureDataStructure::CLEANUP
    PTR_FREE, SELF.DataPoints
    PTR_FREE, SELF.Annotations
    PTR_FREE, SELF.Polylines
    PTR_FREE, SELF.XTicksTextArray
    PTR_FREE, SELF.YTicksTextArray
    PTR_FREE, SELF.XTicksValueArray
    PTR_FREE, SELF.YTicksValueArray
    PTR_FREE, SELF.RTicksTextArray
;   IF STRMATCH(!D.NAME,'*PS*',/F) THEN SELF->finishPS
    RETURN
END


PRO CrabFigureDataStructure__DEFINE
    VOID = { CrabFigureDataStructure, DataPoints:PTR_NEW(),  $
                                      Annotations:PTR_NEW(), $
                                      Polylines:PTR_NEW(),   $
                                      TitleText:'',      TitleCharThick:3.0,  TitleCharSizeF:1.0D,  TitlePositionR:[0.5,0.85], $
                                      XTitleText:'',    XTitleCharThick:2.5, XTitleCharSizeF:1.0D, XTitleAlignment:0.5, $ ; title char size charsize char thick charthick 
                                      YTitleText:'',    YTitleCharThick:2.5, YTitleCharSizeF:1.0D, YTitleAlignment:0.5, $
                                      RTitleText:'',    RTitleCharThick:2.5, RTitleCharSizeF:1.0D, RTitleAlignment:0.5, $
                                      CTitleText:'',    CTitleCharThick:1.0, CTitleCharSizeF:1.0D, CTitlePositionR:[0.891,0.680], $
                                                        ColBarCharThick:1.0, ColBarCharSizeF:1.0D, ColorBarPosRect:[0.872,0.305,0.91,0.65], $
                                                        ColBarFormatSTR:'',  $
                                                        LegendCharThick:1.0, LegendCharSizeF:1.0D, LegendPositionR:[0.225,0.775], $
                                      XUnits:'',        $
                                      YUnits:'',        $
                                      XRange:[0.D,0.D], $
                                      YRange:[0.D,0.D], $
                                      CRange:[0.D,255.D], $
                                      RRange:[0.D,0.D], $
                                      XStyle:0,         $
                                      YStyle:0,         $
                                      RStyle:9,         $
                                      XTicksTextArray :PTR_NEW(), XTicksCharThick:1.0, XTicksCharSizeF:1.5, $
                                      XTicksValueArray:PTR_NEW(), XTicksAlignment:0.5, XTicksRotationF:0.0, $
                                                                  XTicksFormatSTR:'',                       $
                                      YTicksTextArray :PTR_NEW(), YTicksCharThick:1.0, YTicksCharSizeF:1.5, $
                                      YTicksValueArray:PTR_NEW(), YTicksAlignment:0.5, YTicksRotationF:0.0, $
                                                                  YTicksFormatSTR:'',                       $
                                      RTicksTextArray :PTR_NEW(), RTicksCharThick:1.0, RTicksCharSizeF:1.5, $
                                                                  RTicksAlignment:0.5, RTicksRotationF:0.0, $
                                                                  RTicksFormatSTR:'',                       $
                                      XMajor:0,         $
                                      YMajor:0,         $
                                      XMinor:9,         $
                                      YMinor:9,         $
                                      XIntev:0.0D,      $
                                      YIntev:0.0D,      $
                                      XTkLen:0.025,     $
                                      YTkLen:0.025,     $
                                      XThick:2.0,       $
                                      YThick:2.0,       $
                                      XLog:0,           $
                                      YLog:0,           $
                                      RLog:0,           $
                                      CLog:0,           $
                                      Note:'',          $
                                      Version:'',       $
                                      DefaultDevice:'', $
                                      CurrentDevice:''  }
    RETURN
END