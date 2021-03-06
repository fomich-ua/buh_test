#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
// 
// Параметры:
//	Настройки - Структура - Сеодержит настройки по умолчанию
//
Процедура ОпределитьНастройки(Настройки, ИдентификаторНастройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.ПутьКФайлуКомплектаПравилНаПользовательскомСайте = "";
	Настройки.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "\1c\smallbusiness\";
	
КонецПроцедуры

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат "Настройки обмена для УНФ-БП";
	
КонецФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена
// 
Функция НастройкаОтборовНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ПравилаОтправкиДокументов",         "АвтоматическаяСинхронизация");
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",      НачалоГода(ТекущаяДата()));
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям",   Ложь);
	СтруктураНастроек.Вставить("Организации",                       СтруктураТабличнойЧастиОрганизации);
	
	Возврат СтруктураНастроек;
КонецФункции

// Возвращает структуру значений по умолчению для узла;
// Структура настроек повторяет состав реквизитов шапки плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена
// 
Функция ЗначенияПоУмолчаниюНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("СтатьяЗатрат");
	СтруктураНастроек.Вставить("СтатьяПрочихДоходовРасходов");
	СтруктураНастроек.Вставить("УслугаПоВознаграждению");
	СтруктураНастроек.Вставить("СпособОтраженияРасходов");
	СтруктураНастроек.Вставить("РежимВыгрузкиПриНеобходимости", Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                       полученная при помощи функции НастройкаОтборовНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	ТекстОписания = НСтр("ru='Вся нормативно-справочная информация автоматически регистрируется к отправке;';uk='Уся нормативно-довідкова інформація автоматично реєструється до відправки;'");
	
	Если НастройкаОтборовНаУзле.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация" Тогда
		Если ЗначениеЗаполнено(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов) Тогда
			ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru='Документы автоматически регистрируются к отправке начиная с %ДатаНачала%;';uk='Документи автоматично реєструються до відправки починаючи з %ДатаНачала%;'");
			ТекстОписания = СтрЗаменить(ТекстОписания,"%ДатаНачала%", Формат(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов, "ДФ=dd.MM.yyyy"));
		Иначе
			ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru='Все документы автоматически регистрируются к отправке;';uk='Усі документи автоматично реєструються до відправки;'");
		КонецЕсли;
		Если НастройкаОтборовНаУзле.ИспользоватьОтборПоОрганизациям Тогда
			КоллекцияЗначений = НастройкаОтборовНаУзле.Организации.Организация;
			ПредставлениеКоллекции = СокращенноеПредставлениеКоллекцииЗначений(КоллекцияЗначений);
			ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru='Отправлять документы с отбором по организациям: %ПредставлениеКоллекции%;';uk='Відправляти документи з відбором по організаціях: %ПредставлениеКоллекции%;'");
			ТекстОписания = СтрЗаменить(ТекстОписания, "%ПредставлениеКоллекции%", ПредставлениеКоллекции);
		Иначе
			ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru='по всем организациям';uk='по всіх організаціях'");
		КонецЕсли;
	ИначеЕсли НастройкаОтборовНаУзле.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru='Документы не отправляются;';uk='Документи не надсилаються;'");
	КонецЕсли;
	
	Возврат ТекстОписания;
	
КонецФункции

// Возвращает строку описания значений по умолчанию для пользователя;
// Прикладной разработчик на основе установленных значений по умолчанию на узле должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчанию(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	ТекстОписания = НСтр("ru='Основная статья затрат для подстановки в документы по умолчанию: %Значение%';uk='Основна стаття витрат для підстановки в документи за замовчуванням: %Значение%'");
	Если ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.СтатьяЗатрат) Тогда
		ТекстОписания = СтрЗаменить(ТекстОписания, "%Значение%", Строка(ЗначенияПоУмолчаниюНаУзле.СтатьяЗатрат));
	Иначе
		ТекстОписания = СтрЗаменить(ТекстОписания, "%Значение%", НСтр("ru='не указана';uk='не вказана'"));
	КонецЕсли;
	
	ТекстОписания = ТекстОписания + Символы.ПС + Символы.ПС + НСтр("ru='Основная статья прочих доходов и расходов для подстановки в документы по умолчанию: %Значение%';uk='Основна стаття інших доходів і витрат для підстановки в документи за замовчуванням: %Значение%'");
	Если ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.СтатьяПрочихДоходовРасходов) Тогда
		ТекстОписания = СтрЗаменить(ТекстОписания, "%Значение%", Строка(ЗначенияПоУмолчаниюНаУзле.СтатьяПрочихДоходовРасходов));
	Иначе
		ТекстОписания = СтрЗаменить(ТекстОписания, "%Значение%", НСтр("ru='не указана';uk='не вказана'"));
	КонецЕсли;
	
	ТекстОписания = ТекстОписания + Символы.ПС + Символы.ПС + НСтр("ru='Услуга по комиссионному вознаграждению для подстановки в документ Отчет комитенту по умолчанию: %Значение%';uk='Послуга з комісійної винагороди для підстановки в документ Звіт комітенту за замовчуванням: %Значение%'");
	Если ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.УслугаПоВознаграждению) Тогда
		ТекстОписания = СтрЗаменить(ТекстОписания, "%Значение%", Строка(ЗначенияПоУмолчаниюНаУзле.УслугаПоВознаграждению));
	Иначе
		ТекстОписания = СтрЗаменить(ТекстОписания, "%Значение%", НСтр("ru='не указана';uk='не вказана'"));
	КонецЕсли;
	
	ТекстОписания = ТекстОписания + Символы.ПС + Символы.ПС + НСтр("ru='Способ отражения расходов для заполнения документа Передача материалов в эксплуатацию: %Значение%';uk='Спосіб відображення витрат для заповнення документу Передача матеріалів в експлуатацію: %Значение%'");
	Если ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.СпособОтраженияРасходов) Тогда
		ТекстОписания = СтрЗаменить(ТекстОписания, "%Значение%", Строка(ЗначенияПоУмолчаниюНаУзле.СпособОтраженияРасходов));
	Иначе
		ТекстОписания = СтрЗаменить(ТекстОписания, "%Значение%", НСтр("ru='не указан';uk='не вказаний'"));
	КонецЕсли;
	
	Возврат ТекстОписания;

КонецФункции

// Возвращает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//  Строка, Неогранич - представление команды, выводимое в пользовательском интерфейсе.
//
// Например:
//	Возврат НСтр("ru='Создать обмен в распределенной информационной базе';uk='Створити обмін в розподіленій інформаційній базі'");
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат НСтр("ru='Управление небольшой фирмой, ред. 1.6';uk='Управління невеликою фірмою, ред. 1.6'");
	
КонецФункции

// Определяет, будет ли использоваться помощник для создания новых узлов плана обмена.
//
// Возвращаемое значение:
//  Булево - признак использования помощника.
//
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
// Для планов обмена не РИБ функция возвращает пустую строку
//
// Возвращаемое значение:
//  Строка, Неогранич - имя формы
//
// Например:
//	Возврат "ПланОбмена._ДемоРаспределеннаяИнформационнаяБаза.Форма.ФормаСозданияНачальногоОбраза";
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Возврат Результат;
	
КонецФункции

Функция ОбщиеДанныеУзлов(ВерсияКорреспондента, ИмяФормы) Экспорт
	
	Возврат "ДатаНачалаВыгрузкиДокументов, Организации, РежимВыгрузкиПриНеобходимости, РучнойОбмен";
	
КонецФункции

Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
	
КонецПроцедуры

Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает признак того, что план обмена поддерживает обмен данными с корреспондентом, работающим в модели сервиса.
// Если признак установлен, то становится возможным создать обмен данными когда эта информационная база
// работает в локальном режиме, а корреспондент в модели сервиса.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Истина;
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчета() Экспорт
	
	ПоясняющийТекст = НСтр("ru='	Перед выполнением обмена необходимо заполнить информацию об организациях, документы по которым будут загружены"
"из приложения Управление небольшой фирмой, а также заполнить счета учета по умолчанию в регистрах сведений Счета учета номенклатуры и Счета расчетов с контрагентами."
"Это необходимо для корректного проведения документов.';uk='	Перед виконанням обміну необхідно заповнити інформацію про організації, документи по яких будуть завантажені"
"з додатка Управління невеликою фірмою, а також заповнити рахунки обліку за замовчуванням в регістрах відомостей Рахунки обліку номенклатури і Рахунки розрахунків з контрагентами."
"Це необхідно для коректного проведення документів.'"); 
	
	Возврат ПоясняющийТекст;
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	ПоясняющийТекст = НСтр("ru='	Позволяет синхронизировать данные между приложениями Управление небольшой фирмой, ред. 1.6 и Бухгалтерия для Украины, ред. 2.0."
"Из приложения Управление небольшой фирмой в приложение Бухгалтерия для Украины переносятся справочники и все необходимые документы, а "
"из приложения Бухгалтерия для Украины в приложение Управление небольшой фирмой - справочники и документы учета денежных средств. Для "
"получения более подробной информации нажмите на ссылку Подробное описание.';uk='	Дозволяє синхронізувати дані між додатками Управління невеликою фірмою, ред. 1.6 і Бухгалтерія для України, ред. 2.0."
"З додатка Управління невеликою фірмою в додаток Бухгалтерія для України переносяться довідники і усі необхідні документи, а "
"з додатка Бухгалтерія для України в додаток Управління невеликою фірмою - довідники і документи обліку грошових коштів. Для"
"отримання більш докладної інформації натисніть на посилання Детальний опис.'");
	
	Возврат ПоясняющийТекст;
	
КонецФункции // КраткаяИнформацияПоОбмену()

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
// в виде гиперссылки или полного пути к форме
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("РаботаВМоделиСервиса") Тогда
		ПутьКИнформацииПоОбмену = "https://1cfresh.com/articles/obmen";
	Иначе
		ПутьКИнформацииПоОбмену = "ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.Форма.ПодробнаяИнформация";
	КонецЕсли;
	
	Возврат ПутьКИнформацииПоОбмену;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает сокращенное строковое представление коллекции значений.
// 
// Параметры:
//  Коллекция 						- массив или список значений.
//  МаксимальноеКоличествоЭлементов - число, максимальное количество элементов включаемое в представление.
//
// Возвращаемое значение:
//  Строка.
//
Функция СокращенноеПредставлениеКоллекцииЗначений(Коллекция, МаксимальноеКоличествоЭлементов = 3) Экспорт
	
	СтрокаПредставления = "";
	
	КоличествоЗначений			 = Коллекция.Количество();
	КоличествоВыводимыхЭлементов = Мин(КоличествоЗначений, МаксимальноеКоличествоЭлементов);
	
	Если КоличествоВыводимыхЭлементов = 0 Тогда
		
		Возврат "";
		
	Иначе
		
		Для НомерЗначения = 1 По КоличествоВыводимыхЭлементов Цикл
			
			СтрокаПредставления = СтрокаПредставления + Коллекция.Получить(НомерЗначения - 1) + ", ";	
			
		КонецЦикла;
		
		СтрокаПредставления = Лев(СтрокаПредставления, СтрДлина(СтрокаПредставления) - 2);
		Если КоличествоЗначений > КоличествоВыводимыхЭлементов Тогда
			СтрокаПредставления = СтрокаПредставления + ", ... ";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для работы через внешнее соединение

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",      НачалоГода(ТекущаяДата()));
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям",   Ложь);
	СтруктураНастроек.Вставить("Организации",                       СтруктураТабличнойЧастиОрганизации);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	ОграничениеДатаНачалаВыгрузкиДокументов = "";
	ОграничениеОтборПоОрганизациям = "";
	
	// дата начала выгрузки документов
	Если ЗначениеЗаполнено(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов) Тогда
		
		// "Выгружать документы, начиная с 1 января 2009г."
		ОграничениеДатаНачалаВыгрузкиДокументов = НСтр("ru='Начиная с [ДатаНачалаВыгрузкиДокументов]';uk='Починаючи з [ДатаНачалаВыгрузкиДокументов]'");
		ОграничениеДатаНачалаВыгрузкиДокументов = СтрЗаменить(ОграничениеДатаНачалаВыгрузкиДокументов, "[ДатаНачалаВыгрузкиДокументов]", Формат(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD"));
		
	Иначе
		
		ОграничениеДатаНачалаВыгрузкиДокументов = "За весь период ведения учета в программе";
		
	КонецЕсли;
	
	// отбор по организациям
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоОрганизациям Тогда
		
		СтрокаПредставленияОтбора = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(НастройкаОтборовНаУзле.Организации.Организация, "; ");
		
		ОграничениеОтборПоОрганизациям = НСтр("ru='Только по организациям: [СтрокаПредставленияОтбора]';uk='Тільки за організаціями: [СтрокаПредставленияОтбора]'");
		ОграничениеОтборПоОрганизациям = СтрЗаменить(ОграничениеОтборПоОрганизациям, "[СтрокаПредставленияОтбора]", СтрокаПредставленияОтбора);
		
	Иначе
		
		ОграничениеОтборПоОрганизациям = НСтр("ru='По всем организациям';uk='По всіх організаціях'");
		
	КонецЕсли;
	
	Результат = НСтр("ru='Выгружать документы и справочную информацию:"
"[ОграничениеДатаНачалаВыгрузкиДокументов]"
"[ОграничениеОтборПоОрганизациям]';uk='Вивантажувати документи і довідкову інформацію:"
"[ОграничениеДатаНачалаВыгрузкиДокументов]"
"[ОграничениеОтборПоОрганизациям]'");
		
	//
	
	Результат = СтрЗаменить(Результат, "[ОграничениеДатаНачалаВыгрузкиДокументов]", ОграничениеДатаНачалаВыгрузкиДокументов);
	Результат = СтрЗаменить(Результат, "[ОграничениеОтборПоОрганизациям]",          ОграничениеОтборПоОрганизациям);
	
	Возврат Результат;
	
КонецФункции

// Возвращает строку описания значений по умолчанию для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных значений по умолчанию на узле базы корреспондента должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчаниюБазыКорреспондента(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчетаБазыКорреспондента(ВерсияКорреспондента) Экспорт
	
	Возврат "";
	
КонецФункции

// Функция возвращает имя обработки выгрузки данных
//.
Функция ИмяОбработкиВыгрузки() Экспорт
	
	Возврат "";
	
КонецФункции // ИмяОбработкиВыгрузки()

// Функция возвращает имя обработки загрузки данных
//
Функция ИмяОбработкиЗагрузки() Экспорт
	
	Возврат "";
	
КонецФункции // ИмяОбработкиЗагрузки()

// Возвращает версию подсистемы обмена данными
// Для вновь создаваемых планов обмена функция должна
// возвращать значение Перечисления.ВерсииПодсистемыОбменаДанными.Версия30
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ВерсииПодсистемыОбменаДанными
//
Функция ВерсияОбменаДанными() Экспорт
	
	Возврат Перечисления.ВерсииПодсистемыОбменаДанными.Версия30;
	
КонецФункции

// Процедура предназначена для получения дополнительных данных, используемых при настройке обмена в базе-корреспонденте.
//
//  Параметры:
// ДополнительныеДанные – Структура. Дополнительные данные, которые будут использованы
// в базе-корреспонденте при настройке обмена.
// В качестве значений структуры применимы только значения, поддерживающие XDTO-сериализацию.
//
Процедура ПолучитьДополнительныеДанныеДляКорреспондента(ДополнительныеДанные) Экспорт
	
КонецПроцедуры

Функция ИмяКонфигурацииИсточника() Экспорт
	
	Возврат "БухгалтерияДляУкраины";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
//Дополнение к функционалу БСП

//Возвращает режим запуска, в случае интерактивного инициирования синхронизации
//Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация
//На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает сценарий работы помощника интерактивного сопостовления
//НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
//Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
//Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

// Обработчик события при подключении к корреспонденту.
// Событие возникает при успешном подключении к корреспонденту и получении версии конфигурации корреспондента
// при настройке обмена с использованием помощника через прямое подключение
// или при подключении к корреспонденту через Интернет.
// В обработчике можно проанализировать версию корреспондента и,
// если настройка обмена не поддерживается с корреспондентом указанной версии, то вызвать исключение.
//
//  Параметры:
// ВерсияКорреспондента (только чтение) – Строка – версия конфигурации корреспондента, например, "2.1.5.1".
//
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке данных узла-отправителя.
// Событие возникает при отправке данных узла-отправителя из текущей базы в корреспондент,
// до помещения данных узла в сообщения обмена.
// В обработчике можно изменить отправляемые данные или вовсе отказаться от отправки данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется отправка данных.
// Игнорировать – Булево – признак отказа от выгрузки данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то отправка данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать – Булево – признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая настройка дополнения выгрузки

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Cтрока            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Cтрока            - Заголовок для отрисовки на форме команды открытия формы настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Можно  использовать специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки, предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле "Ссылка.Организация"
//
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	//
	// Пример использования в демо-БСП 2.1.5.12 (ПО._ДемоОбменСБиблиотекойСтандартныхПодсистем)
	//
	
КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку"
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора
//     Параметры  - Структура        - Характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Могут быть использованы специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", будет использовано поле "Ссылка.Организация"
//
// Возвращаемое значение: 
//     Строка - описание отбора
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	//
	// Пример использования в демо-БСП 2.1.5.12 (ПО._ДемоОбменСБиблиотекойСтандартныхПодсистем)
	//
	
КонецФункции

#КонецЕсли