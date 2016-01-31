FUNCTION CrabStatisticLinFitData::INIT
    SELF.Lines = PTR_NEW(/ALLOCATE)
    RETURN, 1
END

PRO CrabStatisticLinFitData::addLine, Line1, Slope=Slope, Intercept=Intercept, Note=Note, XRange=XRange, XArray=XArray, XLog=XLog, YLog=YLog
    IF Line1 EQ !NULL THEN Line1 = SELF.Line0
    IF N_ELEMENTS(Slope)     EQ 2 THEN Line1.Slope = Slope
    IF N_ELEMENTS(Slope)     EQ 1 THEN Line1.Slope[0] = Slope
    IF N_ELEMENTS(Intercept) EQ 2 THEN Line1.Intercept = Intercept
    IF N_ELEMENTS(Intercept) EQ 1 THEN Line1.Intercept[0] = Intercept
    IF N_ELEMENTS(Note)      EQ 1 THEN Line1.Note = Note
    IF N_ELEMENTS(XLog)      EQ 1 THEN Line1.XLog = XLog
    IF N_ELEMENTS(YLog)      EQ 1 THEN Line1.YLog = YLog
    IF N_ELEMENTS(XRange)    EQ 2 THEN Line1.XArray = XRange
    IF N_ELEMENTS(XArray)    GE 2 THEN Line1.XArray = XArray
    IF N_ELEMENTS(Line1.XArray) GE 2 THEN BEGIN
        Line2 = SELF->createLine(Line1.Slope, Line1.Intercept, XRange=XRange, XArray=Line1.XArray, XLog=Line1.XLog, YLog=Line1.YLog)
        Line1.YArray = Line2.YArray
    ENDIF
    ; IF FINITE(Line1.Slope[0]) AND FINITE(Line1.Intercept[0]) THEN *(SELF.Lines) = [ *(SELF.Lines), Line1 ]
    *(SELF.Lines) = [ *(SELF.Lines), Line1 ]
END

PRO CrabStatisticLinFitData::appendLines, NewLines
    *(SELF.Lines) = [ *(SELF.Lines), NewLines ]
END

PRO CrabStatisticLinFitData::appendLinFitData, NewLinFitData
    IF NewLinFitData EQ !NULL THEN RETURN
    NewLines = NewLinFitData->Lines()
    *(SELF.Lines) = [ *(SELF.Lines), NewLines ]
END

FUNCTION CrabStatisticLinFitData::getLine, Index, StartsFromOne=StartsFromOne, StartsFromZero=StartsFromZero
    OldLines = *(SELF.Lines)
    NewLine = !NULL
    IF KEYWORD_SET(StartsFromOne) THEN BEGIN
        IF Index GE 1 AND Index LE N_ELEMENTS(OldLines) THEN NewLine = OldLines[Index-1]
    ENDIF ELSE BEGIN
        IF Index GE 0 AND Index LT N_ELEMENTS(OldLines) THEN NewLine = OldLines[Index]
    ENDELSE
    RETURN, NewLine
END

FUNCTION CrabStatisticLinFitData::getLines, Index=Index, Note=Note
    OldLines = *(SELF.Lines)
    NewLines = []
    FOR LineId=0,N_ELEMENTS(OldLines)-1 DO BEGIN
        MatchFlag = 0
        IF N_ELEMENTS(Index) GT 0 THEN BEGIN
            IF N_ELEMENTS(WHERE(Index EQ LineId, /NULL)) GT 0 THEN MatchFlag = 1
        ENDIF
        IF N_ELEMENTS(Note) GT 0 THEN BEGIN
            IF CrabStringMatch(OldLines[LineId].Note, Note, /YES_OR_NO) THEN MatchFlag = 1
        ENDIF
        IF MatchFlag EQ 1 THEN NewLines = [ NewLines, OldLines[LineId] ]
    ENDFOR
    RETURN, NewLines
END 
    
FUNCTION CrabStatisticLinFitData::getLineInfo, Index, StartsFromOne=StartsFromOne, StartsFromZero=StartsFromZero, Format=Format
    NewLine = SELF->getLine(Index, StartsFromOne=StartsFromOne, StartsFromZero=StartsFromZero)
    IF N_ELEMENTS(Format) EQ 0 THEN Format='("Slope = ",F0.6," ± ",F0.6," Intercept = ",F0.6," ± ",F0.6, " Correlation = ",F0.6, " Dispersion = ",F0.6)'
    NewInfo = STRING(FORMAT=Format,(NewLine.Slope)[0],(NewLine.Slope)[1],(NewLine.Intercept)[0],(NewLine.Intercept)[1],NewLine.Correlation,NewLine.Dispersion)
    RETURN, NewInfo
END

FUNCTION CrabStatisticLinFitData::findLine, SearchTextInNote
    MyLines = *(SELF.Lines)
    NewLine = !NULL
    FOR LineId=0,N_ELEMENTS(MyLines)-1 DO BEGIN
        IF CrabStringMatch(MyLines[LineId].Note, SearchTextInNote, /YES_OR_NO, /USE_WILDCARD) AND NewLine EQ !NULL THEN NewLine = MyLines[LineId]
    ENDFOR
    RETURN, NewLine
END

FUNCTION CrabStatisticLinFitData::getLineCount
    MyLines = *(SELF.Lines)
    RETURN, N_ELEMENTS(MyLines)
END

FUNCTION CrabStatisticLinFitData::getDataCount
    MyPoints = *(SELF.XArray)
    RETURN, N_ELEMENTS(MyPoints)
END

PRO CrabStatisticLinFitData::generateLine, Slope, Intercept, XArray, YArray
    IF N_ELEMENTS(Slope)     LE 0 THEN RETURN
    IF N_ELEMENTS(Intercept) LE 0 THEN RETURN
    YArray = ALOG10(XArray) * DOUBLE(Slope[0]) + DOUBLE(Intercept[0])
    YArray = 10^YArray
    RETURN
END

FUNCTION CrabStatisticLinFitData::createLine, Slope, Intercept, XArray = XArray, YArray = YArray, XRange = XRange, YRange = YRange, $
                                              XLog = XLog, YLog = YLog, Correlation = Correlation, Dispersion = Dispersion, Note = Note
    Line2 = SELF.Line0
    IF N_ELEMENTS(Slope)       EQ 1 THEN Line2.Slope[0] = Slope[0]
    IF N_ELEMENTS(Slope)       EQ 2 THEN Line2.Slope = Slope
    IF N_ELEMENTS(Intercept)   EQ 1 THEN Line2.Intercept[0] = Intercept[0]
    IF N_ELEMENTS(Intercept)   EQ 2 THEN Line2.Intercept = Intercept
    IF N_ELEMENTS(Correlation) EQ 1 THEN Line2.Correlation = Correlation
    IF N_ELEMENTS(Dispersion)  EQ 1 THEN Line2.Dispersion = Dispersion
    IF N_ELEMENTS(Note)        EQ 1 THEN Line2.Note = Note
    IF N_ELEMENTS(XLog)        EQ 1 THEN Line2.XLog = XLog
    IF N_ELEMENTS(YLog)        EQ 1 THEN Line2.YLog = YLog
    IF N_ELEMENTS(XArray) GE 2 THEN BEGIN
        Line2.XArray[0] = MIN(XArray)
        Line2.XArray[1] = MAX(XArray)
    ENDIF
    IF N_ELEMENTS(XRange) EQ 2 THEN BEGIN
        Line2.XArray[0] = XRange[0]
        Line2.XArray[1] = XRange[1]
    ENDIF
    IF N_ELEMENTS(Line2.XArray) GE 2 THEN BEGIN
        IF KEYWORD_SET(XLog) THEN BEGIN
            XLowerValue = ALOG10(Line2.XArray[0]) ; Y = A * X^N   lg(Y) = lg(A) + N*lg(X)
            XUpperValue = ALOG10(Line2.XArray[1]) ; Y = A * X^N   lg(Y) = lg(A) + N*lg(X)
        ENDIF ELSE BEGIN
            XLowerValue = Line2.XArray[0]         ; Y = A + N*X
            XUpperValue = Line2.XArray[1]         ; Y = A + N*X
        ENDELSE

        Line2.YArray[0] = DOUBLE(Slope[0])*XLowerValue 
        Line2.YArray[1] = DOUBLE(Slope[0])*XUpperValue
        
        IF KEYWORD_SET(YLog) THEN BEGIN
            Line2.YArray[0] = DOUBLE(Intercept[0])*10^(Line2.YArray[0]) ; Y = A * X^N = A * 10^(N*lg(X))
            Line2.YArray[1] = DOUBLE(Intercept[0])*10^(Line2.YArray[1]) ; Y = A * X^N = A * 10^(N*lg(X))
        ENDIF ELSE BEGIN
            Line2.YArray[0] = DOUBLE(Intercept[0]) + Line2.YArray[0]    ; Y = A + N*X
            Line2.YArray[1] = DOUBLE(Intercept[0]) + Line2.YArray[1]    ; Y = A + N*X
        ENDELSE
    ENDIF
    RETURN, Line2
END

PRO CrabStatisticLinFitData::CLEANUP
    PTR_FREE, SELF.Lines
    RETURN
END

PRO CrabStatisticLinFitData__DEFINE
    Line0 = {CrabStatisticLinFitLine, Slope : [0.0D,0.0D], $
                                  Intercept : [0.0D,0.0D], $
                                     XArray : [0.0D,0.0D], $
                                     YArray : [0.0D,0.0D], $
                                     XLog   : 0,           $
                                     YLog   : 0,           $
                                Correlation : 0.0D,        $
                                 Dispersion : 0.0D,        $
                                       Note : ''           }
    VOID = { CrabStatisticLinFitData, Lines:PTR_NEW(), Line0:Line0 }
END