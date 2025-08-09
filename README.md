# ComPortDLL

Библиотека для работы с COM-портами на Delphi с графическим окном настройки параметров.  
Реализует открытие, закрытие, отправку и приём данных, а также интерактивное окно для изменения настроек порта.

## Архитектура проекта

Проект состоит из двух основных модулей:

1. **ComPortLib.pas** — основная логика работы с COM-портом.  
   Содержит глобальный объект `TComPort` и функции для управления:
   - первияная инициализация при загрузке библиотеки;
   - открытие и закрытие COM port;
   - установка параметров COM port;
   - обмен данными через открытый COM port;
   - преобразование строк в значение скоростей и битов чётности. (Используется во внутренней логике)

2. **PortSettingsForm.pas** — форма настроек COM-порта.  
   Использует компоненты из `CPortCtl` для выбора доступных портов, скоростей и битов чётности.  
   Вызывается через `ShowComPortSettings` из основной библиотеки.

---

##  Функции доступные для использования

### Управление портом
- **`function OpenComPort: Boolean`**  
  Открывает COM-порт с текущими настройками. Возвращает `True` при успехе.

- **`procedure CloseComPort`**  
  Закрывает открытый порт.

- **`procedure SetComPort(const strComPort, strBaudRate: string; strParityBits: Integer)`**  
  Устанавливает параметры порта:  
  - `strComPort` — имя порта (`COM1`, `COM2` и т. д.),  
  - `strBaudRate` — скорость (`"9600"`, `"115200"` и т. д.),  
  - `strParityBits` — биты чётности (`0` — None, `1` — Odd, `2` — Even).

- **`procedure ShowComPortSettings(ParentHandle: HWND)`**  
  Открывает модальное окно для выбора COM-порта и его параметров.

---

### Передача и приём данных
- **`procedure SetDataMessage(const Msg: string)`**  
  Отправляет строку в открытый порт.

- **`function GetDataMessage: string`**  
  Считывает доступные данные из порта и возвращает их как строку.

---

### Вспомогательные функции (Не доступны из вне, используются во внутренней логике)
- **`function StrToBaudRateEnum(const S: string): TBaudRate`** — преобразует строку скорости в `TBaudRate`.
- **`function BaudRateEnumToStr(BR: TBaudRate): string`** — преобразует `TBaudRate` в строку.
- **`function RadioIndexToParity(Index: Integer): TParityBits`** — конвертирует индекс радио-кнопки в `TParityBits`.
- **`function ParityToRadioIndex(P: TParityBits): Integer`** — обратная конвертация.

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

## Пример использования

```delphi
// Показать форму настроек
ShowComPortSettings(Application.Handle);

// Открыть порт
if OpenComPort then
  SetDataMessage('Hello, COM!');

// Получить данные
var
  data: string;
begin
  data := GetDataMessage;
end;

