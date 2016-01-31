FUNCTION CrabReadXWDImage, FILE_NAME, RED, GREEN, BLUE
;
openr,unit, FILE_NAME, /get_lun   ; open the file

hdr = { XWD_FILE_HEADER, $    ; definition of xwd header struct
  header_size : 0L, $
  file_version : 0L, $
  pixmap_format: 0L, $
  pixmap_depth: 0L, $
  pixmap_width: 0L, $
  pixmap_height: 0L, $
  xoffset: 0L, $
  byte_order: 0L, $
  bitmap_unit: 0L, $
  bitmap_bit_order: 0L, $
  bitmap_pad: 0L, $
  bits_per_pixel: 0L, $
  bytes_per_line: 0L, $
  visual_class: 0L, $
  red_mask: 0L, $
  green_mask: 0L, $
  blue_mask: 0L, $
  bits_per_rgb: 0L, $
  colormap_entries: 0L, $
  ncolors: 0L, $
  window_width: 0L, $
  window_height: 0L, $
  window_x: 0L, $
  window_y: 0L, $
  window_bdrwidth: 0L }

Color = { XWDColor, $     ;The xwd color element structure
  pixel: 0L, $
  red: 0,$
  green: 0, $
  blue: 0, $
  flags: 0B, $
  pad: 0B }

readu, unit, hdr      ; read the header
test = 1L       ; do a test to check the system's byte
byteorder, test, /htonl     ; order. If needed switch the byte
if (test ne 1L) then $      ; order to correspond to network byte
   byteorder, hdr, /htonl   ; order

point_lun, unit, hdr.header_size  ; seek to beginning of colormap

colormap = replicate(color, hdr.ncolors)
readu, unit, colormap     ; read the colormap entries from file

if hdr.pixmap_format ne 2 then begin
  message,'READ_XWD: can only handle Z format pixmaps.'
  endif


IMAGE = bytarr(3, hdr.pixmap_width, hdr.pixmap_height)  ;Create the pixmap
line = bytarr(hdr.bytes_per_line)   ; get one scan line

for i=0, hdr.pixmap_height-1 do begin ;Read each scan line
  readu, unit, line
  index = indgen(hdr.pixmap_width)*(hdr.bytes_per_line/hdr.pixmap_width)
  image[2, *, hdr.pixmap_height-i-1] = line[index+0]
  image[1, *, hdr.pixmap_height-i-1] = line[index+1]
  image[0, *, hdr.pixmap_height-i-1] = line[index+2]
endfor

free_lun, unit        ; close and free the file

pixel = colormap.pixel      ; Extract pixel value separately
if test ne 1L then begin    ; switch byte order if needed
  byteorder, colormap, /htons ; Swap whole structure
  byteorder, pixel, /htonl  ; & pixel separately
endif
RED = ishft(colormap.red, -8)
GREEN = ishft(colormap.green, -8)
BLUE = ishft(colormap.blue, -8)

return, IMAGE

end


