UNIT TesterForm;

{=============================================================================================================
   Gabriel Moraru
   2024.12
   See Copyright.txt
--------------------------------------------------------------------------------------------------------------

   Description
     Tests multiple (13) Delphi resizing algorithms that can be found on the Internet for free to find the best one.
     The test include also some personal or 3rd party algorithms.
     If you don't have access to their source code, you will have to switch off the $3RDPARTY switch.

   Tests:
     Resample up
     Resample down.

   Requires the LightSaber library:
     https://github.com/GabrielOnDelphi/Delphi-LightSaber

 ------------------------------------------------------------------------------------------------------------

   Conclusions
     In general, all tested algorithms seem suitable to resize down a high res image but some are faster than others.
     The story is different when you try to resize up (a small res image to high resolution).

     The winner is Windows.StretchBlt. See StretchF in cGraphResizeWin.


   Also see: https://msdn.microsoft.com/en-us/library/windows/desktop/dd162950(v=vs.85).aspx

=============================================================================================================}

INTERFACE

USES
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Actions, System.Classes,
  FMX.Graphics, FMX.Surfaces,
  Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.FileCtrl, Vcl.ActnList, Vcl.StdCtrls, Spin, Vcl.Graphics,
  cvIniFile, ccCore, ccINIFile, ccIO, cmIO, cvFileListBox, cvSplitter, cvMemo, cvCheckBox, cvPathEdit, cbAppdata,
  Vcl.Imaging.pngimage;

type
  TfrmResample = class(TForm)
    actBitBlt               : TAction;
    actDephiStrtchDrw       : TAction;
    actFMXGraphics          : TAction;
    actGr32                 : TAction;
    actHBResize             : TAction;
    ActionList              : TActionList;
    actJanFXSmoothRes       : TAction;
    actJanFxStretch         : TAction;
    actMadshi               : TAction;
    actMsThumbnails         : TAction;
    actResizeMMX            : TAction;
    actScaleImage           : TAction;
    btnBitBlt               : TButton;
    btnDelphiScaleImg       : TButton;
    btnDephiStrtchDrw       : TButton;
    btnGr32                 : TButton;
    btnHB                   : TButton;
    btnJanSmooth            : TButton;
    btnJanStretch           : TButton;
    btnMadshi               : TButton;
    btnMsThumbnails         : TButton;
    btnResizeMMX            : TButton;
    Button2                 : TButton;
    chkTrimRam              : TCubicCheckBox;
    CubicSplitter1          : TCubicSplitter;
    Files                   : TCubicFileList;
    Panel1                  : TPanel;
    Panel2                  : TPanel;
    Panel3                  : TPanel;
    Path                    : TCubicPathEdit;
    spnJan: TSpinEdit;
    spnGr32Filter           : TSpinEdit;
    btnHBQckDwn             : TButton;
    btnHBHard               : TButton;
    Panel5                  : TPanel;
    btnOrig                 : TButton;
    btnRefresh              : TButton;
    Label2                  : TLabel;
    Panel4                  : TPanel;
    lblNewWidth             : TLabel;
    spnWidth                : TSpinEdit;
    Panel7                  : TPanel;
    Panel6                  : TPanel;
    Preview                 : TImage;
    chkStretch              : TCubicCheckBox;
    chkSaveOutput           : TCubicCheckBox;
    Button1: TButton;
    actWic: TAction;
    Button3: TButton;
    actGDI: TAction;
    procedure actBitBltExecute             (Sender: TObject);
    procedure actDephiStrtchDrwExecute     (Sender: TObject);
    procedure actFMXGraphicsExecute        (Sender: TObject);
    procedure actGr32Execute               (Sender: TObject);
    procedure actHBResizeExecute           (Sender: TObject);
    procedure actJanFXSmoothResExecute     (Sender: TObject);
    procedure actJanFxStretchExecute       (Sender: TObject);
    procedure actMadshiExecute             (Sender: TObject);
    procedure actMsThumbnailsExecute       (Sender: TObject);
    procedure actResizeMMXExecute          (Sender: TObject);
    procedure actScaleImageExecute         (Sender: TObject);
    procedure btnHBQckDwnClick             (Sender: TObject);
    procedure btnOrigClick                 (Sender: TObject);
    procedure btnRefreshClick              (Sender: TObject);
    procedure btnHBHardClick               (Sender: TObject);
    procedure FilesDblClick                (Sender: TObject);
    procedure FormDestroy                  (Sender: TObject);
    procedure spnJanChange              (Sender: TObject);
    procedure chkStretchClick              (Sender: TObject);
    procedure actWicExecute(Sender: TObject);
    procedure actGDIExecute(Sender: TObject);
  private
    BmpOut: Vcl.Graphics.TBitmap;
    Loader: Vcl.Graphics.TBitmap;
    function Ratio: Double;
    procedure TimerStop(AlgorithmName: string; Time: Double);
    function  NewHeight: Integer;
    function  Scale: Double;
    procedure LateInitialize(VAR Msg: TMessage); message MSG_LateFormInit;
    procedure ShowOutput(FileName: string);
    procedure LoadInput24;
    procedure PrepareOutput24;
    procedure LoadInput32;
 end;

VAR
  frmResample: TfrmResample;

IMPLEMENTATION {$R *.dfm}

{$DEFINE HardID}      // Undefine if you don't have the Hardware ID Extractor lib  https://GabrielMoraru.com/my-delphi-code/delphi-libraries/hardware-id-extractor/
{$DEFINE HBert}       // Undefine if you don't have the HBert lib
{$DEFINE 3rdPARTY}    // Undefine if you don't have these 3rd party libs. They are free libraries. You can get them from: github.com/graphics32/graphics32, JanFX (Jedi lib)
{.DEFINE FastJpg}     // USE THIS IN "PROJECT OPTIONS"! Undefine if you don't have this 3rd party lib. You can get it for free from www.github.com/galfar/PasJpeg2000

USES
   {$IFDEF HardID} chHardID, {$ENDIF}
   {$IFDEF HBert}  GraphHBResize, {$ENDIF}
   {$IFDEF 3RDPARTY} janFXStretch, GraphSmoothResizeASM, GraphMadGraphics32, {$ENDIF}
   cmMath, cmSound, cmDebugger, ccColors,
   cGraphResize, cGraphResizeVCL, cGraphResizeGr32, cGraphResizeWinGDI, cGraphResizeFMX, cGraphResizeWinWIC, cGraphResizeWinBlt, cGraphLoader, cGraphLoader.Resolution, cGraphBitmap, cGraphResizeWinThumb;




procedure TfrmResample.LateInitialize;
begin
 btnHB.Visible      := AppData.RunningHome;
 btnHBQckDwn.Visible:= AppData.RunningHome;
 btnHBHard.Visible  := AppData.RunningHome;

 Path.Path:= AppData.CurFolder;

 LoadForm(Self);
 AlphaBlend:= FALSE;

 Files.SelectFirstItem;
 SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
 BmpOut:= Vcl.Graphics.TBitmap.Create;

 Show;

 btnOrigClick(Self);
 //actMsThumbnailsExecute(Self);
end;



procedure TfrmResample.FormDestroy(Sender: TObject);
begin
 SaveForm(Self, flFull);
 FreeAndNil(BmpOut);
 FreeAndNil(Loader);
end;








procedure TfrmResample.btnOrigClick(Sender: TObject);
begin
 FreeAndNil(Loader);   //ToDo 1: disable all buttons if Loader = nil;
 if FileExistsMsg(Files.FileName) then
  begin
   Loader:= LoadGraph(Files.FileName);
   Preview.Picture.Assign(Loader);
   Preview.Stretch := chkStretch.Checked;
  end;
end;


procedure TfrmResample.FilesDblClick(Sender: TObject);
VAR Width, Height: Integer;
begin
 GetImageRes(Files.FileName, Width, Height);
 Caption:= ' File: '+ Files.FileName+ ' - '+ GetFileSizeFormat(Files.FileName)+ i2s(Width)+ 'x'+ i2s(Height);

 btnOrigClick(Sender);
end;


procedure TfrmResample.btnRefreshClick(Sender: TObject);
begin
 Files.ReadFileNames;
end;


procedure TfrmResample.spnJanChange(Sender: TObject);
begin
  Caption:= ResampleFilters[spnJan.Value].Name;
end;


procedure TfrmResample.chkStretchClick(Sender: TObject);
begin
  Preview.Stretch:= chkStretch.Checked;
end;



{-------------------------------------------------------------------------------------------------------------
   SIZES
-------------------------------------------------------------------------------------------------------------}
function TfrmResample.Ratio: Double;
begin
 Result:= Loader.Width / Loader.Height;
end;


function TfrmResample.Scale: Double;
begin
 Result:= spnWidth.Value / Loader.Width;
end;


function TfrmResample.NewHeight: Integer;
begin
 Result:= RoundEx(spnWidth.Value / Ratio);
end;





{-------------------------------------------------------------------------------------------------------------
   Output
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.TimerStop(AlgorithmName: string; Time: Double);
begin
  VAR s:= IntToStr(Round(Time))+ 'ms';
  {$IFDEF HardID}
  s:= s+ ' / '+ ccCore.FormatBytes(ProcessCurrentMem, 2);
  {$ENDIF}
  s:= s+ ' ['+ AlgorithmName+ '] ';
  Caption:= s;
end;



function OutputFolder: string;
begin
  Result:= AppData.CurFolder+ 'Output\';
  ForceDirectoriesMsg(Result);
end;


function OutputFileName(CONST AlgorithmName: string; Time: Double): string;
begin
  Result:= OutputFolder+ AlgorithmName+ ' ('+ IntToStr(Round(Time)) +'ms).bmp'
end;


procedure TfrmResample.ShowOutput(FileName: string);
begin
  Preview.Picture.Bitmap.Assign(BmpOut);  // If we do Preview.Picture.Assign(BmpOut) directly, then the TImage.Stretch won't work!
  if chkSaveOutput.Checked
  then BmpOut.SaveToFile(FileName);
  Bip30;
end;



{-------------------------------------------------------------------------------------------------------------
   PREPARE INP/OUT
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.LoadInput32;
begin
  Caption:= '';
  Preview.Picture := NIL;

  // Unfortunatelly we have to reload the image as pf32
  FreeAndNil(Loader);                               //ToDo 1: disable all buttons if Loader = nil;
  if FileExistsMsg(Files.FileName)
  then Loader:= LoadGraph(Files.FileName);
  Loader.PixelFormat:= pf32bit;

  ClearBitmap(BmpOut);
  BmpOut.PixelFormat:= pf32bit;
  BmpOut.SetSize(spnWidth.Value, NewHeight);

  {$IFDEF HardID}
  if chkTrimRam.Checked then chHardID.TrimWorkingSet;
  {$ENDIF}
end;


procedure TfrmResample.LoadInput24;
begin
  Caption:= '';
  Preview.Picture := NIL;
  BmpOut.Assign(Loader);
  BmpOut.PixelFormat := pf24bit;

  {$IFDEF HardID}
  if chkTrimRam.Checked then chHardID.TrimWorkingSet;
  {$ENDIF}
end;


procedure TfrmResample.PrepareOutput24;
begin
  Caption:= '';
  Preview.Picture := NIL;
  ClearBitmap(BmpOut);
  BmpOut.PixelFormat := pf24bit;
  BmpOut.SetSize(spnWidth.Value, NewHeight);

  {$IFDEF HardID}
  if chkTrimRam.Checked then chHardID.TrimWorkingSet;
  {$ENDIF}
end;












{-------------------------------------------------------------------------------------------------------------
   1. JAN FX - Smooth Resize
   61 ms
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actJanFXSmoothResExecute(Sender: TObject);
CONST
    AlgorithmName= '01 JanFX SmoothResize';
begin
  PrepareOutput24;

  TimerStart;
  SmoothResize(Loader, BmpOut);        //  BmpOut.PixelFormat:= pf24bit;
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;


{-------------------------------------------------------------------------------------------------------------
   2. JAN FX - Stretch
   745 ms
   Resize down: very good but terribly slow (use BLT instead)
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actJanFxStretchExecute(Sender: TObject);
VAR AlgorithmName: string;
begin
  PrepareOutput24;
  AlgorithmName:= '02 JanFX Stretch-'+ i2s(spnJan.Value);

  TimerStart;
  janFxStretch.Stretch_(Loader, BmpOut, ResampleFilters[spnJan.Value].Filter, ResampleFilters[spnJan.Value].Width);
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;


{-------------------------------------------------------------------------------------------------------------
   3. GR32 - StretchImage
   184 ms
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actGr32Execute(Sender: TObject);
begin
  LoadInput24;

  TimerStart;
  cGraphResizeGr32.StretchGr32(BmpOut, Scale, Scale, spnGr32Filter.Value, MitchellKernel);
  TimerStop('03 Gr32-'+ i2s(spnGr32Filter.Value), TimerElapsed);

  ShowOutput(OutputFileName('03 Gr32 '+ i2s(spnGr32Filter.Value), TimerElapsed));
end;


{-------------------------------------------------------------------------------------------------------------
   HB
   570 ms

   Resize down: VERY smooth. Better q than JanFX.SmoothResize.
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actHBResizeExecute(Sender: TObject);
CONST AlgorithmName= '04 HB';
begin
  Loader.PixelFormat:= pf24bit;
  PrepareOutput24;

  TimerStart;
  {$IFDEF 3RDPARTY}
  GraphHBResize.HSmoothResize(Loader, BmpOut, spnWidth.Value, newHeight); {$ENDIF}
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;


procedure TfrmResample.btnHBQckDwnClick(Sender: TObject);
CONST AlgorithmName= '04a HB HardDownscale';
begin
  LoadInput24;

  TimerStart;
  {$IFDEF 3RDPARTY} GraphHBResize.QuickDownscaleFac2(BmpOut); {$ENDIF}
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;


procedure TfrmResample.btnHBHardClick(Sender: TObject);
CONST AlgorithmName= '04c HB QuickDownScale';
begin
  LoadInput24;

  TimerStart;
  {$IFDEF 3RDPARTY} GraphHBResize.HardDownscaleFac2(BmpOut); {$ENDIF}
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;



{-------------------------------------------------------------------------------------------------------------
   MadShi
   FAST!
   Same timing, same quality.

   I think it is the same algorithm as SmoothResizeASM.
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actMadshiExecute(Sender: TObject);
CONST AlgorithmName= '05 madGraphics';
begin
  Caption:= '';
  Preview.Picture := NIL;

  LoadInput32;                                 // Madshi is the only one that requires pf32
  BmpOut.Assign(Loader);                       // Strange. MadShi requires the output image to be present in BmpOut
  BmpOut.SetSize(spnWidth.Value, NewHeight);

  TimerStart;
  GraphMadGraphics32.StretchBitmap32(Loader, BmpOut);
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;



{-------------------------------------------------------------------------------------------------------------
   Embarcadero ScaleImage
   190 ms

   BEST (in scale down)
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actScaleImageExecute(Sender: TObject);
CONST AlgorithmName= '06 VCL.ScaleImage';
begin
  PrepareOutput24;

  TimerStart;
  cGraphResizeVCL.ScaleImage(Loader, BmpOut, Scale);
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;



{-------------------------------------------------------------------------------------------------------------
   DELPHI STRETCHDRAW
   40 ms
   The worst image quality when scaling up.
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actDephiStrtchDrwExecute(Sender: TObject);
CONST AlgorithmName= '07 VCL.Stretch';
begin
  PrepareOutput24;

  TimerStart;
  cGraphResizeVCL.CanvasStretch(Loader, BmpOut);
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;



{-------------------------------------------------------------------------------------------------------------
   MMX
   76 ms
   Very good to resize up but not down.
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actResizeMMXExecute(Sender: TObject);
CONST AlgorithmName= '08 SmoothResize ASM';
begin
  PrepareOutput24;

  TimerStart;
  BmpOut:= GraphSmoothResizeASM.SmoothResizeMMX(Loader, spnWidth.Value, NewHeight);
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;



{-------------------------------------------------------------------------------------------------------------
   Microsoft Thumb
   88 ms

   Resize down:
     Too smooth, distorts the image, However, it improves the colors.
     Fastest ever!
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actMsThumbnailsExecute(Sender: TObject);
CONST AlgorithmName= '09 Windows.Thumbnail';
begin
  PrepareOutput24;

  TimerStart;
  VAR ThumbObj:= cGraphResizeWinThumb.TFileThumb.Create;
  TRY
    ThumbObj.Width    := spnWidth.Value;
    ThumbObj.FilePath := Files.FileName;             // whenever you set a FilePath a new ThumbBmp is made
    ThumbObj.GenerateThumbnail;
    BmpOut.Assign(ThumbObj.ThumbBmp);
  FINALLY
    FreeAndNil(ThumbObj);
  END;

  TimerStop(AlgorithmName, TimerElapsed);
  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;


{-------------------------------------------------------------------------------------------------------------
   BITBLT
   150 ms
--------------------------------------------------------------------------------------------------------------
  Resize down: VERY smooth. Better than JanFX.SmoothResize.
  Resize up: better (sharper) than JanFX.SmoothResize
  Time: similar to JanFx }
procedure TfrmResample.actBitBltExecute(Sender: TObject);
CONST AlgorithmName= '10 Windows.StretchBlt';
begin
  LoadInput24;

  TimerStart;
  Stretch(BmpOut, spnWidth.Value, NewHeight);
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;



{-------------------------------------------------------------------------------------------------------------
   FMX
   Absolutelly the slowest!
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actFMXGraphicsExecute(Sender: TObject);
CONST AlgorithmName = '11 FMX.CreateThumbnail';
begin
  LoadInput32;
  BmpOut.Assign(Loader);

  TimerStart;
  ResizeFMX(BmpOut, spnWidth.Value, NewHeight);
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;



{-------------------------------------------------------------------------------------------------------------
   WIC
   Resize down: too smooth, too slow
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actWicExecute(Sender: TObject);
CONST AlgorithmName= '12 Windows.WIC';
begin
  LoadInput32;                                 // Madshi is the only one that requires pf32
  BmpOut.Assign(Loader);                       // Strange. MadShi requires the output image to be present in BmpOut

  TimerStart;
  cGraphResizeWinWIC.ResizeBitmapWic(BmpOut, spnWidth.Value, NewHeight);  // pf32
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;


procedure TfrmResample.actGDIExecute(Sender: TObject);
CONST AlgorithmName= '13 Windows.GDI';
begin
  LoadInput24;
  //BmpOut.Assign(Loader);

  TimerStart;
  cGraphResizeWinGDI.ResizeBitmapGDI(Loader, BmpOut, spnWidth.Value, NewHeight);
  TimerStop(AlgorithmName, TimerElapsed);

  ShowOutput(OutputFileName(AlgorithmName, TimerElapsed));
end;


end.
