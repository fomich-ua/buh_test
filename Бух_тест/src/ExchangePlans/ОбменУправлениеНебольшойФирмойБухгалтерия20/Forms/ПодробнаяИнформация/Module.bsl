
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Макет = ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.ПолучитьМакет("ПодробнаяИнформация");
	
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = НСтр("ru='Информация о синхронизации данных с Управление небольшой фирмой, редакция 1.6';uk='Інформація про синхронізацію даних з Управління невеликою фірмою, редакція 1.6'");
	
КонецПроцедуры
