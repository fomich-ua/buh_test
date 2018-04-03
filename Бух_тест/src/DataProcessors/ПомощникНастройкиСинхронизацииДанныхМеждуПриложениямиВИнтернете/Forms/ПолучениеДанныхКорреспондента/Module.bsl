#Область ОбработчикиСобытийФормы

// Переопределяемая часть

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Получать данные корреспондента может только администратор обмена (для абонента).
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяПланаОбмена                   = Параметры.ИмяПланаОбмена;
	ОбластьДанныхКорреспондента      = Параметры.ОбластьДанныхКорреспондента;
	ТаблицыКорреспондента            = Параметры.ТаблицыКорреспондента;
	Режим                            = Параметры.Режим;
	УникальныйИдентификаторВладельца = Параметры.УникальныйИдентификаторВладельца;
	
	СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных = ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных();
	
	// Устанавливаем текущую таблицу переходов
	СценарийПолученияДанныхКорреспондента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Позиционируемся на первом шаге помощника
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

// Обработчики ожидания

&НаКлиенте
Процедура ОбработчикОжиданияДлительнойОперации()
	
	Попытка
		СтатусСессии = СтатусСессии(Сессия);
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных);
		ОтменитьОперацию();
		Возврат;
	КонецПопытки;
	
	Если СтатусСессии = "Успешно" Тогда
		
		ПерейтиДалее();
		
	ИначеЕсли СтатусСессии = "Ошибка" Тогда
		
		ОтменитьОперацию();
		Возврат;
		
	Иначе
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Поставляемая часть

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Поставляемая часть

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru='Не определена страница для отображения.';uk='Не визначена сторінка для відображення.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	// Устанавливаем текущую кнопку по умолчанию
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// обработчик ПриПереходеДалее
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				А = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// обработчик ПриПереходеНазад
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				А = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru='Не определена страница для отображения.';uk='Не визначена сторінка для відображення.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru='Не определена страница для отображения.';uk='Не визначена сторінка для відображення.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ОбработкаДлительнойОперации
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет новую строку в конец текущей таблицы переходов
//
// Параметры:
//
//  ПорядковыйНомерПерехода (обязательный) - Число. Порядковый номер перехода, который соответствует текущему шагу перехода
//  ИмяОсновнойСтраницы (обязательный) - Строка. Имя страницы панели "ПанельОсновная", которая соответствует текущему номеру перехода
//  ИмяСтраницыНавигации (обязательный) - Строка. Имя страницы панели "ПанельНавигации", которая соответствует текущему номеру перехода
//  ИмяСтраницыДекорации (необязательный) - Строка. Имя страницы панели "ПанельДекорации", которая соответствует текущему номеру перехода
//  ИмяОбработчикаПриОткрытии (необязательный) - Строка. Имя функции-обработчика события открытия текущей страницы помощника
//  ИмяОбработчикаПриПереходеДалее (необязательный) - Строка. Имя функции-обработчика события перехода на следующую страницу помощника
//  ИмяОбработчикаПриПереходеНазад (необязательный) - Строка. Имя функции-обработчика события перехода на предыдущую страницу помощника
//  ДлительнаяОперация (необязательный) - Булево. Признак отображения страницы длительной операции.
//  Истина - отображается страница длительной операции; Ложь - отображается обычная страница. Значение по умолчанию - Ложь.
// 
&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода,
									ИмяОсновнойСтраницы,
									ИмяСтраницыНавигации,
									ИмяСтраницыДекорации = "",
									ИмяОбработчикаПриОткрытии = "",
									ИмяОбработчикаПриПереходеДалее = "",
									ИмяОбработчикаПриПереходеНазад = "",
									ДлительнаяОперация = Ложь,
									ИмяОбработчикаДлительнойОперации = "")
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ИмяОбработчикаПриОткрытии;
	
	НоваяСтрока.ДлительнаяОперация = ДлительнаяОперация;
	НоваяСтрока.ИмяОбработчикаДлительнойОперации = ИмяОбработчикаДлительнойОперации;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И Найти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть: Служебные процедуры и функции

&НаКлиенте
Процедура ПерейтиДалее()
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтатусСессии(Знач Сессия)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегистрыСведений.СессииОбменаСообщениямиСистемы.СтатусСессии(Сессия);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(СтрокаСообщенияОбОшибке, Событие)
	
	ЗаписьЖурналаРегистрации(Событие, УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьОперацию()
	
	ПоказатьПредупреждение(, НСтр("ru='Не удалось выполнить операцию.';uk='Не вдалося виконати операцію.'"));
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть: Обработчики событий переходов

&НаКлиенте
Функция Подключаемый_ОжиданиеПолученияДанных_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ОжиданиеПолученияДанных_ОбработкаДлительнойОперации(Отказ);
	
	Если Отказ Тогда
		Отказ = Ложь;
		ОтменитьОперацию();
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОжиданиеПолученияДанных_ОбработкаДлительнойОперации(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Если Режим = "ПолучитьДанныеКорреспондента" Тогда
			
			// Отправляем сообщение корреспонденту
			Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
				СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеПолучитьДанныеКорреспондента());
			Сообщение.Body.CorrespondentZone = ОбластьДанныхКорреспондента;
			Сообщение.Body.Tables = СериализаторXDTO.ЗаписатьXDTO(ТаблицыКорреспондента);
			Сообщение.Body.ExchangePlan = ИмяПланаОбмена;
			Сессия = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
			
		ИначеЕсли Режим = "ПолучитьОбщиеДанныеУзловКорреспондента" Тогда
			
			// Отправляем сообщение корреспонденту
			Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
				СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеПолучитьОбщиеДанныеУзловКорреспондента());
			Сообщение.Body.CorrespondentZone = ОбластьДанныхКорреспондента;
			Сообщение.Body.ExchangePlan = ИмяПланаОбмена;
			Сессия = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
			
		Иначе
			
			ВызватьИсключение НСтр("ru='Неизвестный режим получения данных корреспондента.';uk='Невідомий режим отримання даних кореспондента.'");
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

&НаКлиенте
Функция Подключаемый_ОжиданиеПолученияДанныхДлительнаяОперация_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеПолученияДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	
	ОжиданиеПолученияДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ);
	
	Если Отказ Тогда
		ОтменитьОперацию();
		Возврат Неопределено;
	КонецЕсли;
	
	Закрыть();
	
	Если Режим = "ПолучитьДанныеКорреспондента" Тогда
		
		Оповестить("ПолученыДанныеКорреспондента", АдресВременногоХранилища);
		
	ИначеЕсли Режим = "ПолучитьОбщиеДанныеУзловКорреспондента" Тогда
		
		Оповестить("ПолученыОбщиеДанныеУзловКорреспондента", АдресВременногоХранилища);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОжиданиеПолученияДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		ДанныеКорреспондента = РегистрыСведений.СессииОбменаСообщениямиСистемы.ПолучитьДанныеСессии(Сессия);
		
		АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДанныеКорреспондента, УникальныйИдентификаторВладельца);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть: Инициализация переходов помощника

&НаСервере
Процедура СценарийПолученияДанныхКорреспондента()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ОжиданиеПолученияДанных", "СтраницаНавигацииОтмена",,,,, Истина, "ОжиданиеПолученияДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеПолученияДанных", "СтраницаНавигацииОтмена",,,,, Истина, "ОжиданиеПолученияДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеПолученияДанных", "СтраницаНавигацииОтмена",,,,, Истина, "ОжиданиеПолученияДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
КонецПроцедуры

#КонецОбласти
