////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с почтовыми сообщениями".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает указан ли в учетной записи пароль или нет
//
// см. описание функции РаботаСПочтовымиСообщениямиСлужебный.ПарольЗадан.
//
Функция ПарольЗадан(УчетнаяЗапись) Экспорт
	
	Возврат РаботаСПочтовымиСообщениямиСлужебный.ПарольЗадан(УчетнаяЗапись);
	
КонецФункции

// Проверка учетной записи электронной почты.
//
// см. описание процедуры РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты.
//
Процедура ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, ПарольПараметр, СообщениеОбОшибке, ДополнительноеСообщение) Экспорт
	
	РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, ПарольПараметр, СообщениеОбОшибке, ДополнительноеСообщение);
	
КонецПроцедуры

// Возвращает Истина, если текущему пользователю доступна по меньшей мере одна учетная запись для отправки.
Функция ЕстьДоступныеУчетныеЗаписиДляОтправки() Экспорт
	Возврат РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина).Количество() > 0;
КонецФункции

// Проверяет возможность добавления пользователем новых учетных записей.
Функция ДоступноПравоДобавленияУчетныхЗаписей() Экспорт 
	Возврат ПравоДоступа("Добавление", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты);
КонецФункции

#КонецОбласти
