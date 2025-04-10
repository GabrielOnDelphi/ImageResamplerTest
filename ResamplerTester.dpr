program ResamplerTester;

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF}
  WinApi.Windows,
  VCL.Forms,
  TesterForm in 'TesterForm.pas' {frmResample},
  cbAppDataVCL in '..\LightSaber\cbAppData.pas',
  FormRamLog in '..\LightSaber\FormRamLog.pas',
  ccINIFile in '..\LightSaber\ccINIFile.pas';

{$R *.res}

begin
  CONST MultiThreaded= FALSE; // True => Only if we need to use multithreading in the Log.
  AppData:= TAppData.Create('LightSaber Resizer Test', '', TRUE, MultiThreaded); { Absolutelly critical if you use the SaveForm/LoadForm functionality. This string will be used as the name of the INI file. }
  AppData.CreateMainForm(TfrmResample, frmResample, FALSE, FALSE, asFull);
  TfrmRamLog.CreateGlobalLog;
  AppData.Run;
end.

