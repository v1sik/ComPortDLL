# ComPortDLL

Библиотека для работы с COM-портами на Delphi с графическим окном настройки параметров.  
Реализует открытие, закрытие, отправку и приём данных, а также интерактивное окно для изменения настроек порта.  
Библиотека совместима с проектами на других ЯП. Передача данных осучествляется массивами байт, а стек передаваеммый в функции формируется по stdcall стандарту.

## Архитектура проекта

Проект состоит из двух основных модулей:

1. **ComPortLib.pas** — основная логика работы с COM-портом.  
   Содержит глобальный объект `TComPort` и функции для управления:
   - первичная инициализация при загрузке библиотеки;
   - открытие и закрытие COM port;
   - установка параметров COM port;
   - обмен данными через открытый COM port;
   - возврат текущей конфигурации COM port;
   - преобразование значений в значение скоростей и битов чётности. (Используется во внутренней логике);

2. **PortSettingsForm.pas** — форма настроек COM-порта.  
   Использует компоненты из `CPortCtl` для выбора доступных портов, скоростей и битов чётности.  
   Вызывается через `ShowComPortSettings` из основной библиотеки.

---

## Описание функций

### `procedure ShowComPortSettings(ParentHandle: HWND); stdcall;`
Показывает форму настройки COM-порта.

**Параметры:**
- `ParentHandle` — дескриптор окна, которое будет владельцем формы.
- При отправке с параметром равным нулю окно откроется без привязки.

---

### `function OpenComPort: Boolean;`
Открывает COM-порт с текущими настройками.  
Возвращает `True`, если порт успешно открыт.

---

### `procedure CloseComPort;`
Закрывает COM-порт, если он открыт.

---

### `procedure SetDataMessage(Buffer: PByte; BufferSize: Integer); stdcall;`
Отправляет данные в порт.

**Параметры:**
- `Buffer` — указатель на буфер с данными.
- `BufferSize` — количество байт для отправки.

---

### `function GetDataMessage(Buffer: PByte; BufferSize: Integer): Integer; stdcall;`
Читает данные из COM-порта.

**Параметры:**
- `Buffer` — указатель на буфер для приёма.
- `BufferSize` — размер буфера.

**Возвращает:** количество реально записанных в буфер байт.

---

### `procedure SetComPort(strComPort: PAnsiChar; strBaudRate: Integer; strParityBits: Integer); stdcall;`
Устанавливает новые настройки порта.

**Параметры:**
- `strComPort` — строка с именем порта (в формате, `"COM3"`,  `"COM12"` и т.д.).
- `strBaudRate` — скорость (например, `9600`).
- `strParityBits` — код бита чётности:
  - `0` — нет (`None`)
  - `1` — нечётная (`Odd`)
  - `2` — чётная (`Even`)

---

### `function GetComPortConfigStr(Buffer: PAnsiChar; BufferSize: Integer): Integer; stdcall;`
Возвращает текущую конфигурацию порта в виде строки:  
`<PortName>, <BaudRate>, <ParityBits>`

**Параметры:**
- `Buffer` — указатель на буфер для записи строки.
- `BufferSize` — размер буфера.

**Возвращает:** длину записанной строки.

---

### Служебные (внутренние) функции преобразования

- `function IntToBaudRateEnum(const S: Integer): TBaudRate;` — целое → enum скорости.
- `function BaudRateEnumToInt(BR: TBaudRate): Integer;` — enum скорости → целое.
- `function RadioIndexToParity(Index: Integer): TParityBits;` — индекс радио-кнопки (в меню) → enum чётности.
- `function ParityToRadioIndex(P: TParityBits): Integer;` — enum чётности → индекс радио-кнопки (в меню).

---

## Примеры использования

### Открытие и закрытие порта
```delphi
if OpenComPort then
  ShowMessage('Порт открыт')
else
  ShowMessage('Ошибка открытия порта');

CloseComPort;
```

---

### Установка параметров и открытие
```delphi
SetComPort('COM3', 9600, 0); // COM3, 9600, без чётности
if OpenComPort then
  ShowMessage('Порт открыт с новыми параметрами');
```

---

### Отправка данных
```delphi
var
  Msg: AnsiString;
begin
  Msg := 'Hello, COM!';
  SetDataMessage(PByte(@Msg[1]), Length(Msg));
end;
```

---

### Приём данных
```delphi
var
  Buffer: array[0..255] of Byte;
  BytesRead: Integer;
begin
  BytesRead := GetDataMessage(@Buffer, SizeOf(Buffer));
  if BytesRead > 0 then
    ShowMessage('Получено: ' + AnsiString(PAnsiChar(@Buffer[0])));
end;
```

---

### Получение текущей конфигурации
```delphi
var
  Buf: array[0..255] of AnsiChar;
begin
  GetComPortConfigStr(@Buf, SizeOf(Buf));
  ShowMessage('Конфигурация: ' + string(Buf));
end;
```

---

### Вызов формы настройки
```delphi
ShowComPortSettings(Application.Handle);
```

---

## Логика формы настроек

`TFormComSettings`:
- `cbComPort` — список доступных портов.
- `cbBaudRate` — список скоростей.
- `rgParity` — выбор бита чётности.
- `btnOK` / `btnCancel` — кнопки применения или отмены.

При нажатии **OK**:
1. Сохраняются старые параметры.
2. Закрывается порт.
3. Применяются новые параметры.
4. Порт открывается заново.
5. Если открыть не удалось — параметры откатываются и окно остаётся открытым.

---

В основе лежит библиотека: https://github.com/CWBudde/ComPort-Library

---
