#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат НСтр("ru='Анализ движений денежных средств';uk='Аналіз рухів коштів'") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	СписокВидДвижения = Новый СписокЗначений;
	СписокВидДвижения.Добавить("РозничнаяВыручка",НСтр("ru='Розничная выручка';uk='Роздрібний виторг'"));
	СписокВидДвижения.Добавить("РасчетыСПодотчетнымиЛицамиИзрасходовано",НСтр("ru='Расчеты с подотчетными лицами (израсходовано)';uk='Розрахунки з підзвітними особами (витрачено)'"));
	ПараметрыОтчета.СхемаКомпоновкиДанных.НаборыДанных.ОсновнойНабор.Поля.Найти("ВидДвижения").УстановитьДоступныеЗначения(СписокВидДвижения);
	
	СписокПолучательПлательщик = Новый СписокЗначений;
	СписокПолучательПлательщик.Добавить("РозничныеПокупатели",НСтр("ru='Розничные покупатели';uk='Роздрібні покупці'"));
	ПараметрыОтчета.СхемаКомпоновкиДанных.НаборыДанных.ОсновнойНабор.Поля.Найти("ПолучательПлательщик").УстановитьДоступныеЗначения(СписокПолучательПлательщик);
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконтоКД", ВидыСубконтоКД);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	Если ПараметрыОтчета.ПоказательПоступление Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "СуммаПриход");
	КонецЕсли;
	Если ПараметрыОтчета.ПоказательРасход Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "СуммаРасход");
	КонецЕсли;
	
	Если Не ПараметрыОтчета.ПоказательПоступление
		И ПараметрыОтчета.ПоказательРасход Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, "СуммаРасход",, ВидСравненияКомпоновкиДанных.Заполнено);
	КонецЕсли;
	Если ПараметрыОтчета.ПоказательПоступление
		И Не ПараметрыОтчета.ПоказательРасход Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, "СуммаПриход",, ВидСравненияКомпоновкиДанных.Заполнено);
	КонецЕсли;
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	// Отключить расшифровки для всех ячеек кроме ДокументОплаты, 
	// также по этой строке установить для всех ячеек расшифровку аналогичную полю ДокументОплаты.
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
		Если Макет.Параметры.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого СтрокаМакета Из Макет.Макет Цикл
			Для Каждого ЯчейкаМакета Из СтрокаМакета.Ячейки Цикл
				Если ЯчейкаМакета.Элементы.Количество() > 0 Тогда
					ЭтоПолеДокументОплаты = Ложь;
					ЗначениеПараметра = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ЯчейкаМакета.Оформление.Элементы, "Расшифровка");
					Если ЗначениеПараметра <> Неопределено И ЗначениеПараметра.Использование Тогда
						ПараметрРасшифровки = Макет.Параметры[Строка(ЗначениеПараметра.Значение)];
						Для Каждого ВыражениеПоля Из ПараметрРасшифровки.ВыраженияПолей Цикл
							Если ВыражениеПоля.Выражение = "ОсновнойНабор.ДокументОплаты" Тогда
								ЭтоПолеДокументОплаты = Истина;
								Для Каждого Параметр Из Макет.Параметры Цикл
									Если ТипЗнч(Параметр) = Тип("ПараметрОбластиРасшифровкаКомпоновкиДанных") Тогда
										Параметр.ВыраженияПолей.Очистить();
										
										НовоеВыражениеПоля = Параметр.ВыраженияПолей.Добавить();
										НовоеВыражениеПоля.Выражение = "ОсновнойНабор.ДокументОплаты";
										НовоеВыражениеПоля.Поле      = "ДокументОплаты";
									КонецЕсли;
								КонецЦикла;
								
								Прервать;
							КонецЕсли;
						КонецЦикла;
						Если Не ЭтоПолеДокументОплаты Тогда
							ЗначениеПараметра.Использование = Ложь;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "АнализДвиженийДенежныхСредств").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.ДенежныеСредства, "");
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("Поступление");
	НаборПоказателей.Добавить("Расход");

	Возврат НаборПоказателей;
	
КонецФункции

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","АнализДвиженийДенежныхСредств", "Анализ движений денежных средств"));
	
	Возврат Массив;
	
КонецФункции


// Формирует таблицу данных для монитора руководителя по организации за период
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужны данные
// 	ДатаНач - Дата - дата начала периода
// 	ДатаКон - Дата - дата конца периода
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ПолучитьДвижениеДенежныхСредствДляМонитораРуководителя(Организация, ДатаНач, ДатаКон) Экспорт
	
	СписокДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ложь);
	
	Если СписокДоступныхОрганизаций.Найти(Организация) <> Неопределено Тогда
		
		СписокОрганизаций = Новый Массив;
		СписокОрганизаций.Добавить(Организация);
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ДатаКон));
		
	// Получим список счетов для отбора
	СписокСчетов = БухгалтерскийУчетВызовСервераПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.Касса);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокСчетов, БухгалтерскийУчетВызовСервераПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.СчетаВБанках));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокСчетов, БухгалтерскийУчетВызовСервераПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами));
	
	
	// Уберем из иерархии счета по которым не хотим отбирать


	
	Запрос.УстановитьПараметр("СписокСчетов", СписокСчетов);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОбороты.СуммаОборотДт КАК СуммаПриход,
	               |	ХозрасчетныйОбороты.СуммаОборотКт КАК СуммаРасход
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, , Счет В (&СписокСчетов), , Организация В (&Организация), , ) КАК ХозрасчетныйОбороты";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
	
	Если Результат.Следующий() Тогда
		
		СтрокаПоступлене = ТаблицаДанных.Добавить();
		СтрокаПоступлене.Представление 	= "Поступление";
		СтрокаПоступлене.Сумма 			= Результат.СуммаПриход;
		СтрокаПоступлене.Порядок		= 1;
		
		СтрокаРасход = ТаблицаДанных.Добавить();
		СтрокаРасход.Представление 	= "Расход";
		СтрокаРасход.Сумма 			= Результат.СуммаРасход;
		СтрокаРасход.Порядок		= 2;
		
	КонецЕсли;
	
	Возврат ТаблицаДанных;			   
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


#КонецЕсли