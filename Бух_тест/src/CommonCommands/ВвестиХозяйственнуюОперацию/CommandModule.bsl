
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму("РегистрСведений.КорреспонденцииСчетов.ФормаСписка", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
