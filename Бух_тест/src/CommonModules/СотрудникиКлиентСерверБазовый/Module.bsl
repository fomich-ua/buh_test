////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентСерверБазовый: методы, обслуживающие работу формы сотрудника
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами

Функция ОписаниеДополнительнойФормы(ИмяОткрываемойФормы) Экспорт
	
	ОписаниеФормы = СотрудникиКлиентСервер.ОбщееОписаниеДополнительнойФормы(ИмяОткрываемойФормы);
	
	Возврат ОписаниеФормы;
	
КонецФункции

