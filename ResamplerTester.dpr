program ResamplerTester;

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF }
  WinApi.Windows,
  VCL.Forms,
  TesterForm in 'TesterForm.pas' {frmResample},
  cbAppData in '..\..\LightSaber\cbAppData.pas',
  ccINIFile in '..\..\LightSaber\ccINIFile.pas',
  cGraphResize in '..\..\LightSaber\cGraphResize.pas',
  cGraphResizeGr32 in '..\..\LightSaber\cGraphResizeGr32.pas',
  GraphSmoothResizeASM in 'C:\Projects-3rd_Packages\Third party packages\GraphSmoothResizeASM.pas',
  GraphMadGraphics32 in 'C:\Projects-3rd_Packages\Third party packages\GraphMadGraphics32.pas',
  janFX in 'C:\Projects-3rd_Packages\Third party packages\JanFX\janFX.pas',
  janFxStretch in 'C:\Projects-3rd_Packages\Third party packages\JanFX\janFxStretch.pas',
  FormRamLog in '..\..\LightSaber\FormRamLog.pas',
  cGraphResizeVCL in '..\..\LightSaber\cGraphResizeVCL.pas',
  cGraphResizeParamFrame in '..\..\LightSaber\cGraphResizeParamFrame.pas',
  cGraphResizeParams in '..\..\LightSaber\cGraphResizeParams.pas',
  cGraphResizeWin in '..\..\LightSaber\cGraphResizeWin.pas',
  cGraphResizeFMX in '..\..\LightSaber\cGraphResizeFMX.pas',
  GraphHBResize in 'C:\Projects-3rd_Packages\Third party packages\GraphHBResize.pas';

{$R *.res}

begin
  CONST MultiThreaded= FALSE; // True => Only if we need to use multithreading in the Log.
  AppData:= TAppData.Create('LightSaber Resizer Test', '', TRUE, MultiThreaded); { Absolutelly critical if you use the SaveForm/LoadForm functionality. This string will be used as the name of the INI file. }
  AppData.CreateMainForm(TfrmResample, frmResample, FALSE, FALSE, flFull);
  TfrmRamLog.CreateGlobalLog;
  Application.Run;
end.

