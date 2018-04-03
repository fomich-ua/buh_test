////////////////////////////////////////////////////////////////////////////////
// Отчетность по регистрам учета 
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС


// Сохраняет регистр в виде табличного документа в базу данных.
//
Функция СохранитьРегистрУчета(СвойстваРегистраУчета) Экспорт
	
	РегистрУчета = Документы.РегистрУчета.СоздатьДокумент();
	РегистрУчета.Заполнить(СвойстваРегистраУчета);
	РегистрУчетаВХранилище = СформироватьРегистрУчетаИзТабличногоДокумента(СвойстваРегистраУчета.ТаблицаРегистра, РегистрУчета.Описание);
	РегистрУчета.ДополнительныеСвойства.Вставить("ФайлРегистраУчета", РегистрУчетаВХранилище);
	
	Попытка
		РегистрУчета.Записать();
		
	Исключение
		// Запись в журнал регистрации не требуется
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Пока ИнформацияОбОшибке.Причина <> Неопределено Цикл
			ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
		КонецЦикла;
		ТекстСообщения = НСтр("ru='Регистр учета не сохранен';uk='Регістр обліку не збережено'") + Символы.ПС + ИнформацияОбОшибке.Описание;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецПопытки;
	
	ДанныеСохранения = Новый Структура("РегистрУчета", РегистрУчета.Ссылка);
	
	СвойстваПрисоединенногоФайла   = Документы.РегистрУчета.ПолучитьСвойстваПрисоединенногоФайлаРегистра(РегистрУчета.Ссылка);
	ДанныеСохранения.Вставить("ОписаниеРегистра", РегистрУчета.Описание);
	ДанныеСохранения.Вставить("ПрисоединенныйФайл", СвойстваПрисоединенногоФайла.ПрисоединенныйФайл);
	ДанныеСохранения.Вставить("ДанныеФайла", 
		ПрисоединенныеФайлы.ПолучитьДанныеФайла(СвойстваПрисоединенногоФайла.ПрисоединенныйФайл, Новый УникальныйИдентификатор));
	
	Возврат ДанныеСохранения;
	
КонецФункции

// Общий обработчик события "ПриСозданииНаСервере" форм отчетов,
// являющихся регистрами учета.
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	Если ЕстьРеквизитФормы(Форма, "ВидРегистра") Тогда
		
		Отчет = Форма.РеквизитФормыВЗначение("Отчет");
		
		ПолноеИмяОтчета = Отчет.Метаданные().ПолноеИмя();
		
		КлючВарианта = Неопределено;
		Форма.Параметры.Свойство("КлючВарианта", КлючВарианта);

		Если КлючВарианта = Неопределено И Отчет.СхемаКомпоновкиДанных <> Неопределено Тогда
			
			КлючВарианта = Отчет.СхемаКомпоновкиДанных.ВариантыНастроек[0].Имя;
			
		КонецЕсли;	
		
		Форма.ВидРегистра = Справочники.ВидыРегистровУчета.ПолучитьВидРегистраБухгалтерскогоУчетаДляОтчета(ПолноеИмяОтчета, КлючВарианта);
	КонецЕсли;
	
	Если ЕстьРеквизитФормы(Форма, "ИспользуетсяЭП") Тогда
		Форма.ИспользуетсяЭП = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи");
	КонецЕсли;
	
	// Уведомим о появлении нового функционала.
	Если ЕстьРеквизитФормы(Форма, "НастройкиПредупреждений") Тогда
		Форма.НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("СохранениеРегистровБУСЭЦПСтандартныеОтчеты");
	КонецЕсли;
	
	
КонецПроцедуры

// Возвращает формат сохранения регистров учета в базе данных.
//
Функция ПолучитьФорматСохраненияРегистров() Экспорт
	
	ФорматРегистра = Константы.ФорматСохраненияРегистровУчета.Получить();
	Возврат ?(ЗначениеЗаполнено(ФорматРегистра), ФорматРегистра, Перечисления.ФорматыСохраненияОтчетов.PDF);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ЕстьРеквизитФормы(Форма, ИмяРеквизита) 
	
	Для Каждого РеквизитФормы Из Форма.ПолучитьРеквизиты() Цикл
		Если ВРег(РеквизитФормы.Имя) = ВРег(ИмяРеквизита) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция СформироватьРегистрУчетаИзТабличногоДокумента(ХранилищеТабличногоДокумента, Описание)
	Перем ИмяАрхива;
	
	// подготовка временной папки
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ИспользованныеИменаФайлов = Новый Соответствие;
	
	ТаблицаФорматов = УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента();
	
	ФорматСохраненияФайла = ПолучитьФорматСохраненияРегистров();
	
	НастройкиФормата = ТаблицаФорматов.НайтиСтроки(Новый Структура("Ссылка", ФорматСохраненияФайла))[0];
	
	ПечатнаяФорма = ПолучитьИзВременногоХранилища(ХранилищеТабличногоДокумента);
	
	ПолноеИмяФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) 
					+ ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(Описание);
	
	ПечатнаяФорма.Записать(ПолноеИмяФайла, НастройкиФормата.ТипФайлаТабличногоДокумента);
	
	Если НастройкиФормата.ТипФайлаТабличногоДокумента = ТипФайлаТабличногоДокумента.HTML Тогда
		ВставитьКартинкиВHTML(ПолноеИмяФайла);
	КонецЕсли;
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
	ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, Новый УникальныйИдентификатор);
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат ПутьВоВременномХранилище;
	
КонецФункции

Процедура ВставитьКартинкиВHTML(ИмяФайлаHTML)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	ТекстHTML = ТекстовыйДокумент.ПолучитьТекст();
	
	ФайлHTML = Новый Файл(ИмяФайлаHTML);
	
	ИмяПапкиКартинок = ФайлHTML.ИмяБезРасширения + "_files";
	ПутьКПапкеКартинок = СтрЗаменить(ФайлHTML.ПолноеИмя, ФайлHTML.Имя, ИмяПапкиКартинок);
	
	// ожидается, что в папке будут только картинки
	ФайлыКартинок = НайтиФайлы(ПутьКПапкеКартинок, "*");
	
	Для Каждого ФайлКартинки Из ФайлыКартинок Цикл
		КартинкаТекстом = Base64Строка(Новый ДвоичныеДанные(ФайлКартинки.ПолноеИмя));
		КартинкаТекстом = "data:image/" + Сред(ФайлКартинки.Расширение,2) + ";base64," + Символы.ПС + КартинкаТекстом;
		
		ТекстHTML = СтрЗаменить(ТекстHTML, ИмяПапкиКартинок + "\" + ФайлКартинки.Имя, КартинкаТекстом);
	КонецЦикла;
		
	ТекстовыйДокумент.УстановитьТекст(ТекстHTML);
	ТекстовыйДокумент.Записать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	
КонецПроцедуры
