
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Отбор = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Оборудование"));
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
