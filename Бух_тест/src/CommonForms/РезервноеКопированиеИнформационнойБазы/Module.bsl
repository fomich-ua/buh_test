#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ПоддержкаРезервногоКопированияВМоделиСервиса = РезервноеКопированиеОбластейДанных.РезервноеКопированиеИспользуется();
	
	РезервноеКопированиеДоступно = Истина;
	Если РежимРаботы.МодельСервиса Тогда
		Если НЕ РежимРаботы.ЭтоАдминистраторПрограммы Тогда
			Элементы.ПояснениеРезервноеКопированиеНеДоступно.Заголовок = НСтр("ru='Выполнять резервное копирование может только администратор программы.';uk='Виконувати резервне копіювання може тільки адміністратор програми.'");
			РезервноеКопированиеДоступно = Ложь;
		ИначеЕсли НЕ ПоддержкаРезервногоКопированияВМоделиСервиса Тогда
			Элементы.ПояснениеРезервноеКопированиеНеДоступно.Заголовок = НСтр("ru='Сохранение резервных копий приложения не поддерживается.';uk='Збереження резервних копій програми не підтримується.'");
			РезервноеКопированиеДоступно = Ложь;
		КонецЕсли;
	Иначе
		Если НЕ РежимРаботы.ЭтоАдминистраторСистемы Тогда
			Элементы.ПояснениеРезервноеКопированиеНеДоступно.Заголовок = НСтр("ru='Выполнять резервное копирование и восстановление может только администратор информационной базы.';uk='Виконувати резервне копіювання і відновлення може тільки адміністратор інформаційної бази.'");
			РезервноеКопированиеДоступно = Ложь;
		ИначеЕсли НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			Элементы.ПояснениеРезервноеКопированиеНеДоступно.Заголовок = НСтр("ru='В клиент-серверном режиме работы резервное копирование и восстановление выполняется средствами СУБД.';uk='У клієнт-серверному режимі роботи резервне копіювання і відновлення виконується засобами СУБД.'");
			РезервноеКопированиеДоступно = Ложь;
		ИначеЕсли РежимРаботы.ЭтоВебКлиент Тогда
			Элементы.ПояснениеРезервноеКопированиеНеДоступно.Заголовок = НСтр("ru='В веб-клиенте резервное копирование и восстановление не доступно.';uk='У веб-клієнті резервне копіювання і відновлення не доступно.'");
			РезервноеКопированиеДоступно = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость = РезервноеКопированиеДоступно;
	Элементы.ГруппаРезервноеКопированиеНеДоступно.Видимость      = НЕ РезервноеКопированиеДоступно;
	
	ОбновитьНастройкиРезервногоКопирования();
	Элементы.ГруппаВосстановлениеРезервнойКопии.Видимость               = РезервноеКопированиеДоступно И (РежимРаботы.Локальный Или РежимРаботы.Автономный);
	Элементы.ГруппаВосстановлениеРезервнойКопииВМоделиСервиса.Видимость = РезервноеКопированиеДоступно И РежимРаботы.МодельСервиса;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытаФормаНастройкиРезервногоКопирования" Тогда
		ОбновитьНастройкиРезервногоКопирования();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РезервноеКопированиеПрограммыНажатие(Элемент)
	
	Если РежимРаботы.МодельСервиса Тогда
		ОткрытьФорму("ОбщаяФорма.СозданиеРезервнойКопии", , ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРезервногоКопированияНажатие(Элемент)
	
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	Если РежимРаботы.МодельСервиса Тогда
		ОткрытьФорму("Обработка.НастройкаРезервногоКопированияПриложения.Форма", , ЭтотОбъект);
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	
	ОткрытьФорму(РезервноеКопированиеИБКлиент.ИмяФормыНастроекРезервногоКопирования(),, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановлениеИзРезервнойКопииНажатие(Элемент)
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.ВосстановлениеДанныхИзРезервнойКопии", , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьНастройкиРезервногоКопирования()
	
	Если (РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы Тогда
		Элементы.ПояснениеНастройкаРезервногоКопирования.Заголовок = РезервноеКопированиеИБСервер.ТекущаяНастройкаРезервногоКопирования();
	КонецЕсли;
	
	Если РежимРаботы.МодельСервиса Тогда
		Элементы.НадписьДатаПроведенияПоследнегоРезервногоКопирования.Видимость = Ложь;
	Иначе
		НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
		Если НастройкиРезервногоКопирования.ДатаПоследнегоРезервногоКопирования = Дата(1, 1, 1) Тогда
			ТекстЗаголовка = НСтр("ru='Резервное копирование еще ни разу не проводилось';uk='Резервне копіювання ще жодного разу не проводилося'");
		Иначе
			ТекстЗаголовка = НСтр("ru='В последний раз резервное копирование проводилось: %1';uk='Востаннє резервне копіювання проводилося: %1'");//<Дата последнего резервного копирования>
			ДатаПоследнегоКопирования = Формат(НастройкиРезервногоКопирования.ДатаПоследнегоРезервногоКопирования, "ДЛФ=ДДВ");
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, ДатаПоследнегоКопирования);
		КонецЕсли;
		Элементы.НадписьДатаПроведенияПоследнегоРезервногоКопирования.Заголовок = ТекстЗаголовка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти