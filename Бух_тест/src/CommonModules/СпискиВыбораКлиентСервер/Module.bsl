
Процедура Загрузить(ИмяНастройки, СписокВыбора)Экспорт
	
	#Если Клиент Тогда
		ИсторияПоиска = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(ИмяНастройки,);
	#Иначе	
		ИсторияПоиска = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(ИмяНастройки,);
	#КонецЕсли
	
	Если ИсторияПоиска <> Неопределено Тогда
		СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	КонецЕсли;
	
КонецПроцедуры

Процедура Сохранить(ИмяНастройки, СписокВыбора) Экспорт
	
	#Если Клиент Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ИмяНастройки, , СписокВыбора.ВыгрузитьЗначения());
	#Иначе
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ИмяНастройки, , СписокВыбора.ВыгрузитьЗначения());
	#КонецЕсли

КонецПроцедуры // Сохранить()

Процедура ОбновитьСписокВыбора(СписокВыбора, СтрокаПоиска) Экспорт
	
	// Удалим элемент из истории поиска если он там был
	НомерНайденногоЭлементаСписка = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
	Пока НомерНайденногоЭлементаСписка <> Неопределено Цикл
		СписокВыбора.Удалить(НомерНайденногоЭлементаСписка);
		НомерНайденногоЭлементаСписка = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
	КонецЦикла;
	
	
	// И поставим его на первое место
	СписокВыбора.Вставить(0, СтрокаПоиска);
	Пока СписокВыбора.Количество() > 1000 Цикл
		СписокВыбора.Удалить(СписокВыбора.Количество() - 1);
	КонецЦикла;
	
КонецПроцедуры // ОбновитьСписокВыбора()

Процедура АвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	КоличествоНайденных = 0;
	Для каждого ЭлементСписка Из Элемент.СписокВыбора Цикл
		Если ЛЕВ(ВРег(ЭлементСписка.Значение),СтрДлина(СокрЛП(Текст))) = ВРег(СокрЛП(Текст)) Тогда
			ДанныеВыбора.Добавить(ЭлементСписка.Значение);
			КоличествоНайденных = КоличествоНайденных + 1;
			Если КоличествоНайденных > 7 Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // АвтоПодбор()