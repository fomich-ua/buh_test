
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Вариант = Новый Структура;
	Вариант.Вставить("ИмяОтчета",    "ЗадолженностьПокупателейПоСрокамДолга");
	Вариант.Вставить("КлючВарианта", "ЗадолженностьПокупателейПоСрокамДолга");
	
	БухгалтерскиеОтчетыКлиент.ОткрытьВариантОтчета(Вариант);
	
КонецПроцедуры
