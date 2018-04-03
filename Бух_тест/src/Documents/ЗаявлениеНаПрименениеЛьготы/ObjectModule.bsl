#Если Не ТолстыйКлиентУправляемоеПриложение Или Сервер Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Подсистема "Управление доступом"

Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Работники.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом"

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриемНаРаботу") Тогда
		НоваяСтрока = ЭтотОбъект.Работники.Добавить();
		НоваяСтрока.ФизическоеЛицо = ДанныеЗаполнения.Сотрудник.ФизическоеЛицо;
		НоваяСтрока.ДатаИзменения = ДанныеЗаполнения.ДатаПриема;
		НоваяСтрока.Актуальность = ИСТИНА;
		БазоваяЛьгота = Справочники.ВидыЛьготПоНДФЛ.НДФЛ_611;
		НоваяСтрока.Льгота = БазоваяЛьгота;
		Организация = ДанныеЗаполнения.Организация;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда 
		НоваяСтрока = ЭтотОбъект.Работники.Добавить();
		НоваяСтрока.ФизическоеЛицо = ДанныеЗаполнения.Ссылка.ФизическоеЛицо;
		НоваяСтрока.Актуальность = ИСТИНА;
		
		СписокСотрудников = Новый СписокЗначений;
		СписокСотрудников.Добавить( ДанныеЗаполнения.Ссылка);
		СтрокаКадровыеДанные = "ДатаПриема";
		ДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СписокСотрудников, СтрокаКадровыеДанные, Дата);
		Если НЕ ДанныеСотрудника[0].ДатаПриема = Дата('00010101') Тогда
			ДатаПриема = ДанныеСотрудника[0].ДатаПриема;	
			НоваяСтрока.ДатаИзменения = ДатаПриема;
		КонецЕсли;	
		
		БазоваяЛьгота = Справочники.ВидыЛьготПоНДФЛ.НДФЛ_611;
		НоваяСтрока.Льгота = БазоваяЛьгота;

	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	Если ДанныеДляПроведения.Количество() > 0 Тогда
		Движения.ЛьготыПоНДФЛСотрудников.Записывать = Истина;
	КонецЕсли; 
	
	ДанныеДляПроведения.Колонки.ДатаИзменения.Имя = "Период";
	Движения.ЛьготыПоНДФЛСотрудников.Загрузить(ДанныеДляПроведения);
	
	Если ДополнительныеСвойства.Свойство("ОтключитьПроверкуДатыЗапретаИзменения")
		И ДополнительныеСвойства.ОтключитьПроверкуДатыЗапретаИзменения Тогда
		
		Движения.ЛьготыПоНДФЛСотрудников.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
Функция  ПолучитьДанныеДляПроведения()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаявлениеРаботники.Ссылка.Организация КАК Организация,
	|	ЗаявлениеРаботники.Ссылка.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	ЗаявлениеРаботники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗаявлениеРаботники.Льгота КАК Льгота,
	|	ЗаявлениеРаботники.ДатаИзменения КАК ДатаИзменения,
	|	ЗаявлениеРаботники.Актуальность КАК Актуальность
	|ИЗ
	|	Документ.ЗаявлениеНаПрименениеЛьготы.Работники КАК ЗаявлениеРаботники
	|ГДЕ
	|	ЗаявлениеРаботники.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаявлениеРаботники.Актуальность УБЫВ,
	|	ЗаявлениеРаботники.ФизическоеЛицо.Наименование";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецЕсли
