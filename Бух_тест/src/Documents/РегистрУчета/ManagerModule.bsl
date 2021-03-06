#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьОписаниеРегистра(ВидРегистра, НачалоПериода, КонецПериода, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	ОписаниеРегистра = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра, "Наименование") 
		+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоПериода, КонецПериода);

	ОписаниеРегистра = ОписаниеРегистра + " " 
		+ БухгалтерскиеОтчетыВызовСервераПовтИсп.ПолучитьТекстОрганизация(Организация, ВключатьОбособленныеПодразделения);
	
	Возврат ОписаниеРегистра;
	
КонецФункции

Функция ПолучитьФорматСохраненияРегистров() Экспорт
	
	ФорматРегистра = Константы.ФорматСохраненияРегистровУчета.Получить();
	Возврат ?(ЗначениеЗаполнено(ФорматРегистра), ФорматРегистра, Перечисления.ФорматыСохраненияОтчетов.PDF);
	
КонецФункции

Функция ПолучитьСвойстваПрисоединенногоФайлаРегистра(РегистрУчета) Экспорт
	
	СвойстваФайла = Новый Структура("ПрисоединенныйФайл, ПодписанЭП");
	СвойстваФайла.ПрисоединенныйФайл = Справочники.РегистрУчетаПрисоединенныеФайлы.ПустаяСсылка();
	СвойстваФайла.ПодписанЭП = Ложь;
	
	Если НЕ ЗначениеЗаполнено(РегистрУчета) Тогда
		Возврат СвойстваФайла;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("ВладелецФайла", РегистрУчета);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрУчетаПрисоединенныеФайлы.Ссылка КАК ПрисоединенныйФайл,
	|	РегистрУчетаПрисоединенныеФайлы.ПодписанЭП
	|ИЗ
	|	Справочник.РегистрУчетаПрисоединенныеФайлы КАК РегистрУчетаПрисоединенныеФайлы
	|ГДЕ
	|	РегистрУчетаПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СвойстваФайла, Выборка);
	КонецЕсли;
	
	Возврат СвойстваФайла;
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Регистр учета""';uk='Реєстр документів ""Регістр обліку""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Номер", "Неопределено");
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли