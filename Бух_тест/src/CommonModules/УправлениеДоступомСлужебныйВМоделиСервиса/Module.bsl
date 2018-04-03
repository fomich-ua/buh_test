///////////////////////////////////////////////////////////////////////////////////
// Подсистема "Управление доступом в модели сервиса".
//
///////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
			"УправлениеДоступомСлужебныйВМоделиСервиса");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриПолученииСпискаШаблонов"].Добавить(
				"УправлениеДоступомСлужебныйВМоделиСервиса");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		СерверныеОбработчики[
			"ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПослеЗагрузкиДанныхИзДругойМодели"].Добавить(
				"УправлениеДоступомСлужебныйВМоделиСервиса");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриПолученииСпискаШаблонов.
//
// Формирует список шаблонов заданий очереди.
//
// Параметры:
//  Шаблоны - Массив строк. В параметр следует добавить имена предопределенных
//   неразделенных регламентных заданий, которые должны использоваться в качестве
//   шаблонов для заданий очереди.
//
Процедура ПриПолученииСпискаШаблонов(Шаблоны) Экспорт
	
	Шаблоны.Добавить("ЗаполнениеДанныхДляОграниченияДоступа");
	
КонецПроцедуры

// Устанавливает в очереди заданий флаг использования того задания, которое
// соответствует регламентному заданию для заполнения данных ограничения доступа.
//
// Параметры:
//  Использование - Булево - новое значения флага использования.
//
Процедура УстановитьЗаполнениеДанныхДляОграниченияДоступа(Использование) Экспорт
	
	Шаблон = ОчередьЗаданий.ШаблонПоИмени("ЗаполнениеДанныхДляОграниченияДоступа");
	
	ОтборЗадания = Новый Структура;
	ОтборЗадания.Вставить("Шаблон", Шаблон);
	Задания = ОчередьЗаданий.ПолучитьЗадания(ОтборЗадания);
	
	ПараметрыЗадания = Новый Структура("Использование", Использование);
	ОчередьЗаданий.ИзменитьЗадание(Задания[0].Идентификатор, ПараметрыЗадания);
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.0.4";
	Обработчик.Процедура = "УправлениеДоступомСлужебныйВМоделиСервиса.ОбновитьГруппыДоступаАдминистраторовВМоделиСервиса";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.1.15";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "УправлениеДоступомСлужебныйВМоделиСервиса.ОбновитьРасписаниеШаблонаЗаполнениеДанныхДляОграниченияДоступа";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Перемещает всех пользователей из группы доступа "Администраторы данных" в
// группу доступа Администраторы.
//  Удаляет профиль "Администратор данных" и группу доступа "Администраторы данных".
// 
Процедура ОбновитьГруппыДоступаАдминистраторовВМоделиСервиса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПрофильАдминистраторДанныхСсылка = Справочники.ПрофилиГруппДоступа.ПолучитьСсылку(
		Новый УникальныйИдентификатор("f0254dd0-3558-4430-84c7-154c558ae1c9"));
		
	ГруппаДоступаАдминистраторыДанныхСсылка = Справочники.ГруппыДоступа.ПолучитьСсылку(
		Новый УникальныйИдентификатор("c7684994-34c9-4ddc-b31c-05b2d833e249"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПрофильАдминистраторДанныхСсылка",        ПрофильАдминистраторДанныхСсылка);
	Запрос.УстановитьПараметр("ГруппаДоступаАдминистраторыДанныхСсылка", ГруппаДоступаАдминистраторыДанныхСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Ссылка = &ГруппаДоступаАдминистраторыДанныхСсылка
	|	И ГруппыДоступа.Профиль = &ПрофильАдминистраторДанныхСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
	|ГДЕ
	|	ПрофилиГруппДоступа.Ссылка = &ПрофильАдминистраторДанныхСсылка";
	
	НачатьТранзакцию();
	Попытка
		
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		
		Если НЕ РезультатыЗапроса[0].Пустой() Тогда
			ГруппаАдминистраторы = Справочники.ГруппыДоступа.Администраторы.ПолучитьОбъект();
			ГруппаАдминистраторыДанных = ГруппаДоступаАдминистраторыДанныхСсылка.ПолучитьОбъект();
			
			Если ГруппаАдминистраторыДанных.Пользователи.Количество() > 0 Тогда
				Для каждого Строка Из ГруппаАдминистраторыДанных.Пользователи Цикл
					Если ГруппаАдминистраторы.Пользователи.Найти(Строка.Пользователь, "Пользователь") = Неопределено Тогда
						ГруппаАдминистраторы.Пользователи.Добавить().Пользователь = Строка.Пользователь;
					КонецЕсли;
				КонецЦикла;
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ГруппаАдминистраторы);
			КонецЕсли;
			ОбновлениеИнформационнойБазы.УдалитьДанные(ГруппаАдминистраторыДанных);
		КонецЕсли;
		
		Если НЕ РезультатыЗапроса[1].Пустой() Тогда
			ПрофильАдминистраторДанных = ПрофильАдминистраторДанныхСсылка.ПолучитьОбъект();
			ОбновлениеИнформационнойБазы.УдалитьДанные(ПрофильАдминистраторДанных);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обновляет настройки регламентного задания.
Процедура ОбновитьРасписаниеШаблонаЗаполнениеДанныхДляОграниченияДоступа() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Шаблон = ОчередьЗаданий.ШаблонПоИмени("ЗаполнениеДанныхДляОграниченияДоступа");
	ШаблонОбъект = Шаблон.ПолучитьОбъект();
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодНедель = 1;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодПовтораВТечениеДня = 300;
	Расписание.ПаузаПовтора = 90;
	
	ШаблонОбъект.Расписание = Новый ХранилищеЗначения(Расписание);
	ШаблонОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается после окончания загрузки данных из локальной версии
// в область данных сервиса или наоборот.
//
Процедура ПослеЗагрузкиДанныхИзДругойМодели() Экспорт
	
	Справочники.ПрофилиГруппДоступа.ОбновитьПоставляемыеПрофили(); 
	
КонецПроцедуры

// Вызывается при обработке сообщения http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetFullControl
//
// Параметры:
//  ПользовательОбластиДанных - СправочникСсылка.Пользователи - пользователь 
//   принадлежность которого к группе Администраторы требуется изменить
//  ДоступРазрешен - Булево - Истина включить пользователя в группу,
//   Ложь- исключить пользователя из группы
//
Процедура УстановитьПринадлежностьПользователяКГруппеАдминистраторы(Знач ПользовательОбластиДанных, Знач ДоступРазрешен) Экспорт
	
	ГруппаАдминистраторы = Справочники.ГруппыДоступа.Администраторы;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ГруппыДоступа");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", ГруппаАдминистраторы);
	Блокировка.Заблокировать();
	
	ГруппаОбъект = ГруппаАдминистраторы.ПолучитьОбъект();
	
	СтрокаПользователь = ГруппаОбъект.Пользователи.Найти(ПользовательОбластиДанных, "Пользователь");
	
	Если ДоступРазрешен И СтрокаПользователь = Неопределено Тогда
		
		СтрокаПользователь = ГруппаОбъект.Пользователи.Добавить();
		СтрокаПользователь.Пользователь = ПользовательОбластиДанных;
		ГруппаОбъект.Записать();
		
	ИначеЕсли НЕ ДоступРазрешен И СтрокаПользователь <> Неопределено Тогда
		
		ГруппаОбъект.Пользователи.Удалить(СтрокаПользователь);
		ГруппаОбъект.Записать();
	Иначе
		УправлениеДоступом.ОбновитьРолиПользователей(ПользовательОбластиДанных);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
