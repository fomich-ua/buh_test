#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Справочники.Организации.ДополнитьДанныеЗаполненияПриОднофирменномУчете(ДанныеЗаполнения);
	
	ЗаписьУчетнойПолитики = ЭтотОбъект[0];

	Если ДанныеЗаполнения = Неопределено
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("Структура")  Тогда
		РегистрыСведений.УчетнаяПолитикаОрганизаций.УстановкаПараметровУчетнойПолитикиПоУмолчанию(
			ЗаписьУчетнойПолитики,
			?(ДанныеЗаполнения = Неопределено, Новый Структура, ДанныеЗаполнения));
	КонецЕсли;

	РегистрыСведений.УчетнаяПолитикаОрганизаций.УстановкаПараметровУчетнойПолитикиПоУмолчаниюНаПериод(ЗаписьУчетнойПолитики);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	Для каждого Строка Из ЭтотОбъект Цикл
			
		РеквизитыСхемаНалогообложения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Строка.СхемаНалогообложения, "НалогНаПрибыль,НДС,ЕдиныйНалог");
			
		Строка.ПлательщикНалогаНаПрибыль = РеквизитыСхемаНалогообложения.НалогНаПрибыль;

		Строка.ПлательщикНДС = РеквизитыСхемаНалогообложения.НДС;

		Строка.ПлательщикЕдиногоНалога = РеквизитыСхемаНалогообложения.ЕдиныйНалог;
			
		
	КонецЦикла;
	

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры


#КонецЕсли