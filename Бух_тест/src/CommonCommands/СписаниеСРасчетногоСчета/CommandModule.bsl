
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);	
	ОткрытьФорму("Документ.СписаниеСРасчетногоСчета.Форма.ФормаДокумента", ПараметрыФормы);
	
КонецПроцедуры
