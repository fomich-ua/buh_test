// Функция возвращает массив всех значений перечисления
//
// Возвращаемое значение
//		Массив элементов типа ПеречислениеСсылка.ВидыМестВыплатыЗарплаты
//
Функция ВсеЗначения() Экспорт
	
	ВсеЗначения = Новый Массив;
	
	Для н = 0 По Количество()-1 Цикл
		ВсеЗначения.Добавить(Получить(н));
	КонецЦикла;	
	
	Возврат ВсеЗначения
	
КонецФункции	