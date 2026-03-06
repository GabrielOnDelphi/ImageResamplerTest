program ResamplerTester;

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF}
  WinApi.Windows,
  VCL.Forms,
  TesterForm in 'TesterForm.pas' {frmResample},
  LightCore.INIFile in '..\LightSaber\LightCore.INIFile.pas',
  LightVcl.Visual.AppData in '..\LightSaber\FrameVCL\LightVcl.Visual.AppData.pas',
  LightVcl.Visual.AppDataForm in '..\LightSaber\FrameVCL\LightVcl.Visual.AppDataForm.pas',
  LightCore.AppData in '..\LightSaber\LightCore.AppData.pas';

{$R *.res}

begin
  CONST MultiThreaded= FALSE; // True => Only if we need to use multithreading in the Log.
  AppData:= TAppData.Create('LightSaber Resizer Test', '', MultiThreaded); { Absolutelly critical if you use the SaveForm/LoadForm functionality. This string will be used as the name of the INI file. }
  AppData.CreateMainForm(TfrmResample, TRUE, TRUE, asFull);
  AppData.Run;
end.

