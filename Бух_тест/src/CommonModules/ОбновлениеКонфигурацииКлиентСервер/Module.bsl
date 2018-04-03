////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации"
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру настроек обновления конфигурации и обновляет их.
//
// Параметры:
//	НастройкиОбновления - структура - старые настройки обновления, которые необходимо обновить
//
// Возвращаемое значение:
//   Структура   - структура настроек обновления.
//
Функция ПолучитьОбновленныеНастройкиОбновленияКонфигурации(НастройкиОбновления) Экспорт
	
	Если НастройкиОбновления = Неопределено Тогда
		НастройкиОбновления = НовыеНастройкиОбновленияКонфигурации();
	Иначе
		НовыеНастройки = НовыеНастройкиОбновленияКонфигурации();
		Для каждого Настройка Из НовыеНастройки Цикл
			Если НЕ НастройкиОбновления.Свойство(Настройка.Ключ) Тогда
				  НастройкиОбновления.Вставить(Настройка.Ключ, Настройка.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат НастройкиОбновления;
	
КонецФункции

// Заполняет структуру настроек обновления конфигурации и возвращает их.
//
// Возвращаемое значение:
//   Структура   - структура настроек обновления.
//
Функция НовыеНастройкиОбновленияКонфигурации() Экспорт 
	
	Результат = Новый Структура;
	Результат.Вставить("КодПользователяСервераОбновлений", "");
	Результат.Вставить("ПарольСервераОбновлений", "");
	Результат.Вставить("ЗапомнитьПарольСервераОбновлений", Истина);
	Результат.Вставить("ПроверятьНаличиеОбновленияПриЗапуске", Ложь);
	Результат.Вставить("ИсточникОбновления", 2);
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Результат.Вставить("РежимОбновления", ?(ОбщегоНазначения.ИнформационнаяБазаФайловая(), 0, 2));
	Результат.Вставить("ДатаВремяОбновления", ДобавитьДни(НачалоДня(ТекущаяДатаСеанса()), 1));
#Иначе
	Результат.Вставить("РежимОбновления", ?(СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая, 0, 2));
	Результат.Вставить("ДатаВремяОбновления", ДобавитьДни(НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()), 1));
#КонецЕсли
	Результат.Вставить("ВыслатьОтчетНаПочту", Ложь);
	Результат.Вставить("АдресЭлектроннойПочты", "");
	Результат.Вставить("КодЗадачиПланировщика", 0);
	Результат.Вставить("РасписаниеПроверкиНаличияОбновления", Неопределено);
	Результат.Вставить("ПовторныйЗапуск", Ложь);
	Результат.Вставить("ИмяФайлаОбновления", "");
	Результат.Вставить("НуженФайлОбновления", 1);
	Результат.Вставить("СоздаватьРезервнуюКопию", 1);
	Результат.Вставить("ИмяКаталогаРезервнойКопииИБ", "");
	Результат.Вставить("ВосстанавливатьИнформационнуюБазу", Истина);
	Результат.Вставить("АдресСервераДляПроверкиНаличияОбновления", "");
	Результат.Вставить("КаталогОбновлений", "");
	Результат.Вставить("АдресСервисаПроверкиЛегальности", "");
	Результат.Вставить("КороткоеИмяКонфигурации", "");
	Результат.Вставить("АдресРесурсаДляПроверкиНаличияОбновления", "");
	Результат.Вставить("ДискИТС", "");
	Результат.Вставить("ИсточникДискаИТС", 0);
	Результат.Вставить("КластерТребуетАутентификации", Ложь);
	Результат.Вставить("ИмяАдминистратораКластера", "");
	Результат.Вставить("ПарольАдминистратораКластера", "");
	Результат.Вставить("НестандартныеПортыСервера", Ложь);
	Результат.Вставить("ПортАгентаСервера", 0);
	Результат.Вставить("ПортКластераСерверов", 0);
	Результат.Вставить("ВремяПоследнейПроверкиОбновления", Дата(1, 1, 1));
	Возврат Результат;

КонецФункции	

// Добавляет заданное количество дней к дате
//
// Параметры:
//  Дата		- Дата	- Исходная дата
//  ЧислоДней	- Число	- Количество дней, добавляемых к исходной дате
//
Функция ДобавитьДни(Знач Дата, Знач ЧислоДней) Экспорт
	
	Если ЧислоДней > 0 Тогда
		Разница = День(Дата) + ЧислоДней - День(КонецМесяца(Дата));
		Если Разница > 0 Тогда
			НоваяДата = ДобавитьМесяц(Дата, 1);	
			Возврат Дата(Год(НоваяДата), Месяц(НоваяДата), Разница, 
				Час(НоваяДата), Минута(НоваяДата), Секунда(НоваяДата));
		КонецЕсли;
	ИначеЕсли ЧислоДней < 0 Тогда
		Разница = День(Дата) + ЧислоДней - День(НачалоМесяца(Дата));
		Если Разница < 1 Тогда
			НоваяДата = ДобавитьМесяц(Дата, -1);	
			Возврат Дата(Год(НоваяДата), Месяц(НоваяДата), День(КонецМесяца(НоваяДата)) - Разница, 
				Час(НоваяДата), Минута(НоваяДата), Секунда(НоваяДата));
		КонецЕсли;
	КонецЕсли; 
	Возврат Дата(Год(Дата), Месяц(Дата), День(Дата) + ЧислоДней, Час(Дата), Минута(Дата), Секунда(Дата));
	
КонецФункции

// Добавляет к переданному пути каталога конечный символ-разделитель, если он отсутствует.
// В случае, когда параметр "Платформа" не указан, разделитель выбирается, исходя из уже имеющихся
// разделителей в параметре "ПутьКаталога".
//
// Параметры:
//  ПутьКаталога - Строка - путь к каталогу;
//  Платформа - ТипПлатформы - тип платформы, в рамках которой осуществляется работа (влияет на выбор разделителя).
//
// Возвращаемое значение:
//  Строка   - путь к каталогу с конечным символом-разделителем.
//
// Примеры использования:
//  Результат = ДобавитьКонечныйРазделительПути("C:\Мой каталог"); // возвращает "C:\Мой каталог\"
//  Результат = ДобавитьКонечныйРазделительПути("C:\Мой каталог\"); // возвращает "C:\Мой каталог\"
//  Результат = ДобавитьКонечныйРазделительПути("ftp://Мой каталог"); // возвращает "ftp://Мой каталог/"
//
Функция ДобавитьКонечныйРазделительПути(Знач ПутьКаталога) Экспорт
	
	Если ПустаяСтрока(ПутьКаталога) Тогда
		Возврат ПутьКаталога;
	КонецЕсли;
	
	ДобавляемыйСимвол = "\";
	Если Найти(ПутьКаталога, "/") > 0 Тогда
		ДобавляемыйСимвол = "/";
	КонецЕсли;
	
	Если Прав(ПутьКаталога, 1) <> ДобавляемыйСимвол Тогда
		Возврат ПутьКаталога + ДобавляемыйСимвол;
	Иначе
		Возврат ПутьКаталога;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
