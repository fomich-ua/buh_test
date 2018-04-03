
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не РегламентированнаяОтчетностьКлиент.ПодключитьМенеджерЗвит1С(Истина) Тогда
		Возврат;
	КонецЕсли;

	ДополнитьВыгружаемыеДокументыНННаобычныеЦены(ПараметрКоманды);
	
	
	глМенеджерЗвит1С.ВыгрузитьДокумент(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьВыгружаемыеДокументыНННаобычныеЦены(МассивДокуменов);
	
	Если РегламентированнаяОтчетностьПереопределяемый.ИДКонфигурации() = "ЕРП" Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Док.НалоговаяДляРезерваНомераПриПродажаНижеОбычнойЦены КАК Ссылка
	               |ИЗ
	               |	Документ.НалоговаяНакладная КАК Док
	               |ГДЕ
	               |	Док.Ссылка В(&МассивДокументов)
	               |	И Док.ПродажаНижеОбычнойЦены
	               |	И Док.Дата > ДАТАВРЕМЯ(2015, 1, 1)
	               |	И НЕ Док.НалоговаяДляРезерваНомераПриПродажаНижеОбычнойЦены = ЗНАЧЕНИЕ(Документ.НалоговаяНакладная.ПустаяСсылка)
	               |	И НЕ Док.НалоговаяДляРезерваНомераПриПродажаНижеОбычнойЦены В (&МассивДокументов)
				   |";
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокуменов);
	
	ВыборкаНННаПревышениеОбычныхЦен = Запрос.Выполнить().Выбрать();
	Пока ВыборкаНННаПревышениеОбычныхЦен.Следующий() Цикл
		МассивДокуменов.Добавить(ВыборкаНННаПревышениеОбычныхЦен.Ссылка);	
	КонецЦикла;

КонецПроцедуры
