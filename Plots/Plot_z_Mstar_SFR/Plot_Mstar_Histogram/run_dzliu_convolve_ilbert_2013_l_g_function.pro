PRO run_dzliu_convolve_ilbert_2013_L_G_function, InputDataTable, OutputDataTable, LorentzianTau, GaussianSigma, AxisUnit
    
    readcol, InputDataTable, format='(d,d)', VarX, VarY
    
    IF GaussianSigma GT 0 AND LorentzianTau GT 0 THEN BEGIN
        
        KerN = 2*(FIX(GaussianSigma/AxisUnit)+1)
        KerX = (FINDGEN(2*KerN+1)-DOUBLE(KerN)) * AxisUnit
        ;print, 'X MIN ', MIN(VarX), ' ', 'X MAX ', MAX(VarX) ; 6 14
        ;print, 'X MIN ', MIN(KerX), ' ', 'X MAX ', MAX(KerX) ; -1 1
        KerG = Gaussian(KerX, [1.0, 0.0, GaussianSigma], /DOUBLE) ; normalized Gaussian? 1.0/(SQRT(2.0D*!PI)*GaussianSigma)
        KerL = LorentzianTau/(2.0*!PI)*1.0/((LorentzianTau/2.0)^2+(KerX)^2) ; see Ilbert 2013 Section 4.2 Lorentzian distribution
        ;KerG = KerG / total(KerG)
        ;KerL = KerL / total(KerL)
        print, 'Gaussian Toal ', total(KerG)
        print, 'Lorentz Toal ', total(KerL)
        KerY = KerG * KerL ; <TODO> convol(KerG, KerL, /EDGE_TRUNCATE)
        ;<debug>; print, KerY
        print, 'Kernel Toal ', total(KerY)
        KerY = KerY / total(KerY)
        print, 'Kernel Toal ', total(KerY)
        VarY_Convolved = convol(VarY, KerY, /EDGE_TRUNCATE)
        ;print, total(VarY_Convolved), total(VarY)
        
        ;VarY_FFT = FFT(VarY, /DOUBLE)
        ;KerY_FFT = FFT(KerY, /DOUBLE, /CENTER)
        ;VarY_Convolved_FFT = VarY_FFT * KerY_FFT
        ;VarY_Convolved = FFT(VarY_Convolved_FFT, /DOUBLE, /INVERSE)
        
        IF 1 EQ 1 THEN BEGIN
            PlotDev1 = PLOT( VarX, VarY, /YLOG, YRange=[10^(-6.5),1e-2], XRange=[10,13], XTitle='log Mstar [Msun]', YTitle='Phi [Mpc^-3 dex^-1]', XTickInterval=1.0)
            PlotDev1 = PLOT( VarX, VarY_Convolved, COLOR='magenta', /OVERPLOT, /YLOG, CLIP=1)
            PlotDev1 = TEXT( 0.48, 0.20, 'intrinsic SMF', /NORMAL)
            PlotDev1 = TEXT( 0.62, 0.35, 'convolved SMF', /NORMAL, COLOR='magenta')
            PlotDev2 = PLOT( KerX, KerY, COLOR='cyan', /CURRENT, POSITION=[0.62,0.6,0.88,0.8], XTitle='log Mstar [dex]', YTitle='Kernel') ; KerY/max(KerY)*max(VarY)
            PlotDev2.save, FILE_BASENAME(InputDataTable,'.dat')+'.idl.convolve.pdf'
        ENDIF
        
    ENDIF ELSE BEGIN
        
        VarY_Convolved = VarY
        
    ENDELSE
    
    writecol, OutputDataTable, fmt='(G20.10,G20.10)', VarX, VarY_Convolved
    
END