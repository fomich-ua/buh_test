////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью в регистр.
//
Процедура ПередЗаписью(Отказ, Замещение = Истина)

	Для каждого Запись из ЭтотОбъект Цикл
		Запись.ГраницаЗапретаИзменений = КонецДня(Запись.ГраницаЗапретаИзменений);
	КонецЦикла;
	
КонецПроцедуры // ПередЗаписью()
