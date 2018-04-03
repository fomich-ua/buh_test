
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПоискСуществуещейЕдиницы(Знач ПараметрыФормы)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторЕдиницИзмерения.Ссылка
	|ИЗ
	|	Справочник.КлассификаторЕдиницИзмерения КАК КлассификаторЕдиницИзмерения
	|ГДЕ
	|	КлассификаторЕдиницИзмерения.Код = &Код";
	
	Запрос.УстановитьПараметр("Код", ПараметрыФормы.ЗначенияЗаполнения.Код);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьВыбор(ТекущаяОбласть)
	
	КодЧисловой         = ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьКодЧисловойЛево,
		ТекущаяОбласть.Низ, ОбластьКодЧисловойПраво).Текст;
	НаименованиеКраткое = ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеКраткоеЛево,
		ТекущаяОбласть.Низ, ОбластьНаименованиеКраткоеПраво).Текст;
	НаименованиеПолное  = ТабДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеПолноеЛево,
		ТекущаяОбласть.Низ, ОбластьНаименованиеПолноеПраво).Текст;
	
	ЗначенияЗаполнения = Новый Структура("Код, Наименование, НаименованиеПолное",
		КодЧисловой, СтрПолучитьСтроку(НаименованиеКраткое, 1), СтрПолучитьСтроку(НаименованиеПолное, 1));
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ЕдИзм = ПоискСуществуещейЕдиницы(ПараметрыФормы);
	
	Если ЕдИзм <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура("Ключ", ЕдИзм);

		Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В справочнике ""Классификатор единиц измерения"" уже существует элемент с кодом ""%1""! Открыт существующий';uk='У довіднику ""Класифікатор одиниць вимірювання"" вже існує елемент з кодом ""%1""! Відкритий існуючий'"), КодЧисловой));
		
		ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.ФормаЭлемента",
			ПараметрыФормы, ЭтаФорма);
	Иначе	
		
		ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.ФормаЭлемента",
			ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ИскатьСтрокуВТаблице(Неопределено);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	Область = Элементы.ТабДокумент.ТекущаяОбласть;
	ВыполнитьВыбор(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокументВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Область = Элементы.ТабДокумент.ТекущаяОбласть;
	ВыполнитьВыбор(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура ИскатьСтрокуВТаблице(Команда)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не задана строка поиска';uk='Не заданий рядок пошуку'"));
		ТекущийЭлемент = Элементы.СтрокаПоиска;
		Возврат;
	КонецЕсли;
	
	НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска, Элементы.ТабДокумент.ТекущаяОбласть,
		,,,, Истина);
	Если НайденнаяОбласть = Неопределено Тогда
		НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска, , , , , , Истина);
		Если НайденнаяОбласть = Неопределено Тогда
			ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(
				НСтр("ru='Строка не найдена';uk='Рядок не знайдено'"));
			ТекущийЭлемент = Элементы.СтрокаПоиска;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ТабДокумент.ТекущаяОбласть = НайденнаяОбласть;
	ТекущийЭлемент = Элементы.СтрокаПоиска;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Параметры.Свойство("СтрокаПоиска") Тогда
		СтрокаПоиска = ЭтаФорма.Параметры.СтрокаПоиска;
	КонецЕсли;
	
	Макет = Справочники.КлассификаторЕдиницИзмерения.ПолучитьМакет("КлассификаторЕдиницИзмерения");
	ТабДокумент.Вывести(Макет);
	ТабДокумент.ФиксацияСверху      = 4;
	
	ОбластьКодЧисловойЛево          = Макет.Области.КодЧисловой.Лево;
	ОбластьКодЧисловойПраво         = Макет.Области.КодЧисловой.Право;
	ОбластьНаименованиеКраткоеЛево  = Макет.Области.НаименованиеКраткое.Лево;
	ОбластьНаименованиеКраткоеПраво = Макет.Области.НаименованиеКраткое.Право;
	ОбластьНаименованиеПолноеЛево   = Макет.Области.НаименованиеПолное.Лево;
	ОбластьНаименованиеПолноеПраво  = Макет.Области.НаименованиеПолное.Право;
	
	Если НЕ ПустаяСтрока(СтрокаПоиска) Тогда
		НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска,, ТабДокумент.Области.КодЧисловой,,,, Истина);
		Элементы.ТабДокумент.ТекущаяОбласть = НайденнаяОбласть;
	КонецЕсли;
	
КонецПроцедуры

