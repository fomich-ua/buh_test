////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции документа Депонирование зарплаты

/// Обработчики событий модуля объекта документов Депонирование зарплаты

Процедура ДепонированиеЗарплатыОбработкаПроведения(ДокументОбъект, Отказ) Экспорт
	УчетДепонированнойЗарплатыБазовый.ДепонированиеЗарплатыОбработкаПроведения(ДокументОбъект, Отказ);
КонецПроцедуры

/// Методы доступа к документу депонирования

 Функция ДепонированиеЗарплатыДанныеДляПроведения(ДокументОбъект) Экспорт
	Возврат УчетДепонированнойЗарплатыБазовый.ДепонированиеЗарплатыДанныеДляПроведения(ДокументОбъект);
КонецФункции
