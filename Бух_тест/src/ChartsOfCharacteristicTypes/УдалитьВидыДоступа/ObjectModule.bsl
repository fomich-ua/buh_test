#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


// Обработчик события ПередЗаписью предотвращает изменение видов доступа,
// которые должны изменятся только в режиме конфигурирования.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение
		НСтр("ru='Изменение видов доступа"
"выполняется только через конфигуратор."
""
"Удаление допустимо.';uk='Зміна видів доступу"
"виконується тільки через конфігуратор."
""
"Вилучення припустиме.'");
	
КонецПроцедуры

#КонецЕсли