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
  {$IFDEF AUTOPILOT}Autopilot.Bridge.Vcl in 'c:\Projects\Projects AI\Autopilot for Delphi\Source\Bridge\Autopilot.Bridge.Vcl.pas',{$ENDIF}{Optional}
  LightCore.AppData in '..\LightSaber\LightCore.AppData.pas';

{$R *.res}

begin
  CONST MultiThreaded= FALSE; // True => Only if we need to use multithreading in the Log.
  AppData:= TAppData.Create('LightSaber Resizer Test', '', MultiThreaded); { Absolutelly critical if you use the SaveForm/LoadForm functionality. This string will be used as the name of the INI file. }
  Application.MainFormOnTaskbar:= TRUE;
  AppData.CreateMainForm(TfrmResample, asFull);

  { Optional: Via Autopilot, Claude can run/debug/test this program for you.
    For example, press "03. GR32 StretchGr32" & check the resized image in Preview.
    Don't have AUTOPILOT? Undefine $AUTOPILOT or get it from www.GabrielMoraru.com }
  {$IFDEF AUTOPILOT}
   Autopilot.Bridge.Vcl.StartBridge;
  {$ENDIF}
  AppData.Run;
end.

