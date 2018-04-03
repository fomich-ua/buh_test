
&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	Если НЕ ТолькоПросмотр Тогда
		ЗаписатьДанныеРегистра();
	КонецЕсли;
	
	Если Окно.Основное Тогда
		ПерейтиПоНавигационнойСсылке("e1cib/navigationpoint/СправочникиИНастройкиУчета");
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	ЗаписатьДанныеРегистра();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрочитатьДанныеРегистра();
	
	УстановитьЗаголовкиИДоступностьСубконто("СчетЗатрат8КлассОперационная");
	УстановитьЗаголовкиИДоступностьСубконто("СчетЗатрат8КлассНеоперационная");
	УстановитьЗаголовкиИДоступностьСубконто("СчетЗатрат9КлассОперационная");
	УстановитьЗаголовкиИДоступностьСубконто("СчетЗатрат9КлассНеоперационная");
	УстановитьЗаголовкиИДоступностьСубконто("СчетДоходовОперационная");
	УстановитьЗаголовкиИДоступностьСубконто("СчетДоходовНеоперационная");
	УстановитьЗаголовкиИДоступностьСубконто("СчетКапитала");
		
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатрат8КлассОперационнаяПриИзменении(Элемент)
	УстановитьЗаголовкиИДоступностьСубконто("СчетЗатрат8КлассОперационная");
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатрат8КлассНеоперационнаяПриИзменении(Элемент)
	УстановитьЗаголовкиИДоступностьСубконто("СчетЗатрат8КлассНеоперационная");
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатрат9КлассОперационнаяПриИзменении(Элемент)
	УстановитьЗаголовкиИДоступностьСубконто("СчетЗатрат9КлассОперационная");
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатрат9КлассНеоперационнаяПриИзменении(Элемент)
	УстановитьЗаголовкиИДоступностьСубконто("СчетЗатрат9КлассНеоперационная");
КонецПроцедуры

&НаКлиенте
Процедура СчетДоходовОперационнаяПриИзменении(Элемент)
	УстановитьЗаголовкиИДоступностьСубконто("СчетДоходовОперационная");
КонецПроцедуры

&НаКлиенте
Процедура СчетДоходовНеоперационнаяПриИзменении(Элемент)
	УстановитьЗаголовкиИДоступностьСубконто("СчетДоходовНеоперационная");
КонецПроцедуры

&НаКлиенте
Процедура СчетКапиталаПриИзменении(Элемент)
	УстановитьЗаголовкиИДоступностьСубконто("СчетКапитала");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьЗаголовкиИДоступностьСубконто(ИмяСчета)

	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"Субконто1"+ИмяСчета, "Субконто2"+ИмяСчета, "Субконто3"+ИмяСчета);
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1"+ИмяСчета, "ЗаголовокСубконто2"+ИмяСчета, "ЗаголовокСубконто3"+ИмяСчета); 
		
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(ЭтаФорма[ИмяСчета], ЭтаФорма, ПоляФормы, ЗаголовкиПолей);

КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеРегистра()
	
	Запрос = Новый Запрос;
		
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Параметры.*
	|ИЗ
	|	РегистрСведений.ПараметрыУчетаКурсовыхРазниц КАК Параметры";

	ВыборкаПараметры = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаПараметры.Следующий() Цикл
		СчетКапитала = ВыборкаПараметры.СчетКапитала;
		Субконто1СчетКапитала = ВыборкаПараметры.Субконто1Капитала;
		Субконто2СчетКапитала = ВыборкаПараметры.Субконто2Капитала;
		Субконто3СчетКапитала = ВыборкаПараметры.Субконто3Капитала;
		
		Если ВыборкаПараметры.Операционная Тогда
			СчетДоходовОперационная = ВыборкаПараметры.СчетДоходов;
			Субконто1СчетДоходовОперационная = ВыборкаПараметры.Субконто1Доходов;
			Субконто2СчетДоходовОперационная = ВыборкаПараметры.Субконто2Доходов;
			Субконто3СчетДоходовОперационная = ВыборкаПараметры.Субконто3Доходов;
			
			Если ВыборкаПараметры.КлассСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8 Тогда
				СчетЗатрат8КлассОперационная = ВыборкаПараметры.СчетЗатрат;
				Субконто1СчетЗатрат8КлассОперационная = ВыборкаПараметры.Субконто1Затрат;	
				Субконто2СчетЗатрат8КлассОперационная = ВыборкаПараметры.Субконто2Затрат;	
				Субконто3СчетЗатрат8КлассОперационная = ВыборкаПараметры.Субконто3Затрат;	
			Иначе
				СчетЗатрат9КлассОперационная = ВыборкаПараметры.СчетЗатрат;	
				Субконто1СчетЗатрат9КлассОперационная = ВыборкаПараметры.Субконто1Затрат;	
				Субконто2СчетЗатрат9КлассОперационная = ВыборкаПараметры.Субконто2Затрат;	
				Субконто3СчетЗатрат9КлассОперационная = ВыборкаПараметры.Субконто3Затрат;	
			КонецЕсли;	
		Иначе
			СчетДоходовНеоперационная = ВыборкаПараметры.СчетДоходов;
			Субконто1СчетДоходовНеоперационная = ВыборкаПараметры.Субконто1Доходов;
			Субконто2СчетДоходовНеоперационная = ВыборкаПараметры.Субконто2Доходов;
			Субконто3СчетДоходовНеоперационная = ВыборкаПараметры.Субконто3Доходов;
			
			Если ВыборкаПараметры.КлассСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8 Тогда
				СчетЗатрат8КлассНеоперационная = ВыборкаПараметры.СчетЗатрат;	
				Субконто1СчетЗатрат8КлассНеоперационная = ВыборкаПараметры.Субконто1Затрат;	
				Субконто2СчетЗатрат8КлассНеоперационная = ВыборкаПараметры.Субконто2Затрат;	
				Субконто3СчетЗатрат8КлассНеоперационная = ВыборкаПараметры.Субконто3Затрат;	
			Иначе
				СчетЗатрат9КлассНеоперационная = ВыборкаПараметры.СчетЗатрат;	
				Субконто1СчетЗатрат9КлассНеоперационная = ВыборкаПараметры.Субконто1Затрат;	
				Субконто2СчетЗатрат9КлассНеоперационная = ВыборкаПараметры.Субконто2Затрат;	
				Субконто3СчетЗатрат9КлассНеоперационная = ВыборкаПараметры.Субконто3Затрат;	
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеРегистра()
	
	МенеджерЗаписи = РегистрыСведений.ПараметрыУчетаКурсовыхРазниц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КлассСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8;
	МенеджерЗаписи.Операционная = Истина;
	МенеджерЗаписи.СчетДоходов = СчетДоходовОперационная;
	МенеджерЗаписи.Субконто1Доходов = Субконто1СчетДоходовОперационная;
	МенеджерЗаписи.Субконто2Доходов = Субконто2СчетДоходовОперационная;
	МенеджерЗаписи.Субконто3Доходов = Субконто3СчетДоходовОперационная;
	МенеджерЗаписи.СчетЗатрат  = СчетЗатрат8КлассОперационная;
	МенеджерЗаписи.Субконто1Затрат = Субконто1СчетЗатрат8КлассОперационная;
	МенеджерЗаписи.Субконто2Затрат = Субконто2СчетЗатрат8КлассОперационная;
	МенеджерЗаписи.Субконто3Затрат = Субконто3СчетЗатрат8КлассОперационная;
	МенеджерЗаписи.СчетКапитала  = СчетКапитала;
	МенеджерЗаписи.Субконто1Капитала = Субконто1СчетКапитала;
	МенеджерЗаписи.Субконто2Капитала = Субконто2СчетКапитала;
	МенеджерЗаписи.Субконто3Капитала = Субконто3СчетКапитала;
	МенеджерЗаписи.Записать(Истина);

	МенеджерЗаписи = РегистрыСведений.ПараметрыУчетаКурсовыхРазниц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КлассСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8;
	МенеджерЗаписи.Операционная = Ложь;
	МенеджерЗаписи.СчетДоходов = СчетДоходовНеоперационная;
	МенеджерЗаписи.Субконто1Доходов = Субконто1СчетДоходовНеоперационная;
	МенеджерЗаписи.Субконто2Доходов = Субконто2СчетДоходовНеоперационная;
	МенеджерЗаписи.Субконто3Доходов = Субконто3СчетДоходовНеоперационная;
	МенеджерЗаписи.СчетЗатрат  = СчетЗатрат8КлассНеоперационная;
	МенеджерЗаписи.Субконто1Затрат = Субконто1СчетЗатрат8КлассНеоперационная;
	МенеджерЗаписи.Субконто2Затрат = Субконто2СчетЗатрат8КлассНеоперационная;
	МенеджерЗаписи.Субконто3Затрат = Субконто3СчетЗатрат8КлассНеоперационная;
	МенеджерЗаписи.СчетКапитала  = СчетКапитала;
	МенеджерЗаписи.Субконто1Капитала = Субконто1СчетКапитала;
	МенеджерЗаписи.Субконто2Капитала = Субконто2СчетКапитала;
	МенеджерЗаписи.Субконто3Капитала = Субконто3СчетКапитала;
	МенеджерЗаписи.Записать(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ПараметрыУчетаКурсовыхРазниц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КлассСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс9;
	МенеджерЗаписи.Операционная = Истина;
	МенеджерЗаписи.СчетДоходов = СчетДоходовОперационная;
	МенеджерЗаписи.Субконто1Доходов = Субконто1СчетДоходовОперационная;
	МенеджерЗаписи.Субконто2Доходов = Субконто2СчетДоходовОперационная;
	МенеджерЗаписи.Субконто3Доходов = Субконто3СчетДоходовОперационная;
	МенеджерЗаписи.СчетЗатрат  = СчетЗатрат9КлассОперационная;
	МенеджерЗаписи.Субконто1Затрат = Субконто1СчетЗатрат9КлассОперационная;
	МенеджерЗаписи.Субконто2Затрат = Субконто2СчетЗатрат9КлассОперационная;
	МенеджерЗаписи.Субконто3Затрат = Субконто3СчетЗатрат9КлассОперационная;
	МенеджерЗаписи.СчетКапитала  = СчетКапитала;
	МенеджерЗаписи.Субконто1Капитала = Субконто1СчетКапитала;
	МенеджерЗаписи.Субконто2Капитала = Субконто2СчетКапитала;
	МенеджерЗаписи.Субконто3Капитала = Субконто3СчетКапитала;
	МенеджерЗаписи.Записать(Истина);

	МенеджерЗаписи = РегистрыСведений.ПараметрыУчетаКурсовыхРазниц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КлассСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс9;
	МенеджерЗаписи.Операционная = Ложь;
	МенеджерЗаписи.СчетДоходов = СчетДоходовНеоперационная;
	МенеджерЗаписи.Субконто1Доходов = Субконто1СчетДоходовНеоперационная;
	МенеджерЗаписи.Субконто2Доходов = Субконто2СчетДоходовНеоперационная;
	МенеджерЗаписи.Субконто3Доходов = Субконто3СчетДоходовНеоперационная;
	МенеджерЗаписи.СчетЗатрат  = СчетЗатрат9КлассНеоперационная;
	МенеджерЗаписи.Субконто1Затрат = Субконто1СчетЗатрат9КлассНеоперационная;
	МенеджерЗаписи.Субконто2Затрат = Субконто2СчетЗатрат9КлассНеоперационная;
	МенеджерЗаписи.Субконто3Затрат = Субконто3СчетЗатрат9КлассНеоперационная;
	МенеджерЗаписи.СчетКапитала  = СчетКапитала;
	МенеджерЗаписи.Субконто1Капитала = Субконто1СчетКапитала;
	МенеджерЗаписи.Субконто2Капитала = Субконто2СчетКапитала;
	МенеджерЗаписи.Субконто3Капитала = Субконто3СчетКапитала;
	МенеджерЗаписи.Записать(Истина);
	
	Модифицированность = Ложь;
	
КонецПроцедуры
