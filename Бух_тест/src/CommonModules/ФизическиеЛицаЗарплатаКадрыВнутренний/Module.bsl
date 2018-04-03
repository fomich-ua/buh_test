////////////////////////////////////////////////////////////////////////////////
// ФизическиеЛицаЗарплатаКадрыВнутренний: методы, дополняющие функциональность
// 		 справочника ФизическиеЛица
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьДанныеФизическогоЛица(ДанныеФизическогоЛица, ПравилаПроверки, Ошибки, Отказ, НомерСтроки) Экспорт
	
	ФизическиеЛицаЗарплатаКадрыБазовый.ПроверитьДанныеФизическогоЛица(ДанныеФизическогоЛица, ПравилаПроверки, Ошибки, Отказ, НомерСтроки);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	ФизическиеЛицаЗарплатаКадрыБазовый.ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
КонецПроцедуры

