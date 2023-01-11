program EritrositCounter;

uses
  Vcl.Forms,
  UnitFormUtama in 'UnitFormUtama.pas' {FormUtama},
  About in 'About.pas' {Tentang},
  UnitFormBuffer in 'UnitFormBuffer.pas' {FormBuffer},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TFormUtama, FormUtama);
  Application.CreateForm(TFormBuffer, FormBuffer);
  Application.CreateForm(TTentang, Tentang);
  Application.CreateForm(TFormBuffer, FormBuffer);
  Application.Run;
end.
