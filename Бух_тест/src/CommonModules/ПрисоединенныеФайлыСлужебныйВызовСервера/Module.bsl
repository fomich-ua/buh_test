////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. эту процедуру в модуле ПрисоединенныеФайлы.
Процедура ОбновитьПрисоединенныйФайл(Знач ПрисоединенныйФайл, Знач ИнформацияОФайле) Экспорт
	
	ПрисоединенныеФайлы.ОбновитьПрисоединенныйФайл(ПрисоединенныйФайл, ИнформацияОФайле);
	
КонецПроцедуры

// См. эту процедуру в модуле ПрисоединенныеФайлы.
Процедура ЗанестиИнформациюОднойПодписи(Знач ПрисоединенныйФайл, Знач ДанныеПодписи) Экспорт
	
	ПрисоединенныеФайлы.ЗанестиИнформациюОднойПодписи(ПрисоединенныйФайл, ДанныеПодписи);
	
КонецПроцедуры

// См. эту процедуру в модуле ПрисоединенныеФайлы.
Процедура ЗанестиИнформациюОПодписях(Знач ПрисоединенныйФайл,
                                     Знач МассивПодписей) Экспорт
	
	ПрисоединенныеФайлы.ЗанестиИнформациюОПодписях(
		ПрисоединенныйФайл, МассивПодписей);
	
КонецПроцедуры

// См. эту функцию в модуле ПрисоединенныеФайлы.
Функция ДобавитьФайл(Знач ВладелецФайла,
                     Знач ИмяБезРасширения,
                     Знач РасширениеБезТочки = Неопределено,
                     Знач ВремяИзменения = Неопределено,
                     Знач ВремяИзмененияУниверсальное = Неопределено,
                     Знач АдресФайлаВоВременномХранилище,
                     Знач АдресВременногоХранилищаТекста = "",
                     Знач Описание = "") Экспорт
	
	Возврат ПрисоединенныеФайлы.ДобавитьФайл(
		ВладелецФайла,
		ИмяБезРасширения,
		РасширениеБезТочки,
		ВремяИзменения,
		ВремяИзмененияУниверсальное,
		АдресФайлаВоВременномХранилище,
		АдресВременногоХранилищаТекста,
		Описание);
	
КонецФункции

// См. эту функцию в модуле ПрисоединенныеФайлы.
Функция ПолучитьДанныеФайла(Знач ПрисоединенныйФайл,
                            Знач ИдентификаторФормы = Неопределено,
                            Знач ПолучатьСсылкуНаДвоичныеДанные = Истина) Экспорт
	
	Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(
		ПрисоединенныйФайл, ИдентификаторФормы, ПолучатьСсылкуНаДвоичныеДанные);
	
КонецФункции

// См. эту процедуру в модуле ПрисоединенныеФайлыСлужебный.
Процедура Зашифровать(Знач ПрисоединенныйФайл, Знач ЗашифрованныеДанные, Знач МассивОтпечатков) Экспорт
	
	ПрисоединенныеФайлыСлужебный.Зашифровать(
		ПрисоединенныйФайл, ЗашифрованныеДанные, МассивОтпечатков);
	
КонецПроцедуры

// См. эту процедуру в модуле ПрисоединенныеФайлыСлужебный.
Процедура Расшифровать(Знач ПрисоединенныйФайл, Знач РасшифрованныеДанные) Экспорт
	
	ПрисоединенныеФайлыСлужебный.Расшифровать(ПрисоединенныйФайл, РасшифрованныеДанные);
	
КонецПроцедуры

// Получает все подписи файла.
//
// Подробнее - см. описание ЭлектроннаяПодпись.ПолучитьВсеПодписи().
//
Функция ПолучитьВсеПодписи(СсылкаНаОбъект, УникальныйИдентификатор) Экспорт
	
	Возврат ЭлектроннаяПодпись.ПолучитьВсеПодписи(СсылкаНаОбъект, УникальныйИдентификатор);
	
КонецФункции

// См. эту процедуру в модуле ПрисоединенныеФайлы.
Процедура ПереопределитьПолучаемуюФормуПрисоединенногоФайла(Источник,
                                                      ВидФормы,
                                                      Параметры,
                                                      ВыбраннаяФорма,
                                                      ДополнительнаяИнформация,
                                                      СтандартнаяОбработка) Экспорт
	
	ПрисоединенныеФайлы.ПереопределитьПолучаемуюФормуПрисоединенногоФайла(Источник,
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти
