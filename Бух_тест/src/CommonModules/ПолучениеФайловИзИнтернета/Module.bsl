////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение файлов из Интернета"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его по указанному пути на сервере.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>
//   ПараметрыПолучения - Структура со свойствами:
//      * ПутьДляСохранения    - Строка       - путь на сервере (включая имя файла), для сохранения скачанного файла
//      * Пользователь         - Строка       - пользователь от имени которого установлено соединение
//      * Пароль               - Строка       - пароль пользователя от которого установлено соединение
//      * Порт                 - Число        - порт сервера с которым установлено соединение
//      * Таймаут              - Число        - таймаут на получение файла, в секундах
//      * ЗащищенноеСоединение - Булево       - для случая http загрузки флаг указывает, что соединение должно производиться через https
//      * ПассивноеСоединение  - Булево       - для случая ftp загрузки флаг указывает, что соединение должно пассивным (или активным)
//      * Заголовки            - Соответствие - см. описание параметра Заголовки объекта HTTPЗапрос
//   ЗаписыватьОшибку   - Булево - Признак необходимости записи ошибки в журнал регистрации при получении файла
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла
//      * Путь   - Строка   - путь к файлу на сервере, ключ используется только если статус Истина
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь
//      * Заголовки         - Соответствие - см. описание параметра Заголовки объекта HTTPОтвет
//
Функция СкачатьФайлНаСервере(Знач URL, ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкиПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.СтруктураПараметровПолученияФайла();
	
	Если ПараметрыПолучения <> Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(НастройкиПолучения, ПараметрыПолучения);
		
	КонецЕсли;
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "Сервер");
	НастройкаСохранения.Вставить("Путь", НастройкиПолучения.ПутьДляСохранения);
	
	Возврат ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(URL,
		НастройкиПолучения, НастройкаСохранения, ЗаписыватьОшибку);
	
КонецФункции

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его во временное хранилище..
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>
//   ПараметрыПолучения - Структура со свойствами:
//      * Пользователь         - Строка       - пользователь от имени которого установлено соединение
//      * Пароль               - Строка       - пароль пользователя от которого установлено соединение
//      * Порт                 - Число        - порт сервера с которым установлено соединение
//      * Таймаут              - Число        - таймаут на получение файла, в секундах
//      * ЗащищенноеСоединение - Булево       - для случая http загрузки флаг указывает, что соединение должно производиться через https
//      * ПассивноеСоединение  - Булево       - для случая ftp загрузки флаг указывает, что соединение должно пассивным (или активным)
//      * Заголовки            - Соответствие - см. описание параметра Заголовки объекта HTTPЗапрос
//   ЗаписыватьОшибку   - Булево - Признак необходимости записи ошибки в журнал регистрации при получении файла
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла
//      * Путь   - Строка   - адрес временного хранилища с двоичными данными файла, ключ используется только если статус Истина
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь
//      * Заголовки         - Соответствие - см. описание параметра Заголовки объекта HTTPОтвет
//
Функция СкачатьФайлВоВременноеХранилище(Знач URL, ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкиПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.СтруктураПараметровПолученияФайла();
	
	Если ПараметрыПолучения <> Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(НастройкиПолучения, ПараметрыПолучения);
		
	КонецЕсли;
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "ВременноеХранилище");
	
	Возврат ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(URL,
		НастройкиПолучения, НастройкаСохранения, ЗаписыватьОшибку);
	
КонецФункции

// Возвращает настройку прокси сервера для доступа в Интернет со стороны
// клиента для текущего пользователя.
//
// Возвращаемое значение:
//   Соответствие - свойства:
//		ИспользоватьПрокси - использовать ли прокси-сервер
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера
//		Сервер       - адрес прокси-сервера
//		Порт         - порт прокси-сервера
//		Пользователь - имя пользователя для авторизации на прокси-сервере
//		Пароль       - пароль пользователя
//
Функция НастройкиПроксиНаКлиенте() Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкаПроксиСервера");
	
КонецФункции

// Возвращает параметры настройки прокси-сервера на стороне сервера 1С:Предприятие
//
// Возвращаемое значение:
//   Соответствие - свойства:
//		ИспользоватьПрокси - использовать ли прокси-сервер
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера
//		Сервер       - адрес прокси-сервера
//		Порт         - порт прокси-сервера
//		Пользователь - имя пользователя для авторизации на прокси-сервере
//		Пароль       - пароль пользователя
//
Функция НастройкиПроксиНаСервере() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы().Файловый Тогда
		Возврат НастройкиПроксиНаКлиенте();
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		НастройкиПроксиНаСервере = Константы.НастройкаПроксиСервера.Получить().Получить();
		Возврат ?(ТипЗнч(НастройкиПроксиНаСервере) = Тип("Соответствие"),
				  НастройкиПроксиНаСервере,
				  Неопределено);
	КонецЕсли;
	
КонецФункции

// Устарела. Следует использовать НастройкиПроксиНаСервере.
//
Функция ПолучитьНастройкиПроксиНаСервере1СПредприятие() Экспорт
	
	Возврат НастройкиПроксиНаСервере();
	
КонецФункции	

// Устарела. Следует использовать НастройкиПроксиНаКлиенте.
//
Функция ПолучитьНастройкуПроксиСервера() Экспорт
	
	Возврат НастройкиПроксиНаКлиенте();
	
КонецФункции

#КонецОбласти
