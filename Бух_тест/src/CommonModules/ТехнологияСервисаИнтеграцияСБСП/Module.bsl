////////////////////////////////////////////////////////////////////////////////
// Подсистема "Информационный центр".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Базовая функциональность

// См. ОбщегоНазначения.WSПрокси()
//
Функция WSПрокси(
			Знач АдресWSDL,
			Знач URIПространстваИмен,
			Знач ИмяСервиса,
			Знач ИмяТочкиПодключения = "",
			Знач ИмяПользователя,
			Знач Пароль,
			Знач Таймаут = Неопределено,
			Знач ДелатьКонтрольныйВызов = Ложь) Экспорт
	
	Возврат ОбщегоНазначения.WSПрокси(АдресWSDL,
			URIПространстваИмен,
			ИмяСервиса,
			ИмяТочкиПодключения,
			ИмяПользователя,
			Пароль,
			Таймаут,
			ДелатьКонтрольныйВызов);
	
КонецФункции

Функция ЗначениеВСтрокуXML(Знач Значение) Экспорт
	Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(Значение);
КонецФункции

Процедура УстановитьРазделениеСеанса(Знач Использование, Знач ОбластьДанных = Неопределено) Экспорт
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Использование, ОбластьДанных);
	
КонецПроцедуры

Процедура ЗаблокироватьИБ(Знач ПроверитьОтсутствиеДругихСеансов = Истина) Экспорт
	
	ОбщегоНазначения.ЗаблокироватьИБ(ПроверитьОтсутствиеДругихСеансов);
	
КонецПроцедуры

Процедура РазблокироватьИБ() Экспорт
	ОбщегоНазначения.РазблокироватьИБ();
КонецПроцедуры

Функция ПредметСтрокой(Знач СсылкаНаПредмет) Экспорт
	Возврат ОбщегоНазначения.ПредметСтрокой(СсылкаНаПредмет);
КонецФункции

// См. ОбщегоНазначенияПовтИсп.РазделениеВключено()
//
Функция РазделениеВключено() Экспорт
	
	Возврат ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
КонецФункции

// См. ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных()
//
Функция ДоступноИспользованиеРазделенныхДанных() Экспорт
	
	Возврат ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных();
	
КонецФункции

// См. ОбщегоНазначенияПовтИсп.ЗначениеРазделителяСеанса()
//
Функция ЗначениеРазделителяСеанса() Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРазделителяСеанса();
	
КонецФункции

Функция РазделительВспомогательныхДанных() Экспорт
	Возврат ОбщегоНазначенияПовтИсп.РазделительВспомогательныхДанных();
КонецФункции

// См. ОбщегоНазначения.ПриСозданииНаСервере()
//
Функция ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Возврат ОбщегоНазначения.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецФункции

// См. ОбщегоНазначенияКлиентСервер.МенеджерОбъектаПоПолномуИмени()
//
Функция МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъектаМетаданных)
	
КонецФункции

// См. СтандартныеПодсистемыПовтИсп.ЭтоПлатформа83БезРежимаСовместимости()
//
Функция ЭтоПлатформа83БезРежимаСовместимости() Экспорт 
	
	Возврат ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости();
	
КонецФункции

// См. ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу()
//
Процедура ДополнитьТаблицу(ТаблицаИсточник, ТаблицаПриемник) Экспорт
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаИсточник, ТаблицаПриемник);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОбщегоНазначенияКлиентСервер

// См. ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует()
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует(ПолноеИмяПодсистемы);
	
КонецФункции

// См. ОбщегоНазначенияКлиентСервер.ОбщийМодуль()
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ОбщийМодуль(Имя);
	
КонецФункции

// См. ОбщегоНазначенияКлиентСервер.ОтображениеОбычнойГруппыЛиния()
//
Функция ОтображениеОбычнойГруппыЛиния() Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ОтображениеОбычнойГруппыЛиния();
	
КонецФункции

Функция КодОсновногоЯзыка() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
КонецФункции

Функция СравнитьВерсии(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СтрокаВерсии1, СтрокаВерсии2);
КонецФункции

Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных = Неопределено,
		Знач Поле = "",
		Знач ПутьКДанным = "",
		Отказ = Ложь) Экспорт
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияПользователю,
		КлючДанных,	Поле, ПутьКДанным, Отказ);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СтроковыеФункцииКлиентСервер

Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки,
	Параметр1, Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
КонецФункции

Функция ЭтоУникальныйИдентификатор(Знач Строка) Экспорт
	Возврат СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Строка);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Базовая функциональность в модели сервиса

// См. СообщенияВМоделиСервисаПовтИсп.ТипТело()
//
Функция ТипТело() Экспорт 
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// См. РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса()
//
Функция КонечнаяТочкаМенеджераСервиса() Экспорт
	
	Возврат РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса();
	
КонецФункции

// См. РаботаВМоделиСервиса.ПараметрыВыборки()
//
Функция ПараметрыВыборки(ПолноеИмяОбъектаМетаданных) Экспорт 
	
	Возврат РаботаВМоделиСервиса.ПараметрыВыборки(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

Процедура ЗаблокироватьТекущуюОбластьДанных(Знач ПроверитьОтсутствиеДругихСеансов = Ложь, Знач РазделяемаяБлокировка = Ложь) Экспорт
	РаботаВМоделиСервиса.ЗаблокироватьТекущуюОбластьДанных(ПроверитьОтсутствиеДругихСеансов, РазделяемаяБлокировка);
КонецПроцедуры

Процедура РазблокироватьТекущуюОбластьДанных() Экспорт
	РаботаВМоделиСервиса.РазблокироватьТекущуюОбластьДанных();
КонецПроцедуры

Функция ПолучитьМодельДанныхОбласти() Экспорт
	Возврат РаботаВМоделиСервисаПовтИсп.ПолучитьМодельДанныхОбласти();
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обмен сообщениями

// См. ОбменСообщениями.ОтправитьСообщение()
//
Процедура ОтправитьСообщение(КаналСообщений, ТелоСообщения, Получатель) Экспорт
	
	ОбменСообщениями.ОтправитьСообщение(КаналСообщений, ТелоСообщения, Получатель);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Пользователи

Функция ЭтоПолноправныйПользователь(Пользователь = Неопределено,
                                    ПроверятьПраваАдминистрированияСистемы = Ложь,
                                    УчитыватьПривилегированныйРежим = Истина) Экспорт
	
	Возврат Пользователи.ЭтоПолноправныйПользователь(Пользователь, ПроверятьПраваАдминистрированияСистемы, УчитыватьПривилегированныйРежим);
	
КонецФункции

