
Функция ОпределитьНалоговыйПериод(ПериодРегистрации, ПериодДействия, ДоходНДФЛ, КатегорияНачисления) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДоходНДФЛ) Тогда
		Возврат Дата(1,1,1);
	КонецЕсли;
	
	//Отпуска учитываются по периоду действия, если он за текущий или будущий период
	Если КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска Тогда
		Возврат МАКС(ПериодРегистрации, ПериодДействия);
	КонецЕсли;
	
	Если КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛиста
		ИЛИ КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя
		ИЛИ КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоНесчастныйСлучайНаПроизводстве Тогда
		//Больничные учитываются по периоду действия, если он за текущий или прошедший период
		Возврат МИН(ПериодРегистрации, ПериодДействия);
	КонецЕсли;
	
	Если КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускПоБеременностиИРодам Тогда
		//Декретные учитываются по периоду действия, если он за текущий или будущий период
		Возврат МАКС(ПериодРегистрации, ПериодДействия);
	КонецЕсли;
	
	//Все прочие учитываются по периоду регистрации
	Возврат ПериодРегистрации;
	
КонецФункции
