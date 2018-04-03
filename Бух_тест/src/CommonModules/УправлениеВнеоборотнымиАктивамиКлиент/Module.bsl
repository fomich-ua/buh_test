
//  Функция вовзращает ОС выбранное в текущей строке таблицы ОС документа для дальнешей передачи
// в функцию ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию. В случае невозможности
// определения ОС выдает сообщение об ошибке.
//
// Параметры
//  ПараметрыФормы   - Структура с параметрами заполнения, ключи структуры:
//  	Форма             - форма заполняемого документа
//  	Объект            - Значение основного реквизита формы - документа для заполнения
//  	ИмяТабличнойЧасти - Имя табличной части основных средств документа, значение по умолчанию "ОС"
//
// Возвращаемое значение:
//   СправочникСсылка.ОсновныеСредства, Неопределено - В случае невозможности определения ОС функция
//   	возвращает Неопределено, в противном случае функция возвращает значение ОС.
//
Функция ПолучитьОСДляЗаполнениеПоНаименованию(Параметры) Экспорт
	
	ОчиститьСообщения();
	
	Форма = Параметры.Форма;
	Объект = Параметры.Объект;
	Если Параметры.Свойство("ИмяТабличнойЧасти") Тогда
		ИмяТабличнойЧасти = Параметры.ИмяТабличнойЧасти;
	Иначе
		ИмяТабличнойЧасти = "ОС";
	КонецЕсли;
	
	Если Форма.Элементы[ИмяТабличнойЧасти].ТекущаяСтрока = Неопределено Тогда
		ТекстСообщения = НСтр("ru='Данные для заполнения отсутствуют.';uk='Дані для заповнення відсутні.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект." + ИмяТабличнойЧасти);
		Возврат Неопределено;
	КонецЕсли;
	
	ОсновноеСредство = Форма.Элементы[ИмяТабличнойЧасти].ТекущиеДанные.ОсновноеСредство;
	
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		ТекстСообщения = НСтр("ru='Не выбрано основное средство';uk='Не вибраний основний засіб'");
		ИндексСтроки = Формат(Объект[ИмяТабличнойЧасти].Индекс(Форма.Элементы[ИмяТабличнойЧасти].ТекущиеДанные), "ЧН=0; ЧГ=");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект." + ИмяТабличнойЧасти + "[" + ИндексСтроки + "].ОсновноеСредство");
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОсновноеСредство;
	
КонецФункции // ПолучитьОСДляЗаполнениеПоНаименованию()

