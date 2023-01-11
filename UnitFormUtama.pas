unit UnitFormUtama;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.ExtDlgs, JPEG;

type
  TFormUtama = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuOpen: TMenuItem;
    N1: TMenuItem;
    mnuKeluar: TMenuItem;
    ools1: TMenuItem;
    Help1: TMenuItem;
    TentangKami: TMenuItem;
    Processing1: TMenuItem;
    Grayscale1: TMenuItem;
    mnuEkualisasiHist: TMenuItem;
    hresholding1: TMenuItem;
    mnuLabelling: TMenuItem;
    mnuLuasan: TMenuItem;
    mnuFilterLuas: TMenuItem;
    Background1: TMenuItem;
    mnuLabellingBackground: TMenuItem;
    mnuLuasanBackground: TMenuItem;
    mnuFilterLuasBg: TMenuItem;
    mnuErosi: TMenuItem;
    mnuDilasi: TMenuItem;
    mnuRepaintImage: TMenuItem;
    PanelKanan: TPanel;
    btnFormBuffer: TButton;
    ListBox1: TListBox;
    btnHitung: TButton;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    lblJmlSel: TLabel;
    GroupBox1: TGroupBox;
    lblFileType: TLabel;
    lblSize: TLabel;
    lblLocation: TLabel;
    OPD: TOpenPictureDialog;
    GroupBox3: TGroupBox;
    CitraAwal: TImage;
    mnuMuatUlangCitra: TMenuItem;
    mnuSimpanCitra: TMenuItem;
    mnuHasilPengolahan: TMenuItem;
    SPD: TSavePictureDialog;
    ampilan1: TMenuItem;
    mnuUkuranAsli: TMenuItem;
    mnuSesuaiJendela: TMenuItem;
    Timer1: TTimer;
    Label1: TLabel;

    procedure _Grayscale;
    procedure _HistEqual;
    procedure _Thresholding;
    procedure _Labelling;
    procedure _Luasan;
    procedure _FilterLuas;

    //background operation
    procedure _bgLabelling;
    procedure _bgLuasan;
    procedure _bgFiltering;

    procedure _Erosi;
    procedure _Dilasi;

    procedure _TemplateMatching;

    procedure SavePicture;

    procedure mnuOpenClick(Sender: TObject);
    procedure btnFormBufferClick(Sender: TObject);
    procedure Grayscale1Click(Sender: TObject);
    procedure hresholding1Click(Sender: TObject);
    procedure mnuLabellingClick(Sender: TObject);
    procedure mnuFilterLuasClick(Sender: TObject);
    procedure mnuLuasanClick(Sender: TObject);
    procedure mnuLabellingBackgroundClick(Sender: TObject);
    procedure mnuLuasanBackgroundClick(Sender: TObject);
    procedure mnuFilterLuasBgClick(Sender: TObject);
    procedure mnuErosiClick(Sender: TObject);
    procedure mnuDilasiClick(Sender: TObject);
    procedure mnuRepaintImageClick(Sender: TObject);
    procedure TentangKamiClick(Sender: TObject);
    procedure btnHitungClick(Sender: TObject);
    procedure mnuEkualisasiHistClick(Sender: TObject);
    procedure mnuMuatUlangCitraClick(Sender: TObject);
    procedure mnuSimpanCitraClick(Sender: TObject);
    procedure mnuKeluarClick(Sender: TObject);
    procedure mnuHasilPengolahanClick(Sender: TObject);
    procedure mnuUkuranAsliClick(Sender: TObject);
    procedure mnuSesuaiJendelaClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormUtama: TFormUtama;

implementation

uses UnitFormBuffer, About;

var
  w, h                    : integer;
  nBg, nObjek             : integer;
  area, bgArea            : array[1..15000] of integer;

  HistogramGray           : Array[0..255]of Integer;
  HistogramRed            : Array[0..255]of Integer;
  HistogramGreen          : Array[0..255]of Integer;
  HistogramBlue           : Array[0..255]of Integer;
  Ro, Go, Bo, Gray        : Array[0..255]of byte;

  TempImage               : TPicture;
  waktu                   : boolean;
  awal, akhir             : TTime;

{$R *.dfm}

procedure TFormUtama.btnFormBufferClick(Sender: TObject);
begin
  FormBuffer.Width  := CitraAwal.Picture.Width;
  FormBuffer.Height := CitraAwal.Picture.Height;
  FormBuffer.ShowModal;
  //FormBuffer.Free;
end;

procedure TFormUtama.btnHitungClick(Sender: TObject);
label
  proses;
begin
  if(not(CitraAwal.Picture.Graphic = nil))then
    begin
    if(nObjek > 0)then
      begin
        nObjek              := 0;

        if(TempImage <> nil)then
          begin
            CitraAwal.Picture := TempImage;
            FormBuffer.CitraHasil.Picture.Assign(TempImage);
          end;

        lblJmlSel.Caption   := '-';

        goto proses;
      end
    else
      begin
        proses:
         awal := time;

        _Grayscale;
        _HistEqual;
        _Thresholding;
        _Labelling;
        _Luasan;
        _FilterLuas;
        _Erosi;
        _Dilasi;
        _Labelling;

        lblJmlSel.Caption   := IntToStr(nObjek);
        //lblJmlPerMl.Caption := IntToStr(Round((nObjek/250) / (0.265*0.195*0.01))) + ' ' + '/mL';

          if(mnuHasilPengolahan.Checked = true)then
            begin
              FormBuffer.Top  := 0;
              FormBuffer.Left := Screen.Width - FormBuffer.Width;
              FormUtama.Left  := (Screen.Width - FormBuffer.Width) - (FormUtama.Width + 10);
              FormBuffer.Show;
            end;
      end;
    end
  else
    begin
      MessageBox(self.Handle,'Anda belum mengambil file citra !','Konfirmasi',MB_OK + MB_ICONEXCLAMATION);
    end;
end;

procedure TFormUtama.FormCreate(Sender: TObject);
begin
  waktu := false;
  FormUtama.Top := 0;
end;

procedure TFormUtama.Grayscale1Click(Sender: TObject);
begin
  _Grayscale;
end;

procedure TFormUtama.hresholding1Click(Sender: TObject);
begin
_Thresholding;
end;

procedure TFormUtama.mnuDilasiClick(Sender: TObject);
begin
_Dilasi;
end;

procedure TFormUtama.mnuEkualisasiHistClick(Sender: TObject);
begin
_HistEqual;
end;

procedure TFormUtama.mnuErosiClick(Sender: TObject);
begin
_Erosi;
end;

procedure TFormUtama.mnuFilterLuasBgClick(Sender: TObject);
begin
_bgFiltering;
end;

procedure TFormUtama.mnuFilterLuasClick(Sender: TObject);
begin
_FilterLuas;
end;

procedure TFormUtama.mnuLabellingBackgroundClick(Sender: TObject);
begin
_bgLabelling;
end;

procedure TFormUtama.mnuLabellingClick(Sender: TObject);
begin
_Labelling;
end;

procedure TFormUtama.mnuLuasanBackgroundClick(Sender: TObject);
begin
_bgLuasan;
end;

procedure TFormUtama.mnuLuasanClick(Sender: TObject);
begin
  _Luasan;
end;

procedure TFormUtama.mnuRepaintImageClick(Sender: TObject);
begin
_TemplateMatching;
end;

procedure TFormUtama.TentangKamiClick(Sender: TObject);
begin
  Application.CreateForm(TTentang, Tentang);
  Tentang.ShowModal;
end;

procedure TFormUtama.Timer1Timer(Sender: TObject);
var
  lamaProses : double;
  strLama    : string;
begin
  if waktu = true then
    akhir := time;

  lamaProses  := (akhir - awal)*1000;
  Str(lamaProses:12:2,strLama);
  Label1.Caption := strLama;
end;

procedure TFormUtama.mnuOpenClick(Sender: TObject);
var
  FileType: string;
  CitraJPEG: TJPEGImage;
begin
  CitraJPEG := TJPEGImage.Create;
  TempImage := TPicture.Create;
  FormBuffer.Close;

  if OPD.Execute then
    try
      case OPD.FilterIndex of
        1: //*.jpeg, *.jpg
          begin
            FileType  := 'JPEG';
            CitraJPEG.LoadFromFile(OPD.FileName);
            CitraJPEG.DIBNeeded;
            CitraAwal.Picture.Bitmap.Assign(CitraJPEG);
            FormBuffer.CitraHasil.Picture.Bitmap.Assign(CitraJPEG);
          end;
        2: //*.bmp
          begin
            FileType  := 'Bitmap';
            CitraAwal.Picture.LoadFromFile(OPD.FileName);
            FormBuffer.CitraHasil.Picture.Assign(FormUtama.CitraAwal.Picture);
          end;
      end;
    finally
      if (CitraAwal.Picture <> nil) then
          TempImage.Assign(CitraAwal.Picture);

      nObjek  := 0;

      w := CitraAwal.Picture.Width;
      h := CitraAwal.Picture.Height;

      lblFileType.Caption := 'File Type : ' + FileType;
      lblSize.Caption     := 'Dimensions : ' + IntToStr(w) + 'x' + IntToStr(h);
      lblLocation.Caption := 'Location : ' + OPD.FileName;

      lblJmlSel.Caption   := '-';

      mnuMuatUlangCitra.Enabled := true;
      mnuSimpanCitra.Enabled    := true;
      mnuHasilPengolahan.Enabled:= true;
      mnuUkuranAsli.Enabled     := true;
      mnuSesuaiJendela.Enabled  := true;
    end;
end;

procedure TFormUtama.mnuMuatUlangCitraClick(Sender: TObject);
begin
  nObjek              := 0;
  FormBuffer.Close;

  if(TempImage <> nil)then
    begin
      CitraAwal.Picture := TempImage;
      FormBuffer.CitraHasil.Picture.Assign(TempImage);
    end;

  lblJmlSel.Caption   := '-';
end;

procedure TFormUtama.mnuSimpanCitraClick(Sender: TObject);
begin
  if SPD.Execute then SavePicture;
end;

procedure TFormUtama.mnuUkuranAsliClick(Sender: TObject);
begin
  CitraAwal.Proportional  := false;
  CitraAwal.Stretch       := false;
  if mnuUkuranAsli.Checked = false then
    begin
      mnuUkuranAsli.Checked   := true;
      mnuSesuaiJendela.Checked:= false;
    end
  else
    mnuUkuranAsli.Checked := false;
end;

procedure TFormUtama.mnuSesuaiJendelaClick(Sender: TObject);
begin
  CitraAwal.Proportional  := true;
  CitraAwal.Stretch       := true;
  if mnuSesuaiJendela.Checked = false then
    begin
      mnuSesuaiJendela.Checked  := true;
      mnuUkuranAsli.Checked     := false;
    end
  else
    mnuSesuaiJendela.Checked  := false;
end;

procedure TFormUtama.SavePicture;
var
  CitraJPEG : TJPEGImage;
begin
  CitraJPEG := TJPEGImage.Create;
  try
  case SPD.FilterIndex of
      1:  {*.jpeg; *.jpg}
      begin
        with CitraJPEG do
          begin
            Assign(CitraAwal.Picture.Bitmap);
            Smoothing           := True;
            ProgressiveEncoding := True;
          end;
        //bila tidak ada nama kembar..
        if not FileExists(SPD.FileName) then
          begin
            CitraJPEG.SaveToFile(SPD.FileName);
            OPD.FileName        := SPD.FileName;
          end
        else
          //bila ada nama kembar..
          if (Application.MessageBox(
            PChar('Nama file sudah digunakan' + #13 +
                  'Apakah anda ingin menggantikan file itu ?'),
            PChar('Konfirmasi'),
                   MB_YESNO or MB_ICONEXCLAMATION) = IDYES) then
              begin
                CitraJPEG.SaveToFile(SPD.FileName);
                OPD.FileName    := SPD.FileName;
              end; end;

      2:  {*.bmp}
      begin
      //bila tidak ada nama kembar..
      if not FileExists(SPD.FileName) then
        begin
          CitraAwal.Picture.SaveToFile(SPD.FileName);
          OPD.FileName          := SPD.FileName;
        end
      else
      //bila ada nama kembar..
      if (Application.MessageBox(
        PChar('Nama file sudah digunakan' + #13 +
              'Apakah anda ingin menggantikan file itu ?'),
        PChar('Konfirmasi'),
               MB_YESNO or MB_ICONEXCLAMATION) = IDYES) then
        begin
          CitraAwal.Picture.SaveToFile(SPD.FileName);
          OPD.FileName          := SPD.FileName;
        end;
      end; end;
  finally
    CitraAwal.Refresh;
    CitraJPEG.Free;
  end;
end;

procedure TFormUtama.mnuKeluarClick(Sender: TObject);
begin
  FormUtama.Free;
  CitraAwal.Free;
  FormBuffer.CitraHasil.Free;
  Close;
end;

procedure TFormUtama.mnuHasilPengolahanClick(Sender: TObject);
begin
  if mnuHasilPengolahan.Checked = false then
    begin
      mnuHasilPengolahan.Checked := true;
      if(nObjek > 0)then
        begin
          FormBuffer.Top  := 0;
          FormBuffer.Left := Screen.Width - FormBuffer.Width;
          FormUtama.Left  := (Screen.Width - FormBuffer.Width) - (FormUtama.Width + 10);
          FormBuffer.Show;
        end;
    end
  else
    begin
      mnuHasilPengolahan.Checked := false;
    end;
end;

{ ### ### ### FUNGSI - FUNSI PENGOLAHAN ### ### ### }

// CA = Citra Awal ; CH = Citra Hasil Pengolahan
// x  = panjang    ; y  = tinggi

//========================== GRAYSCALE ======================================
procedure TFormUtama._Grayscale;
var
  gray: byte;
  x, y:integer;
  CA, CH: PByteArray;
begin

  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      FormBuffer.CitraHasil.Picture.Bitmap.PixelFormat  := pf8bit;
      for y := 0 to h-1 do
        begin
          CA  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              CH[x]  := Round(0.114*CA[3*x]+0.587*CA[3*x+1]+0.299*CA[3*x+2]);
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
        begin
          CA  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              gray     := Round(0.114*CA[3*x]+0.587*CA[3*x+1]+0.299*CA[3*x+2]);
              CH[3*x]  := gray;
              CH[3*x+1]:= gray;
              CH[3*x+2]:= gray;
            end;
        end;
    end;
    FormBuffer.CitraKeabuan.Picture.Assign(FormBuffer.CitraHasil.Picture);
end;

 //========================== HISTOGRAM EQUALISATION=============================
procedure TFormUtama._HistEqual;
var
  x,y:integer;
  PA, pixelPointer:PByteArray;
begin
  try
    begin
      for x := 0 to 255 do
        begin
          HistogramGray[x]  := 0;
          HistogramRed[x]   := 0;
          HistogramGreen[x] := 0;
          HistogramBlue[x]  := 0;
        end;

      if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
        begin
          for y := 0 to h-1 do
            begin
              pixelPointer := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
              for x := 0 to w-1 do
                begin
                  Inc(HistogramGray[pixelPointer[y]]);
                end;
            end;

          for x := 1 to 255 do
            begin
              HistogramGray[x]   := HistogramGray[x-1]    +  HistogramGray[x];
            end;

          for x := 0 to 255 do
            begin
              Gray[x] := Round(255*HistogramGray[x]/(w*h));
            end;

          for y := 0 to h-1 do
            begin
              PA := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
              pixelPointer := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
              for x := 0 to w-1 do
                begin
                  pixelPointer[x]     := Gray[PA[x]];
                end;
            end;
        end;

      if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
        begin
          for y := 0 to h-1 do
            begin
              pixelPointer := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
              for x := 0 to w-1 do
                begin
                  Inc(HistogramBlue[pixelPointer[3*x]]);
                  Inc(HistogramGreen[pixelPointer[3*x+1]]);
                  Inc(HistogramRed[pixelPointer[3*x+2]]);
                end;
              end;

          for x := 1 to 255 do
            begin
              HistogramRed[x]   := HistogramRed[x-1]    +  HistogramRed[x];
              HistogramGreen[x] := HistogramGreen[x-1]  +  HistogramGreen[x];
              HistogramBlue[x]  := HistogramBlue[x-1]   +  HistogramBlue[x];
            end;

          for x := 0 to 255 do
            begin
              Ro[x] := Round(255*HistogramRed[x]/(w*h));
              Go[x] := Round(255*HistogramGreen[x]/(w*h));
              Bo[x] := Round(255*HistogramBlue[x]/(w*h));
            end;

          for y := 0 to h-1 do
            begin
              PA := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
              pixelPointer := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
              for x := 0 to w-1 do
                begin
                  pixelPointer[3*x]     := Bo[PA[3*x]];
                  pixelPointer[3*x+1]   := Go[PA[3*x+1]];
                  pixelPointer[3*x+2]   := Ro[PA[3*x+2]];
                end;
            end;
        end;
   end;
   FormBuffer.CitraEkualisasi.Picture.Assign(FormBuffer.CitraHasil.Picture);
  except
    Free;
  end;
end;

//========================== THRESHOLDING ======================================
procedure TFormUtama._Thresholding;
var
  gray: byte;
  x, y: integer;
  CA, CH: PByteArray;
begin
  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y:= 0 to h-1 do
        begin
        CA  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
        CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x:= 0 to w-1 do
            begin
              gray     := Round(0.114*CA[3*x]+0.587*CA[3*x+1]+0.299*CA[3*x+2]);
              if (gray < 83)then
                CH[x] := 0
              else
                CH[x] := 255;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y:= 0 to h-1 do
      begin
        CA  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
        CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
        for x:= 0 to w-1 do
          begin
            gray     := Round(0.114*CA[3*x]+0.587*CA[3*x+1]+0.299*CA[3*x+2]);
            if (gray < 83)
            then
              begin
                CH[3*x] := 0;
                CH[3*x+1] := 0;
                CH[3*x+2] := 0;
              end
            else
              begin
                CH[3*x] := 255;
                CH[3*x+1] := 255;
                CH[3*x+2] := 255;
              end
          end;
      end;
    end;
    FormBuffer.CitraPengambangan.Picture.Assign(FormBuffer.CitraHasil.Picture);
end;

//========================== LABELLING ======================================
procedure TFormUtama._Labelling;
var
  jml, x, y: integer;
  CH: PByteArray;
begin
  jml     := 0;
  nObjek  := 0;
  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y := 0 to h-1 do
        begin
          //CA  := CitraAwal.Picture.Bitmap.ScanLine[y];
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              if(CH[x] = 0)then
                begin
                  inc(jml);
                  FormBuffer.CitraHasil.Canvas.Brush.Color := TColor(jml);
                  FormBuffer.CitraHasil.Canvas.FloodFill(x,y,FormBuffer.CitraHasil.Canvas.Pixels[x,y],fsSurface);
                end;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
        begin
          //CA  := CitraAwal.Picture.Bitmap.ScanLine[y];
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              if(((CH[3*x] = 0)and
                (CH[3*x+1] = 0)and
                (CH[3*x+2] = 0)))then
                begin
                  inc(jml);
                  FormBuffer.CitraHasil.Canvas.Brush.Color := TColor(jml);
                  FormBuffer.CitraHasil.Canvas.FloodFill(x,y,FormBuffer.CitraHasil.Canvas.Pixels[x,y],fsSurface);
                end;
            end;
        end;
    end;
    nObjek  := jml;
    waktu := true;

    FormBuffer.CitraPelabelan.Picture.Assign(FormBuffer.CitraHasil.Picture);
end;

//========================== LUASAN ======================================
procedure TFormUtama._Luasan;
var
  px, x, y :integer;
  CH :PByteArray;
  R, G, B :integer;

begin
  for px := 1 to nObjek do
    begin
      area[px] := 0;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              for px := 1 to nObjek do
                begin
                  B := round((px and $FF0000)/65536);
                  G := round((px and $00FF00)/256);
                  R := round((px and $0000FF)/1);

                  if(CH[x]  = (B + G + R))then
                    begin
                      inc(area[px]);
                    end;
                end;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              for px := 1 to nObjek do
                begin
                  B := round((px and $FF0000)/65536);
                  G := round((px and $00FF00)/256);
                  R := round((px and $0000FF)/1);

                  if((CH[3*x]  = B)and
                    (CH[3*x+1] = G)and
                    (CH[3*x+2] = R))then
                    begin
                      inc(area[px]);
                    end;
                end;
            end;
        end;
        for px := 1 to nObjek do
          begin
            ListBox1.Items.Add(IntToStr(px) + '. ' + IntToStr(area[px]));
          end;
    end;
end;

//========================== FILTER LUAS ======================================
procedure TFormUtama._FilterLuas;
var
  px, x, y :integer;
  CH :PByteArray;
  R, G, B :integer;
begin
  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              for px := 1 to nObjek do
                begin
                  B := round((px and $FF0000)/65536);
                  G := round((px and $00FF00)/256);
                  R := round((px and $0000FF)/1);

                  if(CH[x] = (B + G + R))then
                    begin
                      if((area[px] > 150))then
                        begin
                          CH[x]   := 0;
                        end
                      else
                        begin
                          CH[x]   := 255;
                        end;
                    end;
                end;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              for px := 1 to nObjek do
                begin
                  B := round((px and $FF0000)/65536);
                  G := round((px and $00FF00)/256);
                  R := round((px and $0000FF)/1);

                  if( (CH[3*x]   = B)and
                      (CH[3*x+1] = G)and
                      (CH[3*x+2] = R) )then
                    begin
                      if((area[px] > 150))then
                        begin
                          CH[3*x]   := 0;
                          CH[3*x+1] := 0;
                          CH[3*x+2] := 0;
                        end
                      else
                        begin
                          CH[3*x]   := 255;
                          CH[3*x+1] := 255;
                          CH[3*x+2] := 255;
                        end;
                    end;
                end;
            end;
        end;
    end;

    _Luasan;
    FormBuffer.CitraFilterLuas.Picture.Assign(FormBuffer.CitraHasil.Picture);
end;

//================== BACKGROUND OPERATION ==================//

procedure TFormUtama._bgLabelling;
var
  jml, x, y: integer;
  CH: PByteArray;
begin
  jml  := 255;
  nBg  := 0;
  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              if(CH[x] = 255)then
                begin
                  dec(jml);
                  FormBuffer.CitraHasil.Canvas.Brush.Color := TColor(jml);
                  FormBuffer.CitraHasil.Canvas.FloodFill(x,y,FormBuffer.CitraHasil.Canvas.Pixels[x,y],fsSurface);
                end;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              if(((CH[3*x] = 255)and
                (CH[3*x+1] = 255)and
                (CH[3*x+2] = 255)))then
                begin
                  dec(jml);
                  FormBuffer.CitraHasil.Canvas.Brush.Color := TColor(jml);
                  FormBuffer.CitraHasil.Canvas.FloodFill(x,y,FormBuffer.CitraHasil.Canvas.Pixels[x,y],fsSurface);
                end;
            end;
        end;
    end;

    nBg := jml;
end;

procedure TFormUtama._bgLuasan;
var
  px, x, y :integer;
  CH :PByteArray;
  R, G, B :integer;

begin
  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              for px := 255 downto nBg do
                begin
                  B := round((px and $FF0000)/65536);
                  G := round((px and $00FF00)/256);
                  R := round((px and $0000FF)/1);

                  if(CH[x]  = (B + G + R))then
                    begin
                      inc(bgArea[px]);
                    end;
                end;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              for px := 255 downto nBg do
                begin
                  B := round((px and $FF0000)/65536);
                  G := round((px and $00FF00)/256);
                  R := round((px and $0000FF)/1);

                  if((CH[3*x]  = B)and
                    (CH[3*x+1] = G)and
                    (CH[3*x+2] = R))then
                    begin
                      inc(bgArea[px]);
                    end;
                end;
            end;
        end;
    end;
end;

procedure TFormUtama._bgFiltering;
var
  px, x, y :integer;
  CH :PByteArray;
  R, G, B :integer;
begin
  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              for px := 255 downto nBg do
                begin
                  B := round((px and $FF0000)/65536);
                  G := round((px and $00FF00)/256);
                  R := round((px and $0000FF)/1);

                  if(CH[x]   = (B + G + R))then
                    begin
                      if((bgArea[px] < 200))then
                        begin
                          CH[x]   := 0;
                        end
                      else
                        begin
                          CH[x]   := 255;
                        end;
                    end;
                end;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
        begin
          CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
          for x := 0 to w-1 do
            begin
              for px := 255 downto nBg do
                begin
                  B := round((px and $FF0000)/65536);
                  G := round((px and $00FF00)/256);
                  R := round((px and $0000FF)/1);

                  if( (CH[3*x]   = B)and
                      (CH[3*x+1] = G)and
                      (CH[3*x+2] = R) )then
                    begin
                      if((bgArea[px] < 200))then
                        begin
                          CH[3*x]   := 0;
                          CH[3*x+1] := 0;
                          CH[3*x+2] := 0;
                        end
                      else
                        begin
                          CH[3*x]   := 255;
                          CH[3*x+1] := 255;
                          CH[3*x+2] := 255;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

//================== END OF BG. OPERATION ==================//

//========================== EROSI =============================================
procedure TFormUtama._Erosi;
var
  x, y :integer;
  CAT, CA, CAB, CH :PByteArray;   //CHT, CHB
  TempImage: TImage;
begin
  TempImage := TImage.Create(nil);
  TempImage.Picture.Assign(FormBuffer.CitraHasil.Picture);

  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y := 0 to h-1 do
        begin
          if ((y > 0) and (y < (h-1))) then
            begin
              CAT := TempImage.Picture.Bitmap.ScanLine[y-1];
              CA  := TempImage.Picture.Bitmap.ScanLine[y];
              CAB := TempImage.Picture.Bitmap.ScanLine[y+1];

              CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];

              for x := 0 to w-1 do
                begin
                  if((x > 0) and (x < (w-1)))then
                    begin
                      if(CA[x] = 0)then
                        begin
                          if((CAT[x-1]  = 255)or
                             (CAT[x]    = 255)or
                             (CAT[x+1]  = 255)or
                             (CA[x-1]   = 255)or
                             (CA[x+1]   = 255)or
                             (CAB[x-1]  = 255)or
                             (CAB[x]    = 255)or
                             (CAB[x+1]  = 255))then
                            begin
                              CH[x] := 255;
                            end
                          else
                            begin
                              CH[x] := 0;
                            end;
                        end
                      else
                        begin
                          CH[x] := CA[x];
                        end;
                    end
                  else
                    begin
                      CH[x] := CA[x];
                    end;
                end;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
      begin
        if ((y > 0) and (y < (h-1))) then
          begin
            CAT := TempImage.Picture.Bitmap.ScanLine[y-1];
            CA  := TempImage.Picture.Bitmap.ScanLine[y];
            CAB := TempImage.Picture.Bitmap.ScanLine[y+1];

            CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];

            for x := 0 to w-1 do
              begin
                if((x > 0) and (x < (w-1)))then
                  begin
                    if((CA[3*x]   = 0)and
                       (CA[3*x+1] = 0)and
                       (CA[3*x+2] = 0))then  // jika objek hitam ditemukan
                      begin
                        if (((CAT[3*(x-1)]   = 255)and
                             (CAT[3*(x-1)+1] = 255)and
                             (CAT[3*(x-1)+2] = 255))or       // tetangga pojok kiri atas

                            ((CAT[3*x]   = 255)and
                             (CAT[3*x+1] = 255)and
                             (CAT[3*x+2] = 255))or       // tetangga atas

                            ((CAT[3*(x+1)]   = 255)and
                             (CAT[3*(x+1)+1] = 255)and
                             (CAT[3*(x+1)+2] = 255))or       // tetangga pojok kanan atas

                            ((CA[3*(x-1)]     = 255)and
                             (CA[(3*(x-1))+1] = 255)and
                             (CA[(3*(x-1))+2] = 255))or  // tetangga kiri

                            ((CA[3*(x+1)]     = 255)and
                             (CA[(3*(x+1))+1] = 255)and
                             (CA[(3*(x+1))+2] = 255))or  // tetangga kanan

                            ((CAB[3*(x-1)]   = 255)and
                             (CAB[3*(x-1)+1] = 255)and
                             (CAB[3*(x-1)+2] = 255))or  // tetangga pojok kiri bawah

                            ((CAB[3*x]   = 255)and
                             (CAB[3*x+1] = 255)and
                             (CAB[3*x+2] = 255))or   // tetangga bawah

                            ((CAB[3*(x+1)]   = 255)and
                             (CAB[3*(x+1)+1] = 255)and
                             (CAB[3*(x+1)+2] = 255)))then  // tetangga pojok kanan bawah
                          begin
                            CH[3*x]   := 255;
                            CH[3*x+1] := 255;
                            CH[3*x+2] := 255;
                          end
                        else
                          begin
                            CH[3*x]   := 0;
                            CH[3*x+1] := 0;
                            CH[3*x+2] := 0;
                          end;
                      end
                    else
                      begin
                        CH[3*x]   := CA[3*x];
                        CH[3*x+1] := CA[3*x+1];
                        CH[3*x+2] := CA[3*x+2];
                      end;
                    end
                else
                  begin
                    CH[3*x]   := CA[3*x];
                    CH[3*x+1] := CA[3*x+1];
                    CH[3*x+2] := CA[3*x+2];
                  end;
              end;
          end;
        end;
    end;
    FormBuffer.CitraErosi.Picture.Assign(FormBuffer.CitraHasil.Picture);
end;

//========================== DILASI =============================================
procedure TFormUtama._Dilasi;
var
  x, y :integer;
  CAT, CA, CAB, CHT, CH, CHB :PByteArray;
  TempImage: TImage;
begin
  TempImage := TImage.Create(nil);
  TempImage.Picture.Assign(FormBuffer.CitraHasil.Picture);

  if CitraAwal.Picture.Bitmap.PixelFormat = pf8bit then
    begin
      for y := 0 to h-1 do
        begin
          if ((y > 0) and (y < (h-1))) then
            begin
              CAT := TempImage.Picture.Bitmap.ScanLine[y-1];
              CA  := TempImage.Picture.Bitmap.ScanLine[y];
              CAB := TempImage.Picture.Bitmap.ScanLine[y+1];

              //CHT := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y-1];
              CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
              //CHB := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y+1];

              for x := 0 to w-1 do
                begin
                  if((x > 0) and (x < (w-1)))then
                    begin
                      if(CA[x] = 0)then
                        begin
                          if((CAT[x-1]  = 255)or
                             (CAT[x]    = 255)or
                             (CAT[x+1]  = 255)or
                             (CA[x-1]   = 255)or
                             (CA[x+1]   = 255)or
                             (CAB[x-1]  = 255)or
                             (CAB[x]    = 255)or
                             (CAB[x+1]  = 255))then
                            begin
                              CH[x] := 0;
                            end;
                        end
                      else
                        begin
                          CH[x] := CA[x];
                        end;
                    end
                  else
                    begin
                      CH[x] := CA[x];
                    end;
                end;
            end;
        end;
    end;

  if CitraAwal.Picture.Bitmap.PixelFormat = pf24bit then
    begin
      for y := 0 to h-1 do
      begin
        if ((y > 0) and (y < (h-1))) then
          begin
            CAT := TempImage.Picture.Bitmap.ScanLine[y-1];
            CA  := TempImage.Picture.Bitmap.ScanLine[y];
            CAB := TempImage.Picture.Bitmap.ScanLine[y+1];

            CHT := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y-1];
            CH  := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
            CHB := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y+1];

            for x := 0 to w-1 do
              begin
                if((x > 0) and (x < (w-1)))then
                  begin
                    if((CA[3*x]   = 0)and
                       (CA[3*x+1] = 0)and
                       (CA[3*x+2] = 0))then  // jika objek hitam ditemukan
                      begin
                        if (((CAT[3*(x-1)]   = 255)and
                             (CAT[3*(x-1)+1] = 255)and
                             (CAT[3*(x-1)+2] = 255))or       // tetangga pojok kiri atas

                            ((CAT[3*x]   = 255)and
                             (CAT[3*x+1] = 255)and
                             (CAT[3*x+2] = 255))or       // tetangga atas

                            ((CAT[3*(x+1)]   = 255)and
                             (CAT[3*(x+1)+1] = 255)and
                             (CAT[3*(x+1)+2] = 255))or       // tetangga pojok kanan atas

                            ((CA[3*(x-1)]     = 255)and
                             (CA[(3*(x-1))+1] = 255)and
                             (CA[(3*(x-1))+2] = 255))or  // tetangga kiri

                            ((CA[3*(x+1)]     = 255)and
                             (CA[(3*(x+1))+1] = 255)and
                             (CA[(3*(x+1))+2] = 255))or  // tetangga kanan

                            ((CAB[3*(x-1)]   = 255)and
                             (CAB[3*(x-1)+1] = 255)and
                             (CAB[3*(x-1)+2] = 255))or  // tetangga pojok kiri bawah

                            ((CAB[3*x]   = 255)and
                             (CAB[3*x+1] = 255)and
                             (CAB[3*x+2] = 255))or   // tetangga bawah

                            ((CAB[3*(x+1)]   = 255)and
                             (CAB[3*(x+1)+1] = 255)and
                             (CAB[3*(x+1)+2] = 255)))then  // tetangga pojok kanan bawah
                          begin
                            CHT[3*(x-1)]   := 0;
                            CHT[3*(x-1)+1] := 0;
                            CHT[3*(x-1)+2] := 0;
                            CHT[3*x]   := 0;
                            CHT[3*x+1] := 0;
                            CHT[3*x+2] := 0;
                            CHT[3*(x+1)]   := 0;
                            CHT[3*(x+1)+1] := 0;
                            CHT[3*(x+1)+2] := 0;

                            CH[3*(x-1)]     := 0;
                            CH[(3*(x-1))+1] := 0;
                            CH[(3*(x-1))+2] := 0;
                            CH[3*(x+1)]     := 0;
                            CH[(3*(x+1))+1] := 0;
                            CH[(3*(x+1))+2] := 0;

                            CHB[3*(x-1)]   := 0;
                            CHB[3*(x-1)+1] := 0;
                            CHB[3*(x-1)+2] := 0;
                            CHB[3*x]   := 0;
                            CHB[3*x+1] := 0;
                            CHB[3*x+2] := 0;
                            CHB[3*(x+1)]   := 0;
                            CHB[3*(x+1)+1] := 0;
                            CHB[3*(x+1)+2] := 0;
                          end
                        else
                          begin
                            CH[3*x]   := CA[3*x];
                            CH[3*x+1] := CA[3*x+1];
                            CH[3*x+2] := CA[3*x+2];
                          end;
                      end
                    else
                      begin
                        CH[3*x]   := CA[3*x];
                        CH[3*x+1] := CA[3*x+1];
                        CH[3*x+2] := CA[3*x+2];
                      end;
                    end
                else
                  begin
                    CH[3*x]   := CA[3*x];
                    CH[3*x+1] := CA[3*x+1];
                    CH[3*x+2] := CA[3*x+2];
                  end;
              end;
          end;
      end;
    end;
    FormBuffer.CitraDilasi.Picture.Assign(FormBuffer.CitraHasil.Picture);
end;

//========================== TEMPLATE MATCHING =================================
procedure TFormUtama._TemplateMatching;
var
  x, y        :integer;
  CA , CH, HA :PByteArray;
  TempImage   : TImage;
begin
  TempImage := TImage.Create(nil);
  TempImage.Picture.Assign(FormBuffer.CitraHasil.Picture);

  for y := 0 to h-1 do
    begin
      CA := CitraAwal.Picture.Bitmap.ScanLine[y];
      CH := TempImage.Picture.Bitmap.ScanLine[y];
      HA := FormBuffer.CitraHasil.Picture.Bitmap.ScanLine[y];
      for x := 0 to w-1 do
        begin
          if ((CH[3*x]=0)and(CH[3*x+1]=0)and(CH[3*x+2]=0)) then
            begin
              //FormHasil.Image1.Canvas.FloodFill(i,j,ImageAwal.Canvas.Pixels[i,j],fsSurface);
              HA[3*x]     := CA[3*x];
              HA[3*x+1]   := CA[3*x+1];
              HA[3*x+2]   := CA[3*x+2];
            end
          else
            begin
              HA[3*x]     := 255;
              HA[3*x+1]   := 255;
              HA[3*x+2]   := 255;
            end;
        end;
    end;
end;

{ ### ### ### ### ### ### ### ### ### ### ### ### }

end.

