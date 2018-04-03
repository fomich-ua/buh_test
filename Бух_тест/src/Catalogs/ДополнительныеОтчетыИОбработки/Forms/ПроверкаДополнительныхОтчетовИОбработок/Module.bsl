#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКСписку(Команда)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ПроверкаДополнительныхОтчетовИОбработок", Истина);
	
	ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.Форма.ФормаСписка", ПараметрыОтбора);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Проверено(Команда)
	ОтметитьВыполнениеДела();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтметитьВыполнениеДела()
	
	ВерсияМассив  = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Метаданные.Версия, ".");
	ТекущаяВерсия = ВерсияМассив[0] + ВерсияМассив[1] + ВерсияМассив[2];
	ХранилищеОбщихНастроек.Сохранить("ТекущиеДела", "ДополнительныеОтчетыИОбработки", ТекущаяВерсия);
	
КонецПроцедуры

#КонецОбласти