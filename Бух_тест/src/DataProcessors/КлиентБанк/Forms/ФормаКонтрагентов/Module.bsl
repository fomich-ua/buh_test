
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьПометки(Флаг = Неопределено)
	
	Если Флаг <> Неопределено Тогда
		ФлагДляУстановки = Флаг;
	КонецЕсли;
	
	Для каждого Строка Из ТаблицаКонтрагентов.ПолучитьЭлементы() Цикл
		Если Флаг = Неопределено Тогда
			ФлагДляУстановки = Строка.Пометка;
		КонецЕсли;
		
		Строка.Пометка = ФлагДляУстановки;
		
		Если ФлагДляУстановки Тогда
			Строка.ЭтоРодитель = Истина;
		КонецЕсли;
		
		Для каждого ВнСтрока Из Строка.ПолучитьЭлементы() Цикл
			Если ВнСтрока.ПолучитьЭлементы().Количество() > 0 Тогда
				ВнСтрока.Пометка = ФлагДляУстановки;
				Если ФлагДляУстановки Тогда
					ВнСтрока.ЭтоРодитель = Истина;
				КонецЕсли;
			Иначе
				ВнСтрока.ЭтоРодитель = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьДеревоКонтрагентовВХранилище()
	
	ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("ТаблицаКонтрагентов"), АдресХранилищаКонтрагентов);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - РАБОТА МЕХАНИЗМА ДЛИТЕЛЬНЫХ ОПЕРАЦИЙ

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ЗагрузитьПодготовленныеДанные()
	
	СтруктураДанныхНаКлиенте = Новый Структура();
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат СтруктураДанныхНаКлиенте;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ДеревоКонтрагентов") Тогда
		ЗначениеВРеквизитФормы(СтруктураДанных.ДеревоКонтрагентов, "ТаблицаКонтрагентов");
		ПоместитьДеревоКонтрагентовВХранилище();
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("МассивКонтрагентов")
		И СтруктураДанных.МассивКонтрагентов.Количество() > 0 Тогда
		СтруктураДанныхНаКлиенте.Вставить("МассивКонтрагентов", СтруктураДанных.МассивКонтрагентов);
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("СтекОповещений")
		И СтруктураДанных.СтекОповещений.Количество() > 0 Тогда
		СтруктураДанныхНаКлиенте.Вставить("СтекОповещений", СтруктураДанных.СтекОповещений);
	КонецЕсли;
	
	Возврат СтруктураДанныхНаКлиенте;
	
КонецФункции

// Функция создает ненайденные элементы - контрагентов, договора, банковские счета
//
&НаСервере
Функция СоздатьНенайденное(ИБФайловая)
	
	ДеревоКонтрагентов = РеквизитФормыВЗначение("ТаблицаКонтрагентов");
	
	СтекОповещений      = Новый Массив;
	СтруктураПараметров = Новый Структура("ДеревоКонтрагентов, ГруппаДляНовыхКонтрагентов,
		|Организация, МассивКонтрагентов, СтекОповещений",
		ДеревоКонтрагентов, ГруппаДляНовыхКонтрагентов, Организация, Неопределено, СтекОповещений);
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.КлиентБанк.ФоноваяЗагрузкаКонтрагентов(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru='Создание контрагентов, договоров, банковских счетов из обработки ""Клиент-банк""';uk='Створення контрагентів, договорів, банківських рахунків з обробки ""Клієнт-банк""'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.КлиентБанк.ФоноваяЗагрузкаКонтрагентов",
			СтруктураПараметров, 
			НаименованиеЗадания);
		
		АдресХранилища = Результат.АдресХранилища;	
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		Результат.Вставить("СтруктураДанныхКлиента", ЗагрузитьПодготовленныеДанные());
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьПодготовленныеДанныеНаКлиенте(СтруктураДанныхКлиента)
	
	Если СтруктураДанныхКлиента.Свойство("МассивКонтрагентов")
		И СтруктураДанныхКлиента.МассивКонтрагентов.Количество() > 0 Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru='Добавлены контрагенты, банковские счета и договоры';uk='Додані контрагенти, банківські рахунки і договори'")
			,,, БиблиотекаКартинок.КлиентБанкКомандаЗагрузить);
		
	КонецЕсли; 
	
	Оповестить("СозданиеНеНайденного");
	
	Если ТаблицаКонтрагентов.ПолучитьЭлементы().Количество() = 0 Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ <Дерево контрагентов>

&НаКлиенте
Процедура СнятьВсеПометки(Команда)
	
	УстановитьПометки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеПометки(Команда)
	
	УстановитьПометки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтрагентовПометкаПриИзменении(Элемент)
	
	// количество элементов в ветви дерева заведомо небольшое, поэтому операцию
	// выполняем на клиенте
	
	ТекущийЭлементДерева = ТаблицаКонтрагентов.НайтиПоИдентификатору(Элементы.ДеревоКонтрагентов.ТекущаяСтрока);
	
	РодительЭлемента = ТекущийЭлементДерева.ПолучитьРодителя();
	Если РодительЭлемента <> Неопределено Тогда
		Если ТекущийЭлементДерева.Пометка Тогда
			РодительЭлемента.Пометка = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ПодчиненныеТекущемуЭлементы = ТекущийЭлементДерева.ПолучитьЭлементы();
	
	Для каждого ПодчиненныйЭлемент Из ПодчиненныеТекущемуЭлементы Цикл
		Если ТекущийЭлементДерева.ЭтоРодитель Тогда
			ПодчиненныйЭлемент.Пометка = ТекущийЭлементДерева.Пометка;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура Создать(Команда)
	
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	Результат  = СоздатьНенайденное(ИБФайловая);
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
		ИдентификаторЗадания    = Результат.ИдентификаторЗадания;
		АдресХранилища          = Результат.АдресХранилища;
	Иначе
		ЗагрузитьПодготовленныеДанныеНаКлиенте(Результат.СтруктураДанныхКлиента);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ГруппаДляНовыхКонтрагентов = Параметры.ГруппаДляНовыхКонтрагентов;
	Организация                = Параметры.Организация;
	АдресХранилищаКонтрагентов = Параметры.АдресХранилищаКонтрагентов;
	ДеревоКонтрагентов         = ПолучитьИзВременногоХранилища(АдресХранилищаКонтрагентов);
	
	ЗначениеВРеквизитФормы(ДеревоКонтрагентов, "ТаблицаКонтрагентов");
	УстановитьПометки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДКЛЮЧАЕМЫЕ ОБРАБОТЧИКИ

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			ЗагрузитьПодготовленныеДанныеНаКлиенте(ЗагрузитьПодготовленныеДанные());
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры
