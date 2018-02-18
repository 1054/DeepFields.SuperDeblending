;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

function fracshift, aa, dx0, dy0, QUAD = quad

if (n_params() lt 3 || size(aa,/n_dimensions) lt 2) then return, 0.
xp = 1. + (size(quad,/type) gt 0 && (size(quad,/type) gt 5 || quad gt 0))

sx = dx0/abs(dx0) & dx = abs(dx0) & sy = -dy0/abs(dy0) & dy = abs(dy0)

return, (dx*dy*shift(aa,sx,sy))^xp + (dx*(1.-dy)*shift(aa,sx,-sy))^xp + $
    ((1.-dx)*dy*shift(aa,-sx,sy))^xp + ((1.-dx)*(1.-dy)*shift(aa,-sx,-sy))^xp
    
end
		
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

function imrange, im, sig, it, sg0

if (n_params() eq 0) then begin
    print, '  [min,max] = imrange(image [, [min sig,max sig], iterations, ' + $
    	'threshold])
    return, -1
endif

if (n_elements(sig) eq 0) then sg = [-0.5,0.5] else if (n_elements(sig) eq 1) $
    then sg = [-sig,sig] else sg = [-sig[0],sig[1]]
if (n_elements(it) eq 0 || it le 0) then it = 1
if (n_elements(sg0) eq 0 || sg0 lt 0) then sg0 = 3

nib = n_elements(im) & ib = lindgen(nib) & nic = nib & ic = ib
medim = median(im)
;medim = 2.5*median(im) - 1.5*mean(im)
for i = 0, it do begin
    if (nib gt 0) then sglo = sqrt(total((im[ib]-medim)^2./nib)) else sglo = 0
    if (nic gt 0) then sghi = sqrt(total((im[ic]-medim)^2./nib)) else sghi = 0
    ib = where(im ge medim-sg0*sglo and im le medim, nib)
    ic = where(im ge medim and im le medim+sg0*sghi, nic)
;    medim = median(im[[ib,ic]])
;    medim = 2.5*median(im[[ib,ic]]) - 1.5*mean(im[[ib,ic]])
    medim = median(im[ic])
;    medim = 2.5*median(im[ic]) - 1.5*mean(im[ic])
endfor

if (sg[0] le 0) then zlo = sg[0]*sglo else zlo = sg[0]*sghi
if (sg[1] ge 0) then zhi = sg[1]*sghi else zhi = sg[1]*sglo

return, medim + [zlo, zhi]

end

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

pro startps, filep, pt, SIZE = sz, COL = col, PROMPT = prompt, _EXTRA = extra

if (n_elements(pt) eq 0 || pt le 0) then pt = 5
if (n_elements(prompt) eq 0) then prompt = '  PS name : '
if (n_elements(filep) eq 0 || strlen(filep) eq 0 || size(filep,/type) ne 7) $
    then begin
    filep = 'temp.ps'
    read, [prompt], filep
endif
if (n_elements(col) eq 0) then col = 0
if (n_elements(sz) lt 2 || sz[0] eq 0 || sz[1] eq 0) then begin
    xsz = 17.78 & ysz = 12.7
endif else begin
    xsz = sz[0] & ysz = sz[1]
endelse
if (!d.name eq 'PS') then device,/close else set_plot, 'ps'
if col then device, file = filep, /color, /encapsul, bits_per_pixel = 8, $
    xsize = xsz, ysize = ysz, _EXTRA = extra else device, file = filep, $
    /encapsul, xsize = xsz, ysize = ysz, _EXTRA = extra
!p.charthick = pt & !p.thick = pt & !x.thick = pt & !y.thick = pt
!p.charsize = 1.2
end

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

pro endps

if (!d.name ne 'PS') then return
device, /close_file & set_plot,'x'
!p.charthick = 1 & !p.thick = 1 & !x.thick = 1 & !y.thick = 1
!p.charsize = 1
!p.background = 255 & !p.color = 0

end

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

pro cutouts, image, catalog, list, ZSCL = zscl, GEOM = geom, BSIZE = $
    bsz0, SHOWID = showid, CENTER = center, INV = inv, SEP = sep, EPS = eps, $
    HELP = help


if (keyword_set(HELP) || n_params() lt 1) then begin
    print, '  cutouts, image(s) or @list, catalog [, list, ZSCL = [min sig, '+$
    	'max sig, softening factor], GEOM = [n,m], BSIZE = box size (in ' + $
	'pix), /SHOWID or SHOWID = prefix, /INV(ert color table), /CENTER, ' +$
    	'/SEP(arate), /EPS or EPS = filename'
    return
endif


lflag = strmid(image,0,1) eq '@'
uselist = size(list,/type) gt 0 && (size(list,/type) eq 7 || $
    size(list,/type) le 5)
if (size(zscl,/type) eq 0 || size(zscl,/type) gt 5 || n_elements(zscl) lt 3) $
    then zscl = [0.2,0.5,0.1]
if (n_elements(zscl) lt 6) then zscl = rebin(zscl[0:2],3,3)
ib = where(zscl[[2,5,8]] le 0, nib)
if (nib gt 0) then zscl[3*ib+2] = 0.1
isgeom = n_elements(geom) ge 2 && size(geom,/type) le 5
bflag = size(bsz0,/type) gt 0 && size(bsz0,/type) le 5 && bsz0 gt 0
plotids = size(showid,/type) gt 0 && (size(showid,/type) gt 5 || showid gt 0)
pref = (plotids && size(showid,/type) eq 7)?showid:''
ctinv = size(inv,/type) gt 0 && (size(inv,/type) gt 5 || inv gt 0)
recenter = size(center,/type) gt 0 && (size(center,/type) gt 5 || center gt 0)
pflag = size(eps,/type) gt 0
dosep = pflag && size(sep,/type) gt 0 && (size(sep,/type) gt 5 || sep gt 0)


if (size(cmt,/type) ne 7 || strlen(cmt) eq 0 || cmt eq ' ') then cmt = '#'
if (size(bsz1,/type) eq 0 || size(bsz1,/type) gt 5 || bsz1 le 0) then bsz1 = 20.
if (size(wd,/type) eq 0 || size(wd,/type) gt 5 || wd le 0) then wd = 4.
if (size(tol,/type) eq 0 || size(tol,/type) gt 5 || tol le 0) then tol = 0.005






file1 = file_search(strmid(image,lflag), count = nf1)
if (nf1 eq 0) then begin
    print, '  Error: image not found' & return
endif
if lflag then begin
    readcol, file1[0], ipath, format = 'a', /silent
    nim = n_elements(ipath)
    count = 0 & tg = 'i' + strtrim(indgen(nim)+1,2)
    for i = 0, nim-1 do begin
    	filei = (file_search(ipath[i], count = nfi))[0]
	if (nfi eq 0) then begin
	    print, '  Error: ' + file_basename(ipath[i]) + ' not found'
	    continue
	endif
	imi = readfits(filei, hdi, /silent)
	if (count eq 0) then begin
	    imc = create_struct([tg[i]], imi)
	    im = imi
	endif else begin
	    imc = create_struct(imc, [tg[i]], imi)
	    im = [[[im]],[[imi]]]
	endelse
	count++
    endfor
    nim = count
    irng = imrange(temporary(im),[zscl[0],zscl[1]])
    isrgb = 0
    goto, j2
endif
isrgb = nf1 ge 3
for i = 0, 2*isrgb do begin
    imi = readfits(file1[i], hdi, /silent)
    scli = sqrt((sxpar(hdi,'CD1_1'))^2d0+(sxpar(hdi,'CD1_2'))^2d0)
    szi = size(imi, /dimensions)

    if (zscl[0] ne zscl[1]) then irngi = imrange(imi,[zscl[3*i],zscl[3*i+1]]) $
    	else irngi = minmax(imi)
 
    if (i eq 0) then begin
    	hd0 = hdi & scl0 = scli & sz0 = szi
	im = bytscl(asinh((irngi[0]>imi<irngi[1])/zscl[3*i+2]))
    endif else begin
    	if (abs(scl0-scli)/scl0 gt tol || array_equal(sz0,szi) eq 0) then begin
	    print, '  Interpolating ' + file_basename(file1[i])
	    hastrom, temporary(imi), temporary(hdi), imi, hdi, hd0, missing = 0
	endif
	im = [[[im]],[[bytscl(asinh((irngi[0]>imi<irngi[1])/zscl[3*i+2]))]]]
    endelse
endfor


filec = (file_search(catalog, count = nfc))[0]
if (nfc eq 0) then begin
    print, '  Error: catalog not found' & return
endif
head = '' & str = ''
openr, fun, filec, /get_lun
while not eof(fun) do begin
    readf, fun, str
    if (strmid(str,0,strlen(cmt)) eq cmt) then head = [head, str] else break
endwhile
free_lun, fun
if (n_elements(head) le 1) then begin
    print, '  Error: header not found' & return
endif else head = head[1:*]
ncol = n_elements(strsplit(str,/extract))
ii = (where(strmatch(head,'*NUMBER*',/fold_case) or strmatch(head,'*ID*', $
    /fold_case), nii))[0]
ix = (where(strmatch(head,'*X_WORLD*',/fold_case) or strmatch(head,'*RA*', $
    /fold_case), nix))[0]
iy = (where(strmatch(head,'*Y_WORLD*',/fold_case) or strmatch(head,'*DEC*', $
    /fold_case), niy))[0]
ia = where(strmatch(head,'*A_WORLD*',/fold_case), nia)
if (nix*niy*nii eq 0) then begin
    print, '  Error: required fields not found in catalog' & return
endif
frmt = replicate('x',ncol) & var = replicate('',ncol)
frmt[[ii,ix,iy]] = ['i','d','d'] & var[[ii,ix,iy]] = ['id','ra','dec']
if (nia gt 0) then begin
    frmt[ia[0]] = 'f' & var[ia[0]] = 'aa'
endif
ex = execute('readcol,filec,'+strjoin(var[where(strlen(var) gt 0)],',') + $
    ',format=strjoin(frmt,","),/silent,comment=cmt,count=nlines')
mflag = n_elements(aa) eq n_elements(id)


if uselist then begin
    if (size(list,/type) eq 7) then begin
    	filel = (file_search(list, count = nfl))[0]
	if (nfl eq 0) then begin
	    print, '  Error: list not found' & uselist = 0 & goto, j1
	endif
    	readcol, filel, id2, format = 'i', comment = cmt, /silent
    endif
        
    match, id, id2, i12, i21    
    
    if (i12[0] lt 0) then begin
    	print, '  Error: no matching IDs' & return
    endif else print, '  ' + strjoin(strtrim([n_elements(i12), $
    	n_elements(id2)],2),'/') + ' matches'
    ra = ra[i12] & id = id[i12] & dec = dec[i12]
    if mflag then aa = aa[i12]
endif
j1:


nim = float(n_elements(id))
j2:
if isgeom then begin
    nn = float(geom[0]) & mm = float(geom[1]) & nim = nim < nn*mm
    dx = 0.05/nn & dy = 0.05/mm
    xsz = (1./nn)-2.*dx & ysz = (1./mm)-2.*dy
endif else begin
    nn = float(ceil(sqrt(nim))) & dx = 0.05/nn & dy = dx
    xsz = (1./nn)-2.*dx & ysz = xsz
endelse


if ~lflag then begin
    adxy, hd0, ra, dec, xx, yy
;    isgeom = 0
;    if isgeom then bsz = round(wd*aa/scl0) else bsz = replicate(round(bsz0), $
;    	nim)
    if isgeom then bsz = replicate(round(bsz0), nim) else if mflag then bsz = $
    	round(wd*aa/scl0) else bsz = replicate(round(bsz1), nim)
endif


for i = 0, (nim-1)*dosep do begin
    if pflag then begin
    	if dosep then fileo = 'id' + strtrim(id[i],2) + '.ps' else $
	if (size(eps,/type) ne 7 || strlen(strtrim(eps,2)) eq 0) then begin
    	    fileo = 'cutouts.ps' & read, ['  Filename : '], fileo
    	endif else fileo = eps
    	psz = dosep?[5.,5.]:[25.,25.]
    	if isgeom then if (nn gt mm) then psz = 20.*[1.,mm/nn] else psz = $
    	    20.*[nn/mm,1.]
    	startps, fileo, /col, size = psz
	csz = 5./nn & cth = !p.charthick*5./nn
    endif else begin
    	dsz = get_screen_size()
    	isz = 0.8*dsz
    	if (!d.x_size ne fix(isz[0]) || !d.y_size ne fix(isz[1])) then window,$
    	    xsize = isz[0], ysize = isz[1] else erase
	csz = !p.charsize & cth = !p.charthick
    endelse
;    bw = reverse(indgen(256)) & !p.background = 0
;    tvlct, bw, bw, bw
    if isrgb then loadct, 0, /silent else loadct, 3, /silent
    if ctinv then begin
    	tvlct, rr, gg, bb, /get
    	tvlct, reverse(rr), reverse(gg), reverse(bb)
    	!p.background = 0
    endif else !p.background = 255
    for j = i, (dosep?i:(nim-1)) do begin
    	if ~lflag then begin
    	    i1 = round(xx[j])-bsz[j]-1 & i2 = round(xx[j])+bsz[j]+1
    	    i3 = round(yy[j])-bsz[j]-1 & i4 = round(yy[j])+bsz[j]+1
    	    nxi = i2 - i1 + 1 & nyi = i4 - i3 + 1
    	    j1 = abs(i1<0) & j2 = nxi-1-((i2-sz0[0]+1)>0)
    	    j3 = abs(i3<0) & j4 = nyi-1-((i4-sz0[1]+1)>0)
    	
    	    imi = fltarr(nxi,nyi)
    	    imi[j1:j2,j3:j4] = im[i1>0:i2<(sz0[0]-1),i3>0:i4<(sz0[1]-1)]
    	    if recenter then imi = fracshift(imi, xx[j]-round(xx[j]), yy[j]- $
    	    	round(yy[j]))
    	    nxi = nxi-2 & nyi = nyi-2 & imi = imi[1:nxi-1,1:nyi-1]
	endif else imi = bytscl(asinh((irng[0]>imc.(j)<irng[1])/zscl[2]))
    
    	posi = dosep?[0,0]:[dx+(j mod nn)*(xsz+2.*dx), 1-dy-(floor(j/nn)+1)* $
	    ysz-2.*floor(j/nn)*dy]

    	if ~pflag then imi = congrid(imi, isz[0]*xsz, isz[1]*ysz, 1+2*isrgb)
    
    	tv, imi, posi[0], posi[1], xsize=dosep?1:xsz, ysize=dosep?1:ysz, $
	    /normal, true=3*isrgb
    		
    	if plotids then xyouts, posi[0]+0.9*xsz, posi[1]+0.1*ysz, $
    	    '!6'+pref+strtrim(id[j],2)+'!3', /normal, col = !p.background, $
	    alignment = 1, charsize = csz, charthick = cth
    endfor
    if pflag then endps ;else read, cmd
endfor


end
