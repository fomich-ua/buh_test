
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	ВозможностьВыбораФайлов = Форма.ВозможностьВыбораФайлов;
	
	Если НЕ ВозможностьВыбораФайлов Тогда
		
		Элементы.ИмяФайлаДанных.Видимость = Ложь;
		Элементы.ГруппаЗаголовокФайла.Видимость = Ложь;
		
		ТекстПояснения = "По кнопке ""Загрузить данные"" укажите путь к файлу, в который были 
		|выгружены данные из конфигурации на платформе 1С:Предприятие 7.7
		|
		|Файл должен быть предварительно сформирован в информационной базе
		|1С:Предприятия 7.7 с помощью Помощника перехода";
	Иначе
		ТекстПояснения = "Укажите путь к файлу, в который были выгружены данные из конфигурации 
		|на платформе 1С:Предприятие 7.7, и нажмите кнопку ""Загрузить данные""
		|
		|Файл должен быть предварительно сформирован в информационной базе
		|1С:Предприятия 7.7 с помощью Помощника перехода";
	КонецЕсли;
	
	Элементы.ДекорацияПояснение.Заголовок = ТекстПояснения;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьФайлыКонверации(ПрефиксМакета, Параметры)
	
	ИмяВременногоФайлаПравил  = КаталогВременныхФайлов() + ПрефиксМакета + "_ACC8.xml";
	ДвоичныеДанныеФайлаПравил = Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ПолучитьМакет(ПрефиксМакета + "_xml");
	ДвоичныеДанныеФайлаПравил.Записать(ИмяВременногоФайлаПравил);
	
	ИмяВременногоФайлаОбработки  = КаталогВременныхФайлов() + ПрефиксМакета + "_ACC8.ert";
	ДвоичныеДанныеФайлаОбработки = Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ПолучитьМакет(ПрефиксМакета + "_ert");
	ДвоичныеДанныеФайлаОбработки.Записать(ИмяВременногоФайлаОбработки);
	
	Параметры.АдресФайлаПравил    = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайлаПравил, Новый УникальныйИдентификатор);
	Параметры.АдресФайлаОбработки = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайлаОбработки, Новый УникальныйИдентификатор);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлы(ПрефиксМакета)
	
	АдресаФайлов = Новый Структура("АдресФайлаПравил, АдресФайлаОбработки");
	ПолучитьФайлыКонверации(ПрефиксМакета, АдресаФайлов);
	
	Если ВозможностьВыбораФайлов Тогда
		
		ДиалогВыбораФайла           = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогВыбораФайла.Заголовок = "Укажите каталог для записи файлов конвертации";
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ПрефиксМакета", ПрефиксМакета);
		ДополнительныеПараметры.Вставить("АдресаФайлов", АдресаФайлов);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловВыборКаталогаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДиалогВыбораФайла.Показать(ОписаниеОповещения);
		
	Иначе
		
		Попытка
			
			ПолучитьФайл(АдресаФайлов.АдресФайлаПравил, ПрефиксМакета + "_ACC8.xml", Истина);
			Состояние(НСтр("ru='Файл правил выгрузки успешно сохранен';uk='Файл правил вивантаження успішно збережений'"), , АдресаФайлов.АдресФайлаПравил);
						
			ПолучитьФайл(АдресаФайлов.АдресФайлаОбработки, ПрефиксМакета + "_ACC8.ert", Истина);
			Состояние(НСтр("ru='Файл обработки выгрузки успешно сохранен';uk='Файл обробки вивантаження успішно збережений'"), , АдресаФайлов.АдресФайлаОбработки);
			
			УдалитьИзВременногоХранилища(АдресаФайлов.АдресФайлаПравил);
			УдалитьИзВременногоХранилища(АдресаФайлов.АдресФайлаОбработки);
			
		Исключение
			ШаблонСообщения = НСтр("ru='При записи файла возникла ошибка"
"%1';uk='При записі файлу відбулася помилка"
"%1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ОписаниеОшибки = ИнформацияОбОшибке();
			
			ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки);
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеФайловВыборКаталогаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество()>0 Тогда
		
		Каталог       = ВыбранныеФайлы.Получить(0);
		ПрефиксМакета = ДополнительныеПараметры.ПрефиксМакета;
		АдресаФайлов  = ДополнительныеПараметры.АдресаФайлов;
		
		ПередаваемыеФайлы = Новый Массив;
		ПереданныеФайлы   = Новый Массив;
		МассивВызовов     = Новый Массив;
		
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Каталог + "\" + ПрефиксМакета + "_ACC8.xml", АдресаФайлов.АдресФайлаПравил);			
		ПередаваемыеФайлы.Добавить(ОписаниеФайла);
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Каталог + "\" + ПрефиксМакета + "_ACC8.ert", АдресаФайлов.АдресФайлаОбработки);			
		ПередаваемыеФайлы.Добавить(ОписаниеФайла);
		
		МассивВызовов.Добавить(Новый Массив);
		
		МассивВызовов[0].Добавить("ПолучитьФайлы");
		МассивВызовов[0].Добавить(ПередаваемыеФайлы);
		МассивВызовов[0].Добавить(ПереданныеФайлы);
		МассивВызовов[0].Добавить("");
		МассивВызовов[0].Добавить(Ложь);
		
		ДополнительныеПараметры.Вставить("ПередаваемыеФайлы", ПередаваемыеФайлы);
		ДополнительныеПараметры.Вставить("Каталог", Каталог);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловЗапросРазрешенийЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьЗапросРазрешенияПользователя(ОписаниеОповещения, МассивВызовов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеФайловЗапросРазрешенийЗавершение(РазрешенияПолучены, ДополнительныеПараметры) Экспорт
	
	Если РазрешенияПолучены Тогда
		
		ПередаваемыеФайлы = ДополнительныеПараметры.ПередаваемыеФайлы;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПолучениеФайлов(ОписаниеОповещения, ПередаваемыеФайлы, ДополнительныеПараметры.Каталог, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеФайловЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	ПрефиксМакета = ДополнительныеПараметры.ПрефиксМакета;
	Каталог       = ДополнительныеПараметры.Каталог;
	АдресаФайлов  = ДополнительныеПараметры.АдресаФайлов;
	
	ШаблонСообщения = НСтр("ru='Обработка выгрузки %1 и правила конвертации %2 записаны в каталог: %3';uk='Обробка вивантаження %1 і правила конвертації %2 записані в каталог: %3'");
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
	                 ПрефиксМакета + "_ACC8.ert", ПрефиксМакета + "_ACC8.xml", Каталог);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	УдалитьИзВременногоХранилища(АдресаФайлов.АдресФайлаПравил);
	УдалитьИзВременногоХранилища(АдресаФайлов.АдресФайлаОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияЗагрузкаДанныхВебКлиент()
	// В этом режиме все манипуляции производятся в один проход
	
	// Шаг № 1 инициализация обмена и загрузка данных				
	ЗагрузкаИнформационнойБазы();
	Если НЕ Ошибка Тогда
		Перерисовать(3, "Успех");
	Иначе
		Перерисовать(3);
		Элементы.СтраницыРезультат.ТекущаяСтраница = Элементы.Ошибки;
		Элементы.КомандаЗакрыть.Доступность = Истина;
		Элементы.СтраницыЗаголовокПеренос.ТекущаяСтраница = Элементы.СтраницаЗаголовокПереносЗавершен;		
	КонецЕсли;
	Оповестить("ЗавершениеЗагрузкиИз1СПредприятия77");
	
	Если ОсновнаяОрганизация Тогда
		ОбщегоНазначенияБПКлиент.УстановитьОсновнуюОрганизацию(Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияЗагрузкаИнформационнойБазы()

	// Шаг № 1 инициализация обмена и загрузка данных			
	ЗагрузкаИнформационнойБазы();
	Если НЕ Ошибка Тогда
		Перерисовать(3, "Успех", Истина);
		// Шаг № 2 проведение документов				
		ЭтапКонвертации = "Проведение документов";
		Перерисовать(4, "Выполняется", Истина);
		ПодключитьОбработчикОжидания("ОбработчикОжиданияПроведениеДокументов", 0.5, Истина);
	Иначе
		Элементы.СтраницыРезультат.ТекущаяСтраница = Элементы.Ошибки;
		Элементы.КомандаЗакрыть.Доступность = Истина;
		Элементы.СтраницыЗаголовокПеренос.ТекущаяСтраница = Элементы.СтраницаЗаголовокПереносЗавершен;
		Оповестить("ЗавершениеЗагрузкиИз1СПредприятия77");
		
		Если ОсновнаяОрганизация Тогда
			ОбщегоНазначенияБПКлиент.УстановитьОсновнуюОрганизацию(Организация);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПроведениеДокументов()
	
	ПроведениеДокументов();
	
	Если НЕ Ошибка Тогда
		Перерисовать(4, "Успех", Истина);
	КонецЕсли;
	
	// Шаг № 3 проверка загруженных данных
	ЭтапКонвертации = "Проверка данных";
	Перерисовать(5, "Выполняется", Истина);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияПроверкаДанных", 0.5, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПроверкаДанных()
	
	ОповеститьОбИзмененииЗадачБухгалтера = Ложь;
	ПроверитьДанныеНаСервере(ОповеститьОбИзмененииЗадачБухгалтера);
	Если Ошибка Тогда
		Перерисовать(5);
		Элементы.СтраницыРезультат.ТекущаяСтраница = Элементы.Ошибки;
	Иначе
		Перерисовать(5, "Успех", Истина);
		Элементы.СтраницыРезультат.ТекущаяСтраница = Элементы.Успех;
	КонецЕсли;
	Элементы.КомандаЗакрыть.Доступность = Истина;

	Элементы.СтраницыЗаголовокПеренос.ТекущаяСтраница = Элементы.СтраницаЗаголовокПереносЗавершен;
	Оповестить("ЗавершениеЗагрузкиИз1СПредприятия77");
	
	Если ОсновнаяОрганизация Тогда
		ОбщегоНазначенияБПКлиент.УстановитьОсновнуюОрганизацию(Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьОтчетОбОшибкахСервер(ОтчетОбОшибках)
	
	Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ПолучитьОтчетОбОшибках(ОтчетОбОшибках, , 
	                                                                                 , Объект.ИмяФайлаДанных, 
																					 ТаблицаОшибок)
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьОтчетОбОшибках()
	
	ОтчетОбОшибках = Новый ТабличныйДокумент;
	ПодготовитьОтчетОбОшибкахСервер(ОтчетОбОшибках);
	ОтчетОбОшибках.ТолькоПросмотр = Истина;
	ОтчетОбОшибках.ОтображатьЗаголовки = Ложь;
	ОтчетОбОшибках.ОтображатьСетку = Ложь;	
	ОтчетОбОшибках.Показать(НСтр("ru='Список ошибок';uk='Список помилок'"));
    	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗафиксироватьОшибку(Форма, ТекстОшибки, ТекстРекомендации = "", Расшифровка = Неопределено)
	
	Этап = Форма.ЭтапКонвертации;
	
	Если НЕ ЗначениеЗаполнено(Этап) Тогда
		Возврат;
	КонецЕсли;
	
	Если Этап = "Проверка данных" И НЕ ЗначениеЗаполнено(ТекстРекомендации) Тогда
		ТекстРекомендации = "Проверьте, все ли загруженные документы были проведены.";
	КонецЕсли;
	
	НоваяОшибка = Форма.ТаблицаОшибок.Добавить();
	НоваяОшибка.Этап = Этап;
	НоваяОшибка.Ошибка = ТекстОшибки;
	НоваяОшибка.Рекомендации = ТекстРекомендации;
	НоваяОшибка.Расшифровка = Расшифровка;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки)

	ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки.Описание);

КонецПроцедуры

&НаСервере
Функция ВыполнитьЗагрузкуДанныхНаСервере(АдресФайла)
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ДвоичныеДанныеФайла", ДвоичныеДанныеФайла);
	ПараметрыВыгрузки.Вставить("ВебКлиент", ВебКлиент);
	ПараметрыВыгрузки.Вставить("ЭтоАрхив", ЭтоАрхив);
	ПараметрыВыгрузки.Вставить("ИмяФайлаДанных", Объект.ИмяФайлаДанных);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ЗагрузитьДанныеВИБ(ПараметрыВыгрузки, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);		
	Иначе
		НаименованиеЗадания = НСтр("ru='Загрузка данных из информационных баз 1С:Предприятия 7.7';uk='Завантаження даних з інформаційних баз 1С:Підприємства 7.7'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			Новый УникальныйИдентификатор,
			"Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ЗагрузитьДанныеВИБ", 
			ПараметрыВыгрузки, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;	
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьРезультат();
	КонецЕсли;

	Возврат Результат;
		
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультат()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Результат.Свойство("ИдентификаторКонфигурации") Тогда
			ИдентификаторКонфигурации = Результат.ИдентификаторКонфигурации;
		КонецЕсли;
		Если Результат.Свойство("ТекстСообщения",) Тогда
			ТекстСообщения = Результат.ТекстСообщения;
			Ошибка = Результат.Ошибка;
			Если НЕ ВебКлиент Тогда
				Если НЕ Ошибка Тогда
					НачалоПериодаВыгрузки     = Результат.НачалоПериодаВыгрузки;
					ОкончаниеПериодаВыгрузки  = Результат.ОкончаниеПериодаВыгрузки;
					ЕстьСправочники           = ?(Результат.ЕстьСправочники = 1, Истина, Ложь);
					ЕстьОстатки               = ?(Результат.ЕстьОстатки = 1, Истина, Ложь);
					Организация               = Результат.Организация;
					КонрольныеДанные          = Результат.КонрольныеДанные;
					КонрольныеЗначения        = Результат.КонрольныеЗначения;
					Если Результат.Свойство("ОсновнаяОрганизация",) Тогда
						ОсновнаяОрганизация = Результат.ОсновнаяОрганизация;					
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли ВебКлиент Тогда
				
				Если НЕ Ошибка Тогда
					ЭтаФорма.Элементы.СтраницыРезультат.ТекущаяСтраница = ЭтаФорма.Элементы.Успех;
				Иначе
					ЭтаФорма.Элементы.СтраницыРезультат.ТекущаяСтраница = ЭтаФорма.Элементы.Ошибки;
				КонецЕсли;

				ЭтаФорма.Элементы.КомандаЗакрыть.Доступность = Истина;
				ЭтаФорма.Элементы.СтраницыЗаголовокПеренос.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаЗаголовокПереносЗавершен;
				
				Если Результат.Свойство("Организация",) Тогда
					Организация = Результат.Организация;
				КонецЕсли;
                Если Результат.Свойство("ЕстьОстатки",) Тогда
					ЕстьОстатки = ?(Результат.ЕстьОстатки = 1, Истина, Ложь);
				КонецЕсли;
				Если Результат.Свойство("ОсновнаяОрганизация",) Тогда
					ОсновнаяОрганизация = Результат.ОсновнаяОрганизация;					
				КонецЕсли;
				Если Результат.Свойство("СписокОшибок",) Тогда
					СписокОшибок = Результат.СписокОшибок;
					Если СписокОшибок.Количество() <> 0 Тогда
						Для Каждого СтрокаСписка ИЗ СписокОшибок Цикл
							ЗафиксироватьОшибку(ЭтаФорма, ?(ЗначениеЗаполнено(СтрокаСписка.Представление), СтрокаСписка.Представление, СтрокаСписка.Значение));
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроведениеДокументов()
		
	Если НЕ ЕстьОстатки Тогда 		
		Возврат;
	КонецЕсли;
		
	ЭтаФорма.ТекстСообщения = "";
	
	Результат = ВыполнитьПроведениеНаСервере();
	
	Если Ошибка Тогда
		Перерисовать(4);
		Если ЗначениеЗаполнено(ТекстСообщения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ЗафиксироватьОшибку(ЭтаФорма, ТекстСообщения, "");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьПроведениеНаСервере()
	
	ПараметрыПроведения = Новый Структура("Организация, НачалоПериодаВыгрузки, ОкончаниеПериодаВыгрузки, ЕстьОстатки", ЭтаФорма.Организация, ЭтаФорма.НачалоПериодаВыгрузки, ЭтаФорма.ОкончаниеПериодаВыгрузки, ЭтаФорма.ЕстьОстатки);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ПровестиДокументы(ПараметрыПроведения, АдресХранилища);
	ЗагрузитьРезультатПроведения();

	Возврат Истина;
		
КонецФункции

&НаСервере
Процедура ЗагрузитьРезультатПроведения()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) = Тип("Структура") Тогда		
		Если Результат.Свойство("ТекстСообщения",) Тогда
			ТекстСообщения = Результат.ТекстСообщения;
			Ошибка = Результат.Ошибка;
			Если Ошибка Тогда
				Если Результат.Свойство("СписокОшибок",) Тогда
					СписокОшибок = Результат.СписокОшибок;
					Если СписокОшибок.Количество() <> 0 Тогда
						Для Каждого СтрокаСписка ИЗ СписокОшибок Цикл
							ЗафиксироватьОшибку(ЭтаФорма, СтрокаСписка.Представление, НСтр("ru='Рекомендуется провести указанный документ вручную.';uk='Рекомендується провести зазначений документ вручну.'"), СтрокаСписка.Значение);
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДанныеНаСервере(ОповеститьОбИзмененииЗадачБухгалтера)

 ПараметрыПроверки = Новый Структура("ИдентификаторКонфигурации, Организация, НачалоПериодаВыгрузки, ОкончаниеПериодаВыгрузки, 
									  |ЕстьОстатки, КонрольныеДанные, КонрольныеЗначения, СписокОшибок", 
									  ЭтаФорма.ИдентификаторКонфигурации, ЭтаФорма.Организация, ЭтаФорма.НачалоПериодаВыгрузки, ЭтаФорма.ОкончаниеПериодаВыгрузки, 
									  ЭтаФорма.ЕстьОстатки,
									  ЭтаФорма.КонрольныеДанные, ЭтаФорма.КонрольныеЗначения, Новый СписокЗначений);

									  
									  
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ПроверитьДанные(ПараметрыПроверки, АдресХранилища);
	ЗагрузитьРезультатПроверки();
	
	ОповеститьОбИзмененииЗадачБухгалтера = Ложь;
		
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультатПроверки()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) = Тип("Структура") Тогда		
		Если Результат.Свойство("ТекстСообщения",) Тогда
			ТекстСообщения = Результат.ТекстСообщения;
			Ошибка = Результат.Ошибка;
			Если Ошибка Тогда
				Если Результат.Свойство("СписокОшибок",) Тогда
					СписокОшибок = Результат.СписокОшибок;
					Если СписокОшибок.Количество() <> 0 Тогда
						Для Каждого СтрокаСписка ИЗ СписокОшибок Цикл
							ЗафиксироватьОшибку(ЭтаФорма, СтрокаСписка.Значение);
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
		Если Результат.Свойство("ЭтапКонвертации",) Тогда
			ЭтапКонвертации = Результат.ЭтапКонвертации;
		КонецЕсли;		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Перерисовать(Этап, Состояние = "Ошибка", ОднаКартинка = Ложь)
	
	ИмяЗакладки = "НеВыполняется";
	Если Состояние = "ВОчереди" Тогда
		НомерСостояния = 1;
	ИначеЕсли Состояние = "Выполняется" Тогда
		НомерСостояния = 2;
		ИмяЗакладки = "Выполняется";
	ИначеЕсли Состояние = "Ошибка" Тогда
		НомерСостояния = 3;
		ИмяЗакладки = "Выполнено";
	ИначеЕсли Состояние = "Успех" Тогда
		НомерСостояния = 4;
		ИмяЗакладки = "Выполнено";
	Иначе
		НомерСостояния = 3;
		ИмяЗакладки = "Выполнено";
	КонецЕсли;
		
	Если ОднаКартинка Тогда
		ЭтапСтрока = Этапы.Получить(Этап);
		Элементы[ЭтапСтрока].ТекущаяСтраница    = Элементы[ЭтапСтрока + НомерСостояния];
		Элементы[ЭтапСтрока + "Надпись"].ТекущаяСтраница = Элементы[ЭтапСтрока + "Надпись" + ИмяЗакладки];

	Иначе
		
		Для НомерКартинки = Этап По 5 Цикл
			ЭтапСтрока = Этапы.Получить(НомерКартинки);
			Элементы[ЭтапСтрока].ТекущаяСтраница    = Элементы[ЭтапСтрока + НомерСостояния];
			Элементы[ЭтапСтрока + "Надпись"].ТекущаяСтраница = Элементы[ЭтапСтрока + "Надпись" + ИмяЗакладки];
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтработатьНажатиеВперед()
	
	Если НомерСтраницы = 2 Тогда
		ТаблицаОшибок.Очистить();
		Элементы.СтраницыРезультат.ТекущаяСтраница = Элементы.Процесс;
		Элементы.СтраницыКонвертацииДанных.ТекущаяСтраница = Элементы.СтраницаВыгрузкаЗагрузка;				
		Элементы.СтраницыПереносДанных.ТекущаяСтраница = Элементы.СтраницаПеренос;			
		Элементы.СтраницыЗаголовокПеренос.ТекущаяСтраница = Элементы.СтраницаЗаголовокПереносВыполняется;
		
		ЭтапКонвертации = "Загрузка данных";
		Если ВебКлиент Тогда
			Перерисовать(3, "Выполняется");
			ПодключитьОбработчикОжидания("ОбработчикОжиданияЗагрузкаДанныхВебКлиент", 0.5, Истина);
		Иначе
			Перерисовать(3, "Выполняется", Истина);
			ПодключитьОбработчикОжидания("ОбработчикОжиданияЗагрузкаИнформационнойБазы", 0.5, Истина);
		КонецЕсли;
				
		Если Ошибка Тогда
			Элементы.СтраницыРезультат.ТекущаяСтраница = Элементы.Ошибки;
			Элементы.КомандаЗакрыть.Доступность = Истина;
			Элементы.СтраницыЗаголовокПеренос.ТекущаяСтраница = Элементы.СтраницаЗаголовокПереносЗавершен;
			Оповестить("ЗавершениеЗагрузкиИз1СПредприятия77");
			
			Если ОсновнаяОрганизация Тогда
				ОбщегоНазначенияБПКлиент.УстановитьОсновнуюОрганизацию(Организация);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Шагнуть()
	
	Если НомерСтраницы = 0 Тогда
		
		Элементы.СтраницыКонвертацииДанных.ТекущаяСтраница = Элементы.СтраницаПереносДанных;
			
		Элементы.ФСтраницы.ТекущаяСтраница = Элементы.ФСтраницаЗаполненная;
		Элементы.ГруппаКомандСтраницы.ТекущаяСтраница = Элементы.ГруппаКомандЗагрузить;
					
	КонецЕсли;
	
	НомерСтраницы = НомерСтраницы + 1;
	
	Если НомерСтраницы = 2 Тогда
		Если ВозможностьВыбораФайлов ИЛИ НЕ ВебКлиент Тогда
			Если НЕ ЗначениеЗаполнено(Объект.ИмяФайлаДанных) Тогда
				Сообщить("Укажите путь к файлу данных.", СтатусСообщения.Важное);
				НомерСтраницы = НомерСтраницы - 1;
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайла(Элемент)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр                      = "Файл данных (*.xml)|*.xml";
	ДиалогВыбораФайла.Заголовок                   = "Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр     = Ложь;
	ДиалогВыбораФайла.Расширение                  ="xml";
	ДиалогВыбораФайла.ИндексФильтра               = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла              = Элемент.ТекстРедактирования;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтотОбъект);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество()>0 Тогда
		
		Объект.ИмяФайлаДанных = ВыбранныеФайлы[0];
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаИнформационнойБазы()
	
	ЭтаФорма.ТекстСообщения = "";
	
	АдресФайла = Неопределено;
	
	ОчиститьСообщения();
	
	Если ВозможностьВыбораФайлов Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ИмяФайлаДанных) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru='Не указан файл данных для загрузки';uk='Не вказаний файл даних для завантаження'"));
			Возврат;
		КонецЕсли;
		
		ПомещаемыеФайлы = Новый Массив;
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(Объект.ИмяФайлаДанных));
		
		ПомещениеФайловЗавершение = Новый ОписаниеОповещения("ПомещениеФайловЗавершение", ЭтотОбъект);
		
		НачатьПомещениеФайлов(ПомещениеФайловЗавершение, ПомещаемыеФайлы, , Ложь);
		
	Иначе
		
		Попытка
			
			ПомещениеФайлаЗавершение = Новый ОписаниеОповещения("ПомещениеФайлаЗавершение", ЭтотОбъект);
			НачатьПомещениеФайла(ПомещениеФайлаЗавершение, АдресФайла, , Истина, УникальныйИдентификатор);
			
		Исключение
			ШаблонСообщения = НСтр("ru='При чтении файла возникла ошибка"
"%1';uk='При читанні файлу виникла помилка"
"%1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ОписаниеОшибки = ИнформацияОбОшибке();
			ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки);
			ЗафиксироватьОшибку(ЭтаФорма, ТекстСообщения,  НСтр("ru='Укажите корректный путь к файлу данных';uk='Вкажіть правильний шлях до файлу даних'"));
			Перерисовать(3);
			Ошибка = Истина;
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайловЗавершение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено
		И ПомещенныеФайлы.Количество() > 0 Тогда
		
		Попытка
			ОписаниеФайлов = ПомещенныеФайлы.Получить(0);
			АдресФайла        = ОписаниеФайлов.Хранение;
			ВыбранноеИмяФайла = ОписаниеФайлов.Имя;
			ВыполнитьЗагрузкуДанных(АдресФайла, ВыбранноеИмяФайла);
		Исключение
			ШаблонСообщения = НСтр("ru='При чтении файла возникла ошибка:"
"%1';uk='При читанні файлу виникла помилка:"
"%1'");
			ОписаниеОшибки = ОписаниеОшибки();
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			ОписаниеОшибки());
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			ЗафиксироватьОшибку(ЭтаФорма, ТекстСообщения);
			Перерисовать(3);
			Ошибка = Истина;
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайлаЗавершение(Результат, АдресФайлаПомещенный, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	ВыбФайл = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ВыбранноеИмяФайла);
	
	Если ВыбФайл.Расширение <> ".xml" Тогда
		ТекстСообщения = НСтр("ru='Неверный формат файла данных';uk='Неправильний формат файлу даних'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Ошибка = Истина;
		
		Перерисовать(3);
		Элементы.СтраницыРезультат.ТекущаяСтраница = Элементы.Ошибки;
		Элементы.КомандаЗакрыть.Доступность = Истина;
		Элементы.СтраницыЗаголовокПеренос.ТекущаяСтраница = Элементы.СтраницаЗаголовокПереносЗавершен;
		ЗафиксироватьОшибку(ЭтаФорма, ТекстСообщения,  НСтр("ru='Укажите корректный путь к файлу данных';uk='Вкажіть правильний шлях до файлу даних'"));
		Возврат;
	КонецЕсли;
	
	ВыполнитьЗагрузкуДанных(АдресФайлаПомещенный, ВыбранноеИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуДанных(АдресФайла, ВыбранноеИмяФайла)
		
	Если АдресФайла = Неопределено Тогда
		Перерисовать(3);
		ТекстСообщения = Нстр("ru='Не удалось получить данные для загрузки';uk='Не вдалося отримати дані для завантаження'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		ЗафиксироватьОшибку(ЭтаФорма, ТекстСообщения,  НСтр("ru='Укажите корректный путь к файлу данных';uk='Вкажіть правильний шлях до файлу даних'"));
		Ошибка = Истина;
		Возврат;
	КонецЕсли;
	
	// Архивные файлы будем идентифицировать по расширению ".zip"
	Если Найти(ВыбранноеИмяФайла, ".zip") > 0 Тогда
		ЭтоАрхив = Истина;
	КонецЕсли; 
	
	Результат = ВыполнитьЗагрузкуДанныхНаСервере(АдресФайла);
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
	Иначе
		Если НЕ ВебКлиент Тогда
			Если Ошибка Тогда
				Перерисовать(3);
				Если ЗначениеЗаполнено(ТекстСообщения) Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
					ЗафиксироватьОшибку(ЭтаФорма, ТекстСообщения,  НСтр("ru='Укажите корректный файл данных';uk='Вкажіть правильний файл даних'"));
				КонецЕсли;
			КонецЕсли;                     
		КонецЕсли;
	КонецЕсли;
	
	Если ИдентификаторКонфигурации = "UBUTK" Тогда
		СинхронизацияДанныхV77Сервер.УстановитьПараметрыСинхронизации(Объект.ИмяФайлаДанных, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайлами() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайламиЗавершение(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	ВозможностьВыбораФайлов = РасширениеРаботыСФайламиПодключено;
	УправлениеФормой(ЭтотОбъект);
	Шагнуть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ИмяФайлаДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла(Элемент);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНДНОЙ ПАНЕЛИ

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	Шагнуть();
	ОтработатьНажатиеВперед();

КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаОшибкиНажатие(Элемент)
	
	ПодготовитьОтчетОбОшибках();

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлыБухгалтерия77(Команда)
	
	ЗаписатьФайлы("ACC");
	
КонецПроцедуры


&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Если Окно.Основное Тогда
		ПерейтиПоНавигационнойСсылке("e1cib/navigationpoint/СправочникиИНастройкиУчета82");
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НомерСтраницы = 0;
	
	ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПолучитьПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
	СистемнаяИнфо = Новый СистемнаяИнформация;
	ВебКлиент = ЗначениеЗаполнено(СистемнаяИнфо.ИнформацияПрограммыПросмотра);
	
	Если НЕ ПараметрыСоединения.Свойство("File") Тогда
		ВебКлиент = Истина;
	КонецЕсли;
	
	Если ВебКлиент Тогда
		Элементы.ГруппаЗаписатьФайлы.Видимость = Истина;
	Иначе
		Элементы.ГруппаЗаписатьФайлы.Видимость = Ложь;
	КонецЕсли;
	
	ОписаниеЭтапов = Новый Соответствие;
	ОписаниеЭтапов.Вставить(3, "Загрузка");
	ОписаниеЭтапов.Вставить(4, "Проведение");
	ОписаниеЭтапов.Вставить(5, "Проверка");
	
	Этапы = Новый ФиксированноеСоответствие(ОписаниеЭтапов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ПодключениеРасширенияРаботыСФайлами", 0.1, Истина);
	#Иначе
		ВозможностьВыбораФайлов = Истина;
		УправлениеФормой(ЭтотОбъект);
		Шагнуть();
	#КонецЕсли
	
КонецПроцедуры


