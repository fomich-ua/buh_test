
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастройкиОбновленияКонфигурации = ОбновлениеКонфигурации.ПолучитьСтруктуруНастроекПомощника();
	
	ЗаполнитьЗначенияСвойств(Объект, НастройкиОбновленияКонфигурации);
	Объект.РасписаниеПроверкиНаличияОбновления = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Объект.РасписаниеПроверкиНаличияОбновления);
	
	УстановитьВидимостьРасписания(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПроверятьНаличиеОбновленияПриЗапускеПриИзменении(Элемент)
	
	УстановитьВидимостьРасписания(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОткрытьРасписаниеНажатие(Элемент)
	
	Если Объект.РасписаниеПроверкиНаличияОбновления = Неопределено Тогда
		Объект.РасписаниеПроверкиНаличияОбновления = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Объект.РасписаниеПроверкиНаличияОбновления);
	ОписаниеОповещения = Новый ОписаниеОповещения("НадписьОткрытьРасписаниеНажатиеЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОчиститьСообщения();
	НастройкиИзменены = (Параметры.ПроверятьНаличиеОбновленияПриЗапуске <> Объект.ПроверятьНаличиеОбновленияПриЗапуске
		И (Параметры.ПроверятьНаличиеОбновленияПриЗапуске = 1 ИЛИ Объект.ПроверятьНаличиеОбновленияПриЗапуске = 1))
		ИЛИ Строка(Параметры.РасписаниеПроверкиНаличияОбновления) <> Строка(Объект.РасписаниеПроверкиНаличияОбновления);
		
	Если НастройкиИзменены Тогда
		ПериодПовтораВТечениеДня = Объект.РасписаниеПроверкиНаличияОбновления.ПериодПовтораВТечениеДня;
		Если ПериодПовтораВТечениеДня > 0 И ПериодПовтораВТечениеДня < 60 * 5 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Интервал проверки не может быть задан чаще, чем один раз 5 минут.';uk='Інтервал перевірки не може бути заданий частіше, ніж один раз 5 хвилин.'"));
			Возврат;
		КонецЕсли;
			
		НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске = Объект.ПроверятьНаличиеОбновленияПриЗапуске;
		НастройкиОбновленияКонфигурации.КодПользователяСервераОбновлений = Объект.КодПользователяСервераОбновлений;
		НастройкиОбновленияКонфигурации.ПарольСервераОбновлений = ?(Объект.ЗапомнитьПарольСервераОбновлений, Объект.ПарольСервераОбновлений, "");
		НастройкиОбновленияКонфигурации.ЗапомнитьПарольСервераОбновлений = Объект.ЗапомнитьПарольСервераОбновлений;
		НастройкиОбновленияКонфигурации.РасписаниеПроверкиНаличияОбновления = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Объект.РасписаниеПроверкиНаличияОбновления);
		
		ЗаписатьНастройки(НастройкиОбновленияКонфигурации);
		ОбновлениеКонфигурацииКлиент.ПодключитьОтключитьПроверкуПоРасписанию(Объект.ПроверятьНаличиеОбновленияПриЗапуске = 1 И
			Объект.РасписаниеПроверкиНаличияОбновления <> Неопределено);
		
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодПользователяИПароль(Команда)
	
	ПерейтиПоНавигационнойСсылке(
		ОбновлениеКонфигурацииКлиент.ПолучитьПараметрыОбновления().АдресСтраницыИнформацииОПолученииДоступаКПользовательскомуСайту);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьРасписания(Форма)
	
	НадписьОткрытьРасписание = Форма.Элементы.НадписьОткрытьРасписание;
	НадписьОткрытьРасписание.Заголовок = ТекстНадписиОткрытьРасписание(Форма);
	
	Если Форма.Объект.ПроверятьНаличиеОбновленияПриЗапуске = 1 Тогда
		НадписьОткрытьРасписание.Доступность = Истина;
	Иначе
		НадписьОткрытьРасписание.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстНадписиОткрытьРасписание(Форма)
	
	СтроковоеПредставлениеРасписания = Строка(Форма.Объект.РасписаниеПроверкиНаличияОбновления);
	Возврат ?(Не ПустаяСтрока(СтроковоеПредставлениеРасписания),
		СтроковоеПредставлениеРасписания, НСтр("ru='Не задано';uk='Не задано'"));
		
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗаписатьНастройки(НастройкиОбновленияКонфигурации)
	
	ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации);
	ОбновитьПовторноИспользуемыеЗначения(); // сбрасываем кеш для применения настроек
	
КонецФункции

&НаКлиенте
Процедура НадписьОткрытьРасписаниеНажатиеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		Объект.РасписаниеПроверкиНаличияОбновления = Расписание;
	КонецЕсли;
	
	Элементы.НадписьОткрытьРасписание.Заголовок = ТекстНадписиОткрытьРасписание(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ЗакрытаФормаНастройкиОбновленияКонфигурации");
	
КонецПроцедуры

#КонецОбласти
