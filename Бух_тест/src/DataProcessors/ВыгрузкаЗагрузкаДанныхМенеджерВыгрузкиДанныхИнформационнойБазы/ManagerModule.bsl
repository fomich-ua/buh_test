#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Выгружает данные информационной базы.
//
// Парамтеры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ВыгрузитьДанныеИнформационнойБазы(Контейнер, Обработчики) Экспорт
	
	ВыгружаемыеТипы = Контейнер.ПараметрыВыгрузки().ВыгружаемыеТипы;
	ИсключаемыеТипы = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
	
	ТипыСАннотациейСсылок = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыТребующиеАннотациюСсылокПриВыгрузке();
	
	МенеджерВыгрузки = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы.Создать();
	МенеджерВыгрузки.Инициализировать(Контейнер, Обработчики, ВыгружаемыеТипы, ИсключаемыеТипы, ТипыСАннотациейСсылок);
	
	МенеджерВыгрузки.ВыгрузитьДанные();
	
	МенеджерВыгрузки.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
