# Combinissimo
!!! The mod is not working yet !!!
!!! Its only in early stage of development !!

Combinissimo allows you to pack all your combinators into one small entity: 2x2 or 3x3. Very performant = vanilla perfomance. 

# Sources reference

## Modules

[EditorOpenClose](#EditorOpenClose)

[EntityInteractions](#EntityInteractions)

[EditorEntityInteractions](#EditorEntityInteractions)

[UI](#UI)

[CommonTypes](#CommonTypes)

## EntityInteractions

Contains handlers for normal game surface entities' open/close events

TODO

TBD Describe functions here!

###### Interfaces

[TBD_interface_name](#TBD_interface_name)

###### Functions

[TBD_function_name](

## EditorEntityInteractions

Contains handlers for editor surface entities' open/close events

TODO

TBD Describe functions here!

###### Interfaces

[TBD_interface_name](#TBD_interface_name)

###### Functions

[TBD_function_name](#TBD_function_name) - TBD_function_description TODO

[TBD_function_name](#TBD_function_name) - TBD_function_description TODO

[TBD_function_name](#TBD_function_name) - TBD_function_description TODO

[TBD_function_name](#TBD_function_name) - TBD_function_description TODO

## EditorOpenClose

Contains Editor entering/leaving code, surface creation, etc.

TBD Describe functions here!

###### Interfaces

[EditorSurface](#EditorSurface)

###### Functions

[getEditorSurface](#getEditorSurface) - gets an existing editor surface or creates a new one TODO

[enterEditor](#enterEditor) - moves player into editor TODO

[exitEditor](#exitEditor) - moves player out of editor TODO

## UI

Contains ui related functions

TBD Describe functions here!

### TBD_interface_name

###### interface

TBD (Interface description)

###### fields

- TBD_field_name: TBD_type - TBD_description

###### See also

TBD Add see also

### TBD_function_name

###### function

(TBD_param_name: TBD_type) -> TBD_type

TBD (Function description)

###### Returns

TBD

###### Params

- TBD_param_name - TBD

###### See also

TBD Add see also

## CommonTypes

### Signal

Сигнал

###### fields

- type: "item" - signal type (see Factorio API)
- name: "string" - signal name (see Factorio API)

### NamedSignal

###### interface

Signal icon and name (no value)

###### fields

- signalID: [Signal](#Signal)
- title: string

### SignalWithValue

###### interface

Signal and its value (no name)

###### fields

- signalID: [Signal](#Signal)
- title: string

### NamedSignalWithValue

###### interface

Signal icon, name and numeric signal value

###### fields

- namedSignal: [NamedSignal](#NamedSignal)
- value: number

### ProgramData

###### interface

One ProgramData can be installed on several Combonators instances.

###### fields

- ports: [NamedSignal](#NamedSignal)[]
- params:  [NamedSignal](#NamedSignal)[]
- combinatorLayout: [CombinatorLayout](#CombinatorLayout)

### CombonatorData

###### interface

Иконка, название и значение

###### fields

- program: [ProgramData](#ProgramData)
- name?: string
- paramValues: [SignalWithValue](#SignalWithValue)[] []

# TO DO

## Полезная информация
### Как включать файлы в lua
	function entities_tick() end - определение функции в файле
	require "ПАПКА.ФАЙЛ" - там где хотим использовать
	entities_tick() - просто вызываем и все
## Задачи

- ! По сути нужно все планировать с нуля, используя исходники лишь для reference - так будет проще и быстрее! Задачи делать как TODO указанные в документации.
- 
- 
- Сделать GUI по открытию Combonator
- Сделать GUI по открытию порта внутри редактора
- Сделать параметры
  - Сделать Entity
  - Сделать Item
  - Сделать Recipe
  - Сделать GUI по открытию параметра внутри редактора
- Нужно продумать структуру исходников выше
  - Генератор документации для Lua
    - https://github.com/lunarmodules/LDoc
  - Найти и разместить все функции которые уже есть.
  - Описать каждую функцию
  - Запланировать новые функции
- Нужно описать структуру исходников. Сделать readme.md файл
- Нужно разместить исходники соответственно
	- Структура
- Принцип создания коннекторов - забрать из Integrated Circuicity
	Сверить флаги и принцип создания коннекторов. Сделать также
		compact-combinator-io
		D:\G\Factorio\Factorio_1.0.0_dbg\mods\integratedCircuitry_0.18.1\prototypes\compact-combinator.lua
- Забрать внешний вид Editor Surface, если я еще не сделал свой нормально
## Идея мода - цели
 + Создаю комбинатор в идеале 1х1, но не принципиально
 - У комбинатора есть программы, у каждой программы - уникальное имя файла
	 - При нажатии на комбинатор 
		 - Показывается список доступных программ
		 - Можно выбрать программу для комбинатора
			 - При изменении программы для комбинатора в нем пересоздаются невидимые комбинаторы в соответствии с программой
		 - При выбранной программе
			 - Показывается информация о параметрах программы - точках подключения к комбинатору
	 - Программы можно редактировать, нажимая кнопку "Edit" рядом с программой
		 - Это открывает Surface редактирования и размещает на нем все комбинаторы
		 - После выхода программа автоматом сохряняется
		 - Для программ есть import/export в строку
			 - При импорте программа автоматом устанавливается во все комбинаторы где она выбрана
		 - После редактирования программы она автоматом устанавливается на все комбинаторы где она была выбрана ранее
## FUTURE Nice-to-have
 - Возможность задать именованные const-настройки программы
     - Имя для таких параметров хранится в общем programmable-speaker комбинаторе
     - В режиме редактирования при нажатии на комбинатор можно задать его имя
     - Такие настройки внутри debugger делаются при помощи const-combinator, 
             для которого в первой ячейке задается номер параметра
             В других ячейках задаются параметры по умолчанию
     - При задании таких параметров меняются сигналы соответствующего invisible-const-combinator

## TO DO-2 old
- inside - really long wire reach
	- Connector (Pole), autocreated
	- Constant
	- Decider
	- Speaker
	- Arithmetic
- outside - invisible
	- Connector (Pole)
	- Constant
	- Decider
	- Speaker
	- Arithmetic
- Mark combinator 
	- not recreated if primary entity is not opened, deleted after 5 minutes you don't open it
- Green test entities & items - saved, but not recreated
	- Test input (=constant combinator)
	- Test decider 
	- Test arithmetic
	- Test programmable speaker
- Primary entities 
	- b2x2
	- 3x3
- Adjustment of size of initial created connectors
