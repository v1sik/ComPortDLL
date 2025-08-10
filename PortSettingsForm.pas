unit PortSettingsForm;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, // <- добавлено StdCtrls для TButton
  CPortCtl, // TComComboBox
  CPort,
  ComPortLib, Vcl.ExtCtrls;    // TComPort

type
  TFormComSettings = class(TForm)
    cbComPort: TComComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    cbBaudRate: TComComboBox;
    rgParity: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FComPort: TComPort;
  public
    procedure InitMenu(AComPort: TComPort);
  end;

implementation

{$R *.dfm}



procedure TFormComSettings.FormCreate(Sender: TObject);
begin
  // Комбо автоматически наполняется доступными портами
end;



procedure TFormComSettings.InitMenu(AComPort: TComPort);
begin
  FComPort := AComPort;
  if Assigned(FComPort) then
  begin
    // Связываем компонент с портом — при выборе порт сразу применяется
    cbComPort.ComPort := FComPort;
    // Инициализация: если уже был установлен порт, отобразим его
    cbComPort.Text := FComPort.Port;
    cbBaudRate.ComPort := FComPort;
    cbBaudRate.Text := IntToStr(BaudRateEnumToInt(FComPort.BaudRate));
    rgParity.ItemIndex := ParityToRadioIndex(FComPort.Parity.Bits);
  end;
end;

procedure TFormComSettings.btnOKClick(Sender: TObject);
  var
  OldPort: string;
  OldBaud: string;
  OldParity: Integer;
begin
  // Сохраняем старые настройки
  OldPort := FComPort.Port;
  OldBaud := BaudRateToStr (FComPort.BaudRate);
  OldParity := ParityToRadioIndex (FComPort.Parity.Bits);

  CloseComPort();

  if Assigned(FComPort) then
    SetComPort(PAnsiChar(AnsiString(cbComPort.Text)), StrToInt(cbBaudRate.Text), rgParity.ItemIndex);

  if not OpenComPort() then
  begin
    // Если не удалось — откатываем старые настройки
    SetComPort( PAnsiChar(AnsiString(OldPort)), StrToInt(OldBaud), OldParity);
    OpenComPort();
    // Оставляем окно открытым
    ModalResult := mrNone;
  end;
end;


end.

