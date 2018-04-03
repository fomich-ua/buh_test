#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СотрудникиФормыВнутренний.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ об увольнении
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказов";
	КомандаПечати.Идентификатор = "ПФ_MXL_П4";
	КомандаПечати.Представление = НСтр("ru='Приказ об увольнении';uk='Наказ про звільнення'");
	
	// Приказ об увольнении (Word)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказов";
	КомандаПечати.Идентификатор = "ПФ_MXL_П4";
	КомандаПечати.Представление = НСтр("ru='Приказ об увольнении (Word)';uk='Наказ про звільнення (Word)'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ФорматWord2007;
	КомандаПечати.ФорматСохранения = ТипФайлаТабличногоДокумента.DOCX;
	
	
	// Приказ о приеме
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказов";
	КомандаПечати.Идентификатор = "ПФ_MXL_П1";
	КомандаПечати.Представление = НСтр("ru='Приказ о приеме';uk='Наказ про прийом'");
	
	// Приказ о приеме (Word)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказов";
	КомандаПечати.Идентификатор = "ПФ_MXL_П1";
	КомандаПечати.Представление = НСтр("ru='Приказ о приеме (Word)';uk='Наказ про прийом (Word)'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ФорматWord2007;
	КомандаПечати.ФорматСохранения = ТипФайлаТабличногоДокумента.DOCX;
	
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СотрудникиФормы.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

#КонецЕсли