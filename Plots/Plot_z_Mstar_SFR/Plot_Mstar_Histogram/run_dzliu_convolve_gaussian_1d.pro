PRO run_dzliu_convolve_gaussian_1d, InputDataTable, OutputDataTable, GaussianSigma, AxisUnit
    
    readcol, InputDataTable, format='(d,d)', VarX, VarY
    
    IF GaussianSigma GT 0 THEN BEGIN
        
        KerL = 2*(FIX(GaussianSigma/AxisUnit)+1)
        KerX = (FINDGEN(2*KerL+1)-DOUBLE(KerL)) ; * GaussianSigma * AxisUnit ; -5.0 dex to +5.0 dex
        KerY = Gaussian(KerX, [1.0, 0.0, GaussianSigma/AxisUnit], /DOUBLE)
        KerY = KerY / (SQRT(2.0D*!PI)*GaussianSigma/AxisUnit)
        ;<debug>; print, KerY
        print, total(KerY)
        VarY_Convolved = convol(VarY, KerY, /EDGE_TRUNCATE)
        ;print, total(VarY_Convolved), total(VarY)
        
        ;VarY_FFT = FFT(VarY, /DOUBLE)
        ;KerY_FFT = FFT(KerY, /DOUBLE, /CENTER)
        ;VarY_Convolved_FFT = VarY_FFT * KerY_FFT
        ;VarY_Convolved = FFT(VarY_Convolved_FFT, /DOUBLE, /INVERSE)
        
        IF 1 EQ 1 THEN BEGIN
            PP = PLOT( VarY )
            PP = PLOT( VarY_Convolved, COLOR='magenta', /OVERPLOT)
            PP = PLOT( KerY/max(KerY)*max(VarY), COLOR='cyan', /OVERPLOT)
        ENDIF
        
    ENDIF ELSE BEGIN
        
        VarY_Convolved = VarY
        
    ENDELSE
    
    writecol, OutputDataTable, fmt='(G20.10,G20.10)', VarX, VarY_Convolved
    
END
