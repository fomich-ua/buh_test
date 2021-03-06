////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов поставщиков';uk='Реєстр документів постачальників'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Соответствие;
	
	ПолеЗапросаНомер =
	" Таб.Номер ";
	
	ПолеЗапросаДатаВх =
	"	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПоступлениеТоваровУслуг)
	|				ИЛИ ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.СписаниеСРасчетногоСчета)
	|				ИЛИ ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.СчетНаОплатуПоставщика)
	|			ТОГДА Таб.ДатаВходящегоДокумента
	|		ИНАЧЕ """"
	|	КОНЕЦ";
	
	Результат.Вставить("Номер,",                 ПолеЗапросаНомер);
	Результат.Вставить("ДатаВходящегоДокумента", ПолеЗапросаДатаВх);
	Результат.Вставить("НомерВходящегоДокумента",
		СтрЗаменить(ПолеЗапросаДатаВх, "ДатаВходящегоДокумента", "НомерВходящегоДокумента"));
	Результат.Вставить("Информация",   "Контрагент");
	
	Возврат Результат;
	
КонецФункции
