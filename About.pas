unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, JPEG, ShellAPI;

type
  TTentang = class(TForm)
    OKBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Simbol: TImage;
    Label4: TLabel;
    Label2: TLabel;
    LabelWebsite: TLabel;
    procedure LabelWebsiteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Tentang: TTentang;

implementation

uses UnitFormUtama;

{$R *.dfm}

procedure TTentang.LabelWebsiteClick(Sender: TObject);
var
  HTML_File: string;
begin
  try
    HTML_File := 'http://www.miconos.co.id/';
    ShellExecute(Handle, 'open', PChar(HTML_File), nil, nil, SW_SHOW);
  except end;
end;

end.
