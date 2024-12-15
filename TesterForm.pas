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
  cvIniFile, ccCore, ccINIFile, ccIO, cmIO, cvFileListBox, cvSplitter, cvMemo, cvCheckBox, cvPathEdit, cbAppdata;

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
    SpinEdit1               : TSpinEdit;
    spnGr32Filter           : TSpinEdit;
    btnHBQckDwn: TButton;
    btnHBHard: TButton;
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
    chkStretch: TCubicCheckBox;
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
    procedure LogDblClick                  (Sender: TObject);
    procedure SpinEdit1Change              (Sender: TObject);
    procedure chkStretchClick              (Sender: TObject);
  private
    BmpOut: Vcl.Graphics.TBitmap;
    Loader: Vcl.Graphics.TBitmap;
    function Ratio: Double;
    procedure LogTime(AlgorithmName: string; Time: Double);
    procedure Trim24;
    procedure Trim32;
    function  NewHeight: Integer;
    function  Scale: Double;
    procedure LateInitialize(VAR Msg: TMessage); message MSG_LateFormInit; // Called after the main form was fully initilized
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
   cGraphResize, cGraphResizeVCL, cGraphResizeGr32, cGraphResizeFMX, cGraphResizeWin, cGraphLoader, cGraphLoader.Resolution, cGraphBitmap, cGraphResizeMsThumb;




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
 actMsThumbnailsExecute(Self);
end;



procedure TfrmResample.FormDestroy(Sender: TObject);
begin
 SaveForm(Self, flFull);
 FreeAndNil(BmpOut);
 FreeAndNil(Loader);
end;








procedure TfrmResample.btnOrigClick(Sender: TObject);
begin
 FreeAndNil(Loader);
 if FileExistsMsg(Files.FileName) then
  begin
   Loader:= LoadGraph(Files.FileName);
   Loader.PixelFormat:= pf24bit;
   Preview.Picture.Assign(Loader);
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


procedure TfrmResample.SpinEdit1Change(Sender: TObject);
begin
  Caption:= ResampleFilters[SpinEdit1.Value].Name;
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


function OutputFolder: string;
begin
  Result:= AppData.CurFolder+ 'Output\';
  ForceDirectoriesMsg(Result);
end;


{-------------------------------------------------------------------------------------------------------------
   PREPARE
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.LogDblClick(Sender: TObject);
begin
  //Log.Lines.SaveToFile(OutputFolder+ 'Log.txt');
  Bip30;
end;


procedure TfrmResample.Trim24;
begin
  Caption:= '';
  Preview.Picture := NIL;
  ClearBitmap(BmpOut);
  BmpOut.PixelFormat:= pf24bit;
  Loader.PixelFormat:= pf24bit;

  {$IFDEF HardID}
  if chkTrimRam.Checked then chHardID.TrimWorkingSet;
  {$ENDIF}

  VAR NewHeight:= RoundEx(spnWidth.Value / Ratio);
  BmpOut.SetSize(spnWidth.Value, NewHeight);
end;


procedure TfrmResample.Trim32;
begin
  Caption:= '';
  Preview.Picture := NIL;
  ClearBitmap(BmpOut);
  BmpOut.PixelFormat:= pf32bit;
  Loader.PixelFormat:= pf32bit;

  {$IFDEF HardID}
  if chkTrimRam.Checked then chHardID.TrimWorkingSet;
  {$ENDIF}

  VAR NewHeight:= RoundEx(spnWidth.Value / Ratio);
  BmpOut.SetSize(spnWidth.Value, NewHeight);
end;


procedure TfrmResample.LogTime(AlgorithmName: string; Time: Double);
begin
  VAR s:= IntToStr(Round(Time))+ 'ms';
  {$IFDEF HardID}
  s:= s+ ' / '+ ccCore.FormatBytes(ProcessCurrentMem, 2);
  {$ENDIF}
  s:= s+ ' ['+ AlgorithmName+ '] ';
  Caption:= s;
end;


function OutputFileName(CONST AlgorithmName: string; Time: Double): string;
begin
  Result:= OutputFolder+ AlgorithmName+ ' ('+ IntToStr(Round(Time)) +'ms).bmp'
end;







{-------------------------------------------------------------------------------------------------------------
   1. JAN FX - Smooth Resize
   61 ms
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actJanFXSmoothResExecute(Sender: TObject);
CONST
    AlgorithmName= '01 JanFX SmoothResize';
begin
  Trim24;
  cGraphBitmap.FillBitmap(BmpOut, clYellowGreen);

  TimerStart;
  SmoothResize(Loader, BmpOut);        //  BmpOut.PixelFormat:= pf24bit;
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);

  Bip30;
end;


{-------------------------------------------------------------------------------------------------------------
   2. JAN FX - Stretch
   745 ms
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actJanFxStretchExecute(Sender: TObject);
VAR AlgorithmName: string;
begin
  Trim24;

  TimerStart;
  janFxStretch.Stretch_(Loader, BmpOut, ResampleFilters[SpinEdit1.Value].Filter, ResampleFilters[SpinEdit1.Value].Width);

  AlgorithmName:= '02 JanFX Stretch-'+ i2s(SpinEdit1.Value);
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;


{-------------------------------------------------------------------------------------------------------------
   3. GR32 - StretchImage
   184 ms
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actGr32Execute(Sender: TObject);
begin
  Trim24;
  BmpOut.Assign(Loader);

  TimerStart;
  cGraphResizeGr32.StretchGr32(BmpOut, Scale, Scale, spnGr32Filter.Value, MitchellKernel);
  LogTime('03 Gr32-'+ i2s(spnGr32Filter.Value), TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName('03 Gr32 '+ i2s(spnGr32Filter.Value), TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;


{-------------------------------------------------------------------------------------------------------------
   HB
   570 ms

   Resize down: VERY smooth. Better q than JanFX.SmoothResize.
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actHBResizeExecute(Sender: TObject);
CONST
    AlgorithmName= '04 HB';
begin
  Trim24;

  TimerStart;
  {$IFDEF 3RDPARTY}
  GraphHBResize.HSmoothResize(Loader, BmpOut, spnWidth.Value, newHeight); {$ENDIF}
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;


procedure TfrmResample.btnHBQckDwnClick(Sender: TObject);
CONST
    AlgorithmName= '04a HB HardDownscale';
begin
  Trim24;
  BmpOut.Assign(Loader);

  TimerStart;
  {$IFDEF 3RDPARTY} GraphHBResize.QuickDownscaleFac2(BmpOut); {$ENDIF}
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;


procedure TfrmResample.btnHBHardClick(Sender: TObject);
CONST
    AlgorithmName= '04c HB QuickDownScale';
begin
  Trim24;
  BmpOut.Assign(Loader);

  TimerStart;
  {$IFDEF 3RDPARTY} GraphHBResize.HardDownscaleFac2(BmpOut); {$ENDIF}
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;



{-------------------------------------------------------------------------------------------------------------
   MadShi
   FASTEST !!!!!

   I think it is the same algorithm as SmoothResizeASM.SmoothResizeMMX. Same timing, same quality. Madshi is a bit faster
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actMadshiExecute(Sender: TObject);
CONST
    AlgorithmName= '05 madGraphics';
begin
  Trim32;

  TimerStart;
  GraphMadGraphics32.StretchBitmap32(Loader, BmpOut);
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;



{-------------------------------------------------------------------------------------------------------------
   Embarcadero ScaleImage
   190 ms

   BEST (in scale down)
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actScaleImageExecute(Sender: TObject);
CONST
    AlgorithmName= '06 VCL.ScaleImage';
begin
  Trim24;
  TimerStart;
  cGraphResizeVCL.ScaleImage(Loader, BmpOut, Scale);
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;



{-------------------------------------------------------------------------------------------------------------
   DELPHI STRETCHDRAW
   40 ms
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actDephiStrtchDrwExecute(Sender: TObject);
CONST
    AlgorithmName= '07 VCL.Stretch';
begin
  Trim24;

  TimerStart;
  cGraphResizeVCL.CanvasStretch(Loader, BmpOut);
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;



{-------------------------------------------------------------------------------------------------------------
   MMX
   76 ms
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actResizeMMXExecute(Sender: TObject);
CONST
   AlgorithmName= '08 SmoothResize ASM';
begin
  Trim24;
  VAR NewHeight:= RoundEx(spnWidth.Value / ratio);
  TimerStart;
  BmpOut:= GraphSmoothResizeASM.SmoothResizeMMX(Loader, spnWidth.Value, NewHeight);
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;



{-------------------------------------------------------------------------------------------------------------
   Microsoft Thumb
   88 ms
-------------------------------------------------------------------------------------------------------------}
procedure TfrmResample.actMsThumbnailsExecute(Sender: TObject);
CONST
    AlgorithmName= '09 Windows.Thumbnail';
begin
  Trim24;

  VAR ThumbObj := cGraphResizeMsThumb.TFileThumb.Create;
  TRY
    ThumbObj.Size     := spnWidth.Value;
    ThumbObj.FilePath := Files.FileName;             // whenever you set a FilePath a new ThumbBmp is made

    TimerStart;
    ThumbObj.GenerateThumbnail;
    LogTime(AlgorithmName, TimerElapsed);


    // Show output
    ThumbObj.ThumbBmp.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
    Preview.Picture.Assign(ThumbObj.ThumbBmp);
    Bip30;
  FINALLY
    FreeAndNil(ThumbObj);
  END;
end;


{-------------------------------------------------------------------------------------------------------------
   BITBLT
   150 ms
-------------------------------------------------------------------------------------------------------------
  Resize down: VERY smooth. Better than JanFX.SmoothResize.
  Resize up: better (sharper) than JanFX.SmoothResize
  Time: similar to JanFx }
procedure TfrmResample.actBitBltExecute(Sender: TObject);
CONST
    AlgorithmName= '10 Windows.StretchBlt';
begin
  Trim24;
  BmpOut.Assign(Loader);

  TimerStart;
  Stretch(BmpOut, spnWidth.Value, NewHeight);                 // Resize the screen if it is the preview
  LogTime(AlgorithmName, TimerElapsed);

  // Show output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;



procedure TfrmResample.actFMXGraphicsExecute(Sender: TObject);
CONST
   AlgorithmName = '11 FMX.CreateThumbnail';
begin
  Trim24;
  BmpOut.Assign(Loader);

  TimerStart;
  ResizeFMX(BmpOut, spnWidth.Value, NewHeight);
  LogTime(AlgorithmName, TimerElapsed);

  // Save and display the output
  BmpOut.SaveToFile(OutputFileName(AlgorithmName, TimerElapsed));
  Preview.Picture.Assign(BmpOut);
  Bip30;
end;


end.


procedure TfrmResample.Button1Click(Sender: TObject);
VAR BMP1: TBitmap;
begin
  BMP1:= LoadGraph('c:\Projects\Projects GRAPH Resamplers\GLOBAL Tester\Medusa HiQ.jpg');
  BMP1.PixelFormat:= pf24bit;

  StretchGr32(BMP1, 0.03, 0.03);
  Preview.Picture.Assign(BMP1);
  BMP1.SaveToFile('c:\Projects\Projects GRAPH Resamplers\GLOBAL Tester\Medusa out.bmp');
end;

