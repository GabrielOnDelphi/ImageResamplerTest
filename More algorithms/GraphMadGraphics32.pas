UNIT GraphMadGraphics32;

{***************************************************************
    tiny madGraphics.pas
    -------------------------------------------------------------
    version:  1.0 / 2001-03-04
    gray scaling, smooth stretching, alpha blending, ...
    Copyright (C) 1999 - 2001 www.madshi.net, All Rights Reserved
    -------------------------------------------------------------

 Resize test:
    Graphics: EXACTLY same results as SmoothResize.
    Time: 5% faster than SmoothResize
    Note: this library supports 32bit instead of 24  }

{ Nota: Downloaded from neurolabuscMRIcron. It is BDS freeware }

{$R-}{$Q-}

INTERFACE

USES
   Graphics;

procedure StretchBitmap32(srcBmp, dstBmp: TBitmap);    { Source and dest must be pf32bit! }

IMPLEMENTATION

USES
   SysUtils;

procedure StretchBitmap32(srcBmp, dstBmp: TBitmap);
VAR
   ix, iy                   : integer;
   x, y, xdif, ydif         : integer;
   xp1, xp2, yp             : integer;
   wy, wyi, wx              : integer;
   w11, w21, w12, w22       : integer;
   sbBits, sbLine1, sbLine2 : PByteArray;
   smLine1                  : PByteArray;
   dbLine                   : PByteArray;
   sbLineDif, dbLineDif     : integer;
   w                        : integer;
begin
  Assert(srcBmp.PixelFormat = pf32bit);
  Assert(dstBmp.PixelFormat = pf32bit);

  xdif := (srcBmp.Width  shl 16) DIV (dstBmp.Width);//CR: +1 avoids slight scaling distortion
  ydif := (srcBmp.Height shl 16) div (dstBmp.Height);//CR: +1 avoids slight scaling distortion
  y := 0;
  sbBits := srcBmp.ScanLine[0];
  if srcBmp.Height > 1
  then sbLineDif := integer(srcBmp.ScanLine[1]) - integer(sbBits)
  else sbLineDif := 0;
  dbLine := dstBmp.ScanLine[0];
  if dstBmp.Height > 1
  then dbLineDif := integer(dstBmp.ScanLine[1]) - integer(dbLine) - 4 * dstBmp.Width
  else dbLineDif := 0;

  w := srcBmp.Width - 1;
  for iy := 0 to dstBmp.Height - 1 do
  begin
    yp := y shr 16;
    integer(sbLine1) := integer(sbBits) + sbLineDif * yp;
    integer(smLine1) := integer({smBits}nil) {+ smLineDif * yp};
    if yp < srcBmp.Height - 1
    then integer(sbLine2) := integer(sbLine1) + sbLineDif
    else sbLine2 := sbLine1;
    x   := 0;
    wy  :=      y  and $FFFF;
    wyi := (not y) and $FFFF;
    for ix := 0 to dstBmp.Width - 1 do
     begin
      xp1 := x shr 16;
      if xp1 < w
      then xp2 := xp1 + 1
      else xp2 := xp1;
      wx  := x and $FFFF;
      w21 := (wyi * wx) shr 16; w11 := wyi - w21;
      w22 := (wy  * wx) shr 16; w12 := wy  - w22;
      {if smLine1 <> nil then begin
        w11 := (w11 * (256 - smLine1^[xp1])) shr 8;
        w21 := (w21 * (256 - smLine1^[xp2])) shr 8;
        w12 := (w12 * (256 - smLine2^[xp1])) shr 8;
        w22 := (w22 * (256 - smLine2^[xp2])) shr 8;
        dmLine^ := 255 - byte((w11 + w21 + w12 + w22) shr 8);
      end;}
      xp1 := xp1 * 4;
      xp2 := xp2 * 4;
      {blue} dbLine^[0] := (sbLine1[xp1    ] * w11 + sbLine1[xp2    ] * w21 + sbLine2[xp1    ] * w12 + sbLine2[xp2    ] * w22) shr 16;
      {green}dbLine^[1] := (sbLine1[xp1 + 1] * w11 + sbLine1[xp2 + 1] * w21 + sbLine2[xp1 + 1] * w12 + sbLine2[xp2 + 1] * w22) shr 16;
      {red}  dbLine^[2] := (sbLine1[xp1 + 2] * w11 + sbLine1[xp2 + 2] * w21 + sbLine2[xp1 + 2] * w12 + sbLine2[xp2 + 2] * w22) shr 16;
      inc(integer(dbLine), 4);
      //inc(dmLine);
      inc(x, xdif);
      //if ix = 0 then
      //  inc(x, Hlfxdif);
     end;
    inc(integer(dbLine), dbLineDif);
    inc(y, ydif);
  end;
end;

end.