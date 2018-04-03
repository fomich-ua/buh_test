////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// Уведомим о появлении функционала рабочей даты
	НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("РабочаяДатаИзДокумента");
	
	// Показываем, если это новый документ и сама рабочая дата еще не установлена.
	НастройкиПредупреждений.РабочаяДатаИзДокумента = НастройкиПредупреждений.РабочаяДатаИзДокумента
		И Параметры.Ключ.Пустая()
		И НЕ ЗначениеЗаполнено(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата"));
	
	// Заполнение группы информационных ссылок
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтотОбъект, Элементы.ИнформационныеСсылки);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)


КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("ОбновитьФорму", ВладелецФормы, Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Модифицированность	= Истина;
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
		
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперацииПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаПриИзменении(Элемент)
	
	ЗаявкаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	УстановитьКурсДокумента();
	
	ОбновитьИнформациюОКурсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьКурсДокумента();
	
	ОбновитьИнформациюОКурсе();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратКурсоваяРазницаПродажаПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ЗатратКурсоваяРазница", "Субконто2ЗатратКурсоваяРазница", "Субконто3ЗатратКурсоваяРазница");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетЗатратКурсоваяРазница, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратКурсоваяРазница", "ЗаголовокСубконто2ЗатратКурсоваяРазница", "ЗаголовокСубконто3ЗатратКурсоваяРазница");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетЗатратКурсоваяРазница,, "ЗатратКурсоваяРазницаПродажа", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетДоходовКурсоваяРазницаПродажаПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ДоходовКурсоваяРазница", "Субконто2ДоходовКурсоваяРазница", "Субконто3ДоходовКурсоваяРазница");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетДоходовКурсоваяРазница, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ДоходовКурсоваяРазница", "ЗаголовокСубконто2ДоходовКурсоваяРазница", "ЗаголовокСубконто3ДоходовКурсоваяРазница");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетДоходовКурсоваяРазница,, "ДоходовКурсоваяРазницаПродажа", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратСебестоимостьПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ЗатратСебестоимость", "Субконто2ЗатратСебестоимость", "Субконто3ЗатратСебестоимость");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетЗатратСебестоимость, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратСебестоимость", "ЗаголовокСубконто2ЗатратСебестоимость", "ЗаголовокСубконто3ЗатратСебестоимость");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетЗатратСебестоимость,, "ЗатратСебестоимость", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетДоходовСебестоимостьПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ДоходовСебестоимость", "Субконто2ДоходовСебестоимость", "Субконто3ДоходовСебестоимость");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетДоходовСебестоимость, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ДоходовСебестоимость", "ЗаголовокСубконто2ДоходовСебестоимость", "ЗаголовокСубконто3ДоходовСебестоимость");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетДоходовСебестоимость,, "ДоходовСебестоимость", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратКомиссионныеПродажаПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ЗатратКомиссионные", "Субконто2ЗатратКомиссионные", "Субконто3ЗатратКомиссионные");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетЗатратКомиссионные, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратКомиссионные", "ЗаголовокСубконто2ЗатратКомиссионные", "ЗаголовокСубконто3ЗатратКомиссионные");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетЗатратКомиссионные,, "ЗатратКомиссионныеПродажа", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратКурсоваяРазницаПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ЗатратКурсоваяРазница", "Субконто2ЗатратКурсоваяРазница", "Субконто3ЗатратКурсоваяРазница");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетЗатратКурсоваяРазница, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратКурсоваяРазница", "ЗаголовокСубконто2ЗатратКурсоваяРазница", "ЗаголовокСубконто3ЗатратКурсоваяРазница");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетЗатратКурсоваяРазница,, "ЗатратКурсоваяРазница", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетДоходовКурсоваяРазницаПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ДоходовКурсоваяРазница", "Субконто2ДоходовКурсоваяРазница", "Субконто3ДоходовКурсоваяРазница");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетДоходовКурсоваяРазница, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ДоходовКурсоваяРазница", "ЗаголовокСубконто2ДоходовКурсоваяРазница", "ЗаголовокСубконто3ДоходовКурсоваяРазница");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетДоходовКурсоваяРазница,, "ДоходовКурсоваяРазница", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратКомиссионныеПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ЗатратКомиссионные", "Субконто2ЗатратКомиссионные", "Субконто3ЗатратКомиссионные");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетЗатратКомиссионные, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратКомиссионные", "ЗаголовокСубконто2ЗатратКомиссионные", "ЗаголовокСубконто3ЗатратКомиссионные");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетЗатратКомиссионные,, "ЗатратКомиссионные", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратПенсионныйПриИзменении(Элемент)

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1ЗатратПенсионный", "Субконто2ЗатратПенсионный", "Субконто3ЗатратПенсионный");
	ПоляОбъекта.Вставить("Организация",   Объект.Организация);
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетЗатратПенсионный, Объект, ПоляОбъекта);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратПенсионный", "ЗаголовокСубконто2ЗатратПенсионный", "ЗаголовокСубконто3ЗатратПенсионный");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект, Объект.СчетЗатратПенсионный,, "ЗатратПенсионный", ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратКурсоваяРазницаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ЗатратКурсоваяРазница");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетЗатратКурсоваяРазница);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратКурсоваяРазницаПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДоходовКурсоваяРазницаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ДоходовКурсоваяРазница");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетДоходовКурсоваяРазница);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДоходовКурсоваяРазницаПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратКомиссионныеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ЗатратКомиссионные");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетЗатратКомиссионные);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратКомиссионныеПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратПенсионныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ЗатратПенсионный");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетЗатратПенсионный);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратПенсионныйПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратКурсоваяРазницаПродажаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ЗатратКурсоваяРазница");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетЗатратКурсоваяРазница);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратКурсоваяРазницаПродажаПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДоходовКурсоваяРазницаПродажаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ДоходовКурсоваяРазница");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетДоходовКурсоваяРазница);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДоходовКурсоваяРазницаПродажаПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратСебестоимостьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ЗатратСебестоимость");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетЗатратСебестоимость);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратСебестоимостьПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДоходовСебестоимостьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ДоходовСебестоимость");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетДоходовСебестоимость);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДоходовСебестоимостьПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратКомиссионныеПродажаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(ЭтотОбъект, Объект, "Субконто%Индекс%ЗатратКомиссионные");
	ПараметрыДокумента.Вставить("СчетУчета", Объект.СчетЗатратКомиссионные);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратКомиссионныеПродажаПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаГривневаяПриИзменении(Элемент)
	
	ПересчитатьСуммыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПенсионныйПриИзменении(Элемент)
	
	СуммаДокументаНовая = Объект.СуммаГривневая + Объект.СуммаКомиссионные + Объект.СуммаПенсионный;
	Если Объект.СуммаДокумента <> СуммаДокументаНовая Тогда
		Объект.СуммаДокумента = СуммаДокументаНовая;
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	УстановитьКурсДокумента();
	ОбновитьИнформациюОКурсе();
	
	УстановитьВидимостьСтраницНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;

	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты") Тогда
		
		Форма.НадписьПокупаемаяПродаваемая = НСтр("ru='Покупаемая валюта:';uk=' Валюта, що купується:'");
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратКурсоваяРазница", "ЗаголовокСубконто2ЗатратКурсоваяРазница", "ЗаголовокСубконто3ЗатратКурсоваяРазница");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетЗатратКурсоваяРазница,, "ЗатратКурсоваяРазница", ЗаголовкиПолей);
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ДоходовКурсоваяРазница", "ЗаголовокСубконто2ДоходовКурсоваяРазница", "ЗаголовокСубконто3ДоходовКурсоваяРазница");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетДоходовКурсоваяРазница,, "ДоходовКурсоваяРазница", ЗаголовкиПолей);
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратКомиссионные", "ЗаголовокСубконто2ЗатратКомиссионные", "ЗаголовокСубконто3ЗатратКомиссионные");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетЗатратКомиссионные,, "ЗатратКомиссионные", ЗаголовкиПолей);
		
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратПенсионный", "ЗаголовокСубконто2ЗатратПенсионный", "ЗаголовокСубконто3ЗатратПенсионный");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетЗатратПенсионный,, "ЗатратПенсионный", ЗаголовкиПолей);		
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПокупкаПродажаВалюты.ПродажаВалюты") Тогда
		
		Форма.НадписьПокупаемаяПродаваемая = НСтр("ru='Продаваемая валюта:';uk='Валюта, що продається:'");
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратКурсоваяРазница", "ЗаголовокСубконто2ЗатратКурсоваяРазница", "ЗаголовокСубконто3ЗатратКурсоваяРазница");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетЗатратКурсоваяРазница,, "ЗатратКурсоваяРазницаПродажа", ЗаголовкиПолей);
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ДоходовКурсоваяРазница", "ЗаголовокСубконто2ДоходовКурсоваяРазница", "ЗаголовокСубконто3ДоходовКурсоваяРазница");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетДоходовКурсоваяРазница,, "ДоходовКурсоваяРазницаПродажа", ЗаголовкиПолей);
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратСебестоимость", "ЗаголовокСубконто2ЗатратСебестоимость", "ЗаголовокСубконто2ЗатратСебестоимость");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетЗатратСебестоимость,, "ЗатратСебестоимость", ЗаголовкиПолей);
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ДоходовСебестоимость", "ЗаголовокСубконто2ДоходовСебестоимость", "ЗаголовокСубконто2ДоходовСебестоимость");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетДоходовСебестоимость,, "ДоходовСебестоимость", ЗаголовкиПолей);
		
		ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1ЗатратКомиссионные", "ЗаголовокСубконто2ЗатратКомиссионные", "ЗаголовокСубконто3ЗатратКомиссионные");
		УстановитьЗаголовкиИДоступностьСубконто(Форма, Объект.СчетЗатратКомиссионные,, "ЗатратКомиссионныеПродажа", ЗаголовкиПолей);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСтраницНаСервере()
	
	МассивСтраниц = Новый Массив;
	МассивСтраниц.Добавить(Элементы.ГруппаПокупка);
	МассивСтраниц.Добавить(Элементы.ГруппаПродажа);
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПокупка;
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПокупкаПродажаВалюты.ПродажаВалюты Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПродажа;
	КонецЕсли;
	
	Для каждого ТекСтраница Из МассивСтраниц Цикл
		Если ТекСтраница <> Элементы.ГруппаСтраницы.ТекущаяСтраница Тогда
			Если ТекСтраница.Видимость Тогда
				ТекСтраница.Видимость = Ложь;
			КонецЕсли;
		Иначе
			Если НЕ ТекСтраница.Видимость Тогда
				ТекСтраница.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	УстановитьВидимостьСтраницНаСервере();
	
	Документы.ПокупкаПродажаВалюты.УстановитьСчетаУчета(Объект);
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Документы.ПокупкаПродажаВалюты.УстановитьСчетаУчета(Объект);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);						   
	
КонецПроцедуры

&НаСервере
Процедура ЗаявкаПриИзмененииНаСервере()
	
	Документы.ПокупкаПродажаВалюты.ЗаполнитьПоЗаявке(Объект);
	ВидОперацииПриИзмененииНаСервере();
	УстановитьКурсДокумента();
	ОбновитьИнформациюОКурсе();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСписокПараметровВыбораСубконто(Форма, ПараметрыОбъекта, ШаблонИмяПоляОбъекта)

	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("Организация", Форма.Объект.Организация);

	Возврат СписокПараметров;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, Счет, Префикс = "", Постфикс = "", ЗаголовкиПолей)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		Префикс + "Субконто1" + Постфикс,
		Префикс + "Субконто2" + Постфикс,
		Префикс + "Субконто3" + Постфикс);

	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей, Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма)

	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ЗатратКурсоваяРазница");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ЗатратКурсоваяРазница",  "Субконто%Индекс%ЗатратКурсоваяРазница", ПараметрыДокумента);
		
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ДоходовКурсоваяРазница");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ДоходовКурсоваяРазница", "Субконто%Индекс%ДоходовКурсоваяРазница", ПараметрыДокумента);
		
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ЗатратКомиссионные");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ЗатратКомиссионные",	  "Субконто%Индекс%ЗатратКомиссионные", ПараметрыДокумента);
		
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ЗатратПенсионный");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ЗатратПенсионный",		  "Субконто%Индекс%ЗатратПенсионный", ПараметрыДокумента);
		
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ЗатратКурсоваяРазница");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ЗатратКурсоваяРазница",  "Субконто%Индекс%ЗатратКурсоваяРазницаПродажа", ПараметрыДокумента);
		
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ДоходовКурсоваяРазница");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ДоходовКурсоваяРазница", "Субконто%Индекс%ДоходовКурсоваяРазницаПродажа", ПараметрыДокумента);
		
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ЗатратСебестоимость");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ЗатратСебестоимость",	  "Субконто%Индекс%ЗатратСебестоимость", ПараметрыДокумента);
		
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ДоходовСебестоимость");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ДоходовСебестоимость",   "Субконто%Индекс%ДоходовСебестоимость", ПараметрыДокумента);
		
	ПараметрыДокумента = ПолучитьСписокПараметровВыбораСубконто(Форма, Форма.Объект, "Субконто%Индекс%ЗатратКомиссионные");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект,
		"Субконто%Индекс%ЗатратКомиссионные", 	  "Субконто%Индекс%ЗатратКомиссионныеПродажа", ПараметрыДокумента);

КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОКурсе()

	Если НЕ ЗначениеЗаполнено(Объект.Валюта) Тогда
		Элементы.ИнфНадписьКурса.Заголовок = "";
		Возврат;
	КонецЕсли;
	
	ИнфНадписьКурса = НСтр("ru='Курс НБУ';uk='Курс НБУ'") + ОбщегоНазначенияБПКлиентСервер.ПолучитьИнформациюКурсаВалютыСтрокой(Объект.Валюта, КурсДокумента, КратностьДокумента, ВалютаРегламентированногоУчета, Истина);

КонецПроцедуры

&НаСервере
Процедура УстановитьКурсДокумента()

	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.Валюта, Объект.Дата);
	КурсДокумента      = СтруктураКурса.Курс;
	КратностьДокумента = СтруктураКурса.Кратность;

КонецПроцедуры

&НаСервере
Процедура ПересчитатьСуммыНаСервере()
	
	Документы.ПокупкаПродажаВалюты.ПересчитатьСуммы(Объект);
	
КонецПроцедуры	

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтотОбъект.ИмяФормы);
	
КонецПроцедуры
