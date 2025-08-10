unit PortSettingsForm;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, // <- ��������� StdCtrls ��� TButton
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
  // ����� ������������� ����������� ���������� �������
end;



procedure TFormComSettings.InitMenu(AComPort: TComPort);
begin
  FComPort := AComPort;
  if Assigned(FComPort) then
  begin
    // ��������� ��������� � ������ � ��� ������ ���� ����� �����������
    cbComPort.ComPort := FComPort;
    // �������������: ���� ��� ��� ���������� ����, ��������� ���
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
  // ��������� ������ ���������
  OldPort := FComPort.Port;
  OldBaud := BaudRateToStr (FComPort.BaudRate);
  OldParity := ParityToRadioIndex (FComPort.Parity.Bits);

  CloseComPort();

  if Assigned(FComPort) then
    SetComPort(PAnsiChar(AnsiString(cbComPort.Text)), StrToInt(cbBaudRate.Text), rgParity.ItemIndex);

  if not OpenComPort() then
  begin
    // ���� �� ������� � ���������� ������ ���������
    SetComPort( PAnsiChar(AnsiString(OldPort)), StrToInt(OldBaud), OldParity);
    OpenComPort();
    // ��������� ���� ��������
    ModalResult := mrNone;
  end;
end;


end.

