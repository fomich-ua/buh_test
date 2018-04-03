
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СообщениеВопрос = Параметры.СообщениеВопрос;
	СообщениеЗаголовок = Параметры.СообщениеЗаголовок;
	Заголовок = Параметры.Заголовок;
	Файлы = Параметры.Файлы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФайлы

&НаКлиенте
Процедура ФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайлСсылка = Файлы[ВыбраннаяСтрока].Значение;
	
	ПерсональныеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
	КакОткрывать = ПерсональныеНастройки.ДействиеПоДвойномуЩелчкуМыши;
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ФайлСсылка);
		ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ФайлСсылка,
		Неопределено,
		УникальныйИдентификатор);
	
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	
КонецПроцедуры

#КонецОбласти
