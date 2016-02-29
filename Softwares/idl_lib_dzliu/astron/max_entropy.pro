;+
; NAME:
;	MAX_ENTROPY
;
; PURPOSE:
;	Deconvolution of data by Maximum Entropy analysis, given the PSF
; EXPLANATION:
;	Deconvolution of data by Maximum Entropy analysis, given the 
;	instrument point spread response function (spatially invariant psf).
;	Data can be an observed image or spectrum, result is always positive.
;	Default is convolutions using FFT (faster when image size = power of 2).
;
; CALLING SEQUENCE:
;	for i=1,Niter do begin
;	Max_Entropy, image_data, psf, image_deconv, multipliers, FT_PSF=psf_ft
;
; INPUTS:
;	data = observed image or spectrum, should be mostly positive,
;					with mean sky (background) near zero.
;	psf = Point Spread Function of instrument (response to point source,
;							must sum to unity).
;	deconv = result of previous call to Max_Entropy,
;	multipliers = the Lagrange multipliers of max.entropy theory
;		(on first call, set = 0, giving flat first result).
;
; OUTPUTS:
;	deconv = deconvolution result of one more iteration by Max_Entropy.
;	multipliers = the Lagrange multipliers saved for next iteration.
;
; OPTIONAL INPUT KEYWORDS:
;	FT_PSF = passes (out/in) the Fourier transform of the PSF,
;		so that it can be reused for the next time procedure is called,
;      /NO_FT overrides the use of FFT, using the IDL function convol() instead.
;      /LINEAR switches to Linear convergence mode, much slower than the
;		default Logarithmic convergence mode.
;	LOGMIN = minimum value constraint for taking Logarithms (default=1.e-9).
; EXTERNAL CALLS:
;	function convolve( image, psf ) for convolutions using FFT or otherwise.
; METHOD:
;	Iteration with PSF to maximize entropy of solution image with
;	constraint that the solution convolved with PSF fits data image.
;	Based on paper by Hollis, Dorband, Yusef-Zadeh, Ap.J. Feb.1992,
;	which refers to Agmon, Alhassid, Levine, J.Comp.Phys. 1979.
;
;       A more elaborate image deconvolution program using maximum entropy is 
;       available at 
;       http://sohowww.nascom.nasa.gov/solarsoft/gen/idl/image/image_deconvolve.pro
; HISTORY:  
;	written by Frank Varosi at NASA/GSFC, 1992.
;	Converted to IDL V5.0   W. Landsman   September 1997
;-

pro max_entropy, data, psf, deconv, multipliers, FT_PSF=psf_ft, NO_FT=noft, $
			LINEAR=Linear, LOGMIN=Logmin, RE_CONVOL_IMAGE=Re_conv, scale=scale

	if N_elements( multipliers ) LE 1 then begin
		multipliers = data
		multipliers[*] = 0
	   endif
  
  deconv = convolve( multipliers, psf, FT_PSF=psf_ft, $
             /CORREL, NO_FT=noft ) ;<20141126><DzLIU>; s = surface(deconv) s = surface(exp(deconv))
  ordeconv = deconv ; - ( MAX(deconv) - 100.0d ) ;<20141126><DzLIU>; print, where(~finite(exp(deconv)))
  irdeconv = 0
  while n_elements(where(~finite(exp(deconv)),/null)) gt 0 do begin
      ;deconv = deconv-1.0d & irdeconv = irdeconv+1
      deconv = deconv/725.0 & irdeconv = irdeconv+1
  endwhile
  deconv = exp(deconv) ;<20141126><DzLIU>; print, where(~finite(exp(deconv)))
;  if n_elements(where(~finite((deconv)),/null)) gt 0 then begin
;      deconv[where(ordeconv gt alog(max(deconv,/NaN)),/null)] = max(deconv,/NaN) ;<20141126><DzLIU>; print, where(~finite((deconv)))
;  endif
  while ~finite(total( deconv, /Double, /NaN )) do begin
      deconv = deconv / 1d10
  endwhile
  
;	deconv = exp( convolve( multipliers, psf, FT_PSF=psf_ft, $
;						 /CORREL, NO_FT=noft ) ) ;<20141126><DzLIU>;
	totd = total( data )
;	totdeconv = total( deconv, /Double, /NaN ) ;<20141126><DzLIU>
	totdeconv =  1.0d * (size(data,/dim))[0] * (size(data,/dim))[1] ;<20141126><DzLIU>
;	deconv = deconv * ( totd / totdeconv ) ;<20141126><DzLIU>
  deconv = deconv * ( 1.0d / totdeconv ) ;<20141126><DzLIU> deconv has a total of 1.0, psf has a total of 1.0
  
	Re_conv = convolve( deconv, psf, FT_PSF=psf_ft, NO_FT=noft )
	totreconv = total( Re_conv, /Double, /NaN ) ;<20141126><DzLIU>
	scale = totreconv / totd ;<20141126><DzLIU>
	scale1 = total( Re_conv[where(Re_conv gt 0,/null)], /Double, /NaN ) / total( data[where(data gt 0,/null)], /Double, /NaN )
	if n_elements(where(Re_conv lt 0,/null)) gt 0 then scale2 = total( Re_conv[where(Re_conv lt 0,/null)], /Double, /NaN ) / total( data[where(data lt 0,/null)], /Double, /NaN ) else scale2 = scale1 ;<20150505><DzLIU>
;	scale = abs(scale)
  scale = mean([scale1,scale2])
	
;	;h_conv = crabarrayfenbin(deconv,Count=10,BinCentres=l_conv,/Continue,Iteration=3000)
;	;h_deconv = histogram(alog10(deconv),binsize=0.5,location=l_deconv)
;	a_reconv = Re_conv & a_reconv[where(Re_conv gt 0,/null)] = alog10(a_reconv[where(Re_conv gt 0,/null)]) & a_reconv[where(Re_conv lt 0,/null)] = -alog10(-a_reconv[where(Re_conv lt 0,/null)])
;	a_data = data & a_data[where(data gt 0,/null)] = alog10(a_data[where(data gt 0,/null)]) & a_data[where(data lt 0,/null)] = -alog10(-a_data[where(data lt 0,/null)])
;	h_reconv = histogram((a_reconv),binsize=0.25,location=l_reconv)
;	h_data = histogram((a_data),binsize=0.25,location=l_data)
;	;plt = plot(l_deconv,h_deconv,/STAIRSTEP)
;	plt = plot(l_data,h_data,/nodata)
;	plt = plot(l_data,h_data,/STAIRSTEP,/Overplot,Color='blue')
;	plt = plot(l_reconv,h_reconv,/STAIRSTEP,/Overplot,Color='green')
;	a_redata = data*scale & a_redata[where(data*scale gt 0,/null)] = alog10(a_redata[where(data*scale gt 0,/null)]) & a_redata[where(data*scale lt 0,/null)] = -alog10(-a_redata[where(data*scale lt 0,/null)])
;	h_redata = histogram((a_redata),binsize=0.25,location=l_redata)
;	plt = plot(l_redata,h_redata,/STAIRSTEP,/Overplot,Color='blue',linestyle=2)

	if keyword_set( Linear ) then begin

	  multipliers = multipliers + (data * scale - Re_conv)

	  endif else begin

		if N_elements( Logmin ) NE 1 then Logmin=1.e-9
		multipliers = multipliers + $
			aLog( ( ( data * scale )>Logmin ) / (Re_conv>Logmin) )
	   endelse
end
