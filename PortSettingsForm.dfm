object FormComSettings: TFormComSettings
  Left = 200
  Top = 200
  BorderStyle = bsDialog
  Caption = 'COMPort'
  ClientHeight = 213
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object cbComPort: TComComboBox
    Left = 20
    Top = 36
    Width = 145
    Height = 23
    ComProperty = cpPort
    Text = 'COM19'
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 199
    Top = 164
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 90
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cbBaudRate: TComComboBox
    Left = 20
    Top = 102
    Width = 145
    Height = 23
    ComProperty = cpBaudRate
    Text = '110'
    Style = csDropDownList
    ItemIndex = 1
    TabOrder = 3
  end
  object rgParity: TRadioGroup
    Left = 184
    Top = 20
    Width = 185
    Height = 105
    Caption = #1041#1080#1090' '#1095#1105#1090#1085#1086#1089#1090#1080
    Items.Strings = (
      #1053#1077#1090
      #1053#1077#1095#1105#1090#1085#1072#1103' '#1095#1105#1090#1085#1086#1089#1090#1100
      #1063#1105#1090#1085#1072#1103' '#1095#1105#1090#1085#1086#1089#1090#1100)
    TabOrder = 4
  end
end
