////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ФизическоеЛицоСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.СотрудникСсылка, "ФизическоеЛицо");
	
	ЦветСтиляПоясняющийТекст		= ЦветаСтиля.ПоясняющийТекст;
	ЦветСтиляПоясняющийОшибкуТекст 	= ЦветаСтиля.ПоясняющийОшибкуТекст;
	ЦветСтиляЦветТекстаПоля 		= ЦветаСтиля.ЦветТекстаПоля;
	
	ПрочитатьДанные();
	
	ВывестиДатуРегистрации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СотрудникиКлиент.ЗарегистрироватьОткрытиеФормы(ЭтаФорма, "ЛичныеДанные");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СотрудникиКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "ОтредактированаИстория" И ФизическоеЛицоСсылка = Источник Тогда
		Если Параметр.ИмяРегистра = "ГражданствоФизическихЛиц" Тогда
			Если ГражданствоФизическихЛицНаборЗаписейПрочитан Тогда
				РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(
					ЭтаФорма,
					ФизическоеЛицоСсылка,
					ИмяСобытия,
					Параметр,
					Источник);
					
				Если ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна) Тогда
					ГражданствоФизическихЛицЛицоБезГражданства = 0;
				Иначе
					ГражданствоФизическихЛицЛицоБезГражданства = 1;
				КонецЕсли;
				
				СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма);
				
			КонецЕсли;
		ИначеЕсли Параметр.ИмяРегистра = "ДокументыФизическихЛиц" Тогда
			Если ДокументыФизическихЛицНаборЗаписейПрочитан Тогда
				СотрудникиКлиентБазовый.ОбработкаОповещенияОтредактированаИсторияДокументыФизическихЛиц(
					ЭтаФорма,
					ФизическоеЛицоСсылка,
					ИмяСобытия,
					Параметр,
					Источник);
				СотрудникиКлиентСервер.ОбработатьОтображениеСерияДокументаФизическогоЛица(ДокументыФизическихЛиц.ВидДокумента, ДокументыФизическихЛиц.Серия ,Элементы.ДокументыФизическихЛицСерия, ЭтаФорма);
				СотрудникиКлиентСервер.ОбработатьОтображениеНомерДокументаФизическогоЛица(ДокументыФизическихЛиц.ВидДокумента, ДокументыФизическихЛиц.Номер ,Элементы.ДокументыФизическихЛицНомер, ЭтаФорма);
				СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(
		ЭтаФорма,
		"ГражданствоФизическихЛиц",
		ФизическоеЛицоСсылка,
		Отказ);
		
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(
		ЭтаФорма,
		"ДокументыФизическихЛиц",
		ФизическоеЛицоСсылка,
		Отказ);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура Подключаемый_ПояснениеНажатие(Элемент, СтандартнаяОбработка = Ложь)

	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)

	Если НЕ СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы) Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиКлиент.КонтактнаяИнформацияПриИзменении(ЭтаФорма, Элемент);

	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Если НЕ СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы) Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиКлиент.КонтактнаяИнформацияНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);

	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	Если НЕ СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеОчистка(ЭтаФорма, Элемент.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	
	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	Если НЕ СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПодключаемаяКоманда(ЭтаФорма, Команда.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуВводаАдреса(ЭтаФорма, Результат);

	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФизлицоДатаРегистрацииПриИзменении(Элемент)
	
	СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицЛицоБезГражданстваПриИзменении(Элемент)
	
	Если ГражданствоФизическихЛицЛицоБезГражданства = 0 Тогда
		
		Если НЕ ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна)
			И ЗначениеЗаполнено(ГражданствоФизическихЛицПрежняя.Страна) Тогда
		КонецЕсли;
		
		ГражданствоФизическихЛиц.Страна = ГражданствоФизическихЛицПрежняя.Страна;
		Если НЕ ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна) Тогда
			ГражданствоФизическихЛиц.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.Украина");
		КонецЕсли; 
		
	Иначе
		
		ГражданствоФизическихЛиц.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка");
		
	КонецЕсли;
	
	СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицСтранаПриИзменении(Элемент)
	
	СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицПериодПриИзменении(Элемент)
	
	ГражданствоФизическихЛиц.Период = ГражданствоФизическихЛицПериод;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// При изменении данных физлица / сотрудника

&НаКлиенте
Процедура ФизлицоМестоРожденияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ФизлицоМестоРожденияНачалоВыбораЗавершение", ЭтотОбъект);
	СотрудникиКлиент.ФизическиеЛицаМестоРожденияНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка, ФизическоеЛицо.МестоРождения, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизлицоМестоРожденияНачалоВыбораЗавершение(МестоРожденияИзменено, ДополнительныеПараметры) Экспорт 
	
	Если МестоРожденияИзменено Тогда
		СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФизлицоМестоРожденияПриИзменении(Элемент)
	
	СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Элемент)
	
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицСерияПриИзменении(Элемент)
	
	СотрудникиКлиент.ДокументыФизическихЛицСерияПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицНомерПриИзменении(Элемент)
	
	СотрудникиКлиент.ДокументыФизическихЛицНомерПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицДатаВыдачиПриИзменении(Элемент)
	
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицСрокДействияПриИзменении(Элемент)
	
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицКемВыданПриИзменении(Элемент)
	
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицКодПодразделенияПриИзменении(Элемент)
	
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицСерияИнфоТекстНажатие(Элемент, СтандартнаяОбработка)
	
	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицНомерИнфоТекстНажатие(Элемент, СтандартнаяОбработка)
	
	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ГражданствоФизическихЛицИстория(Команда)

	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ГражданствоФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВсеДокументыЭтогоЧеловека(Команда)
	
	СотрудникиКлиент.ОткрытьСписокВсехДокументовФизическогоЛица(ЭтаФорма, ФизическоеЛицоСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицИстория(Команда)
	
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ДокументыФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации()
	СотрудникиФормы.ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации(ЭтаФорма);
КонецПроцедуры

&НаСервере
Функция ОбновитьКонтактнуюИнформацию(Результат = Неопределено)
	
	Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтаФорма, ФизическоеЛицо, Результат);
	
КонецФункции

&НаСервере
Процедура ВывестиДатуРегистрации(Форма)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
	
	НайденнаяСтрока = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор)[0];
	ИмяРеквизита = НайденнаяСтрока.ИмяРеквизита;
	АдресРегистрации = Форма.Элементы[ИмяРеквизита];
	
	НоваяГруппа = Форма.Элементы.Добавить("ГруппаДатыРегистрации", Тип("ГруппаФормы"));
	НоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НоваяГруппа.ОтображатьЗаголовок = Ложь;
	НоваяГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
	НоваяГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	
	Форма.Элементы.Переместить(НоваяГруппа, АдресРегистрации.Родитель, АдресРегистрации);
	
	Форма.Элементы.Переместить(АдресРегистрации, НоваяГруппа);
	
	ПоложениеЗаголовкаКонтактнойИнформации = Форма.КонтактнаяИнформацияПоложениеЗаголовка;
	ПоложениеЗаголовкаКонтактнойИнформации = ?(ЗначениеЗаполнено(ПоложениеЗаголовкаКонтактнойИнформации),
		ПоложениеЗаголовкаЭлементаФормы[ПоложениеЗаголовкаКонтактнойИнформации], ПоложениеЗаголовкаЭлементаФормы.Верх);
	
	Элемент = Форма.Элементы.Добавить("ДатаРегистрации", Тип("ПолеФормы"), НоваяГруппа);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "ФизическоеЛицо.ДатаРегистрации";
	Элемент.РастягиватьПоГоризонтали = Ложь;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаКонтактнойИнформации;
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ФизлицоДатаРегистрацииПриИзменении");
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанные()
	
	ФизическоеЛицоОбъект = ФизическоеЛицоСсылка.ПолучитьОбъект(); 	
	
	ФизическоеЛицоВерсияДанных = ФизическоеЛицоОбъект.ВерсияДанных;
	ЗначениеВРеквизитФормы(ФизическоеЛицоОбъект, "ФизическоеЛицо");
	
	ДоступенПросмотрДанныхФизическихЛиц = Пользователи.РолиДоступны("ЧтениеДанныхФизическихЛицЗарплатаКадры,ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадры");
	
	Если ДоступенПросмотрДанныхФизическихЛиц Тогда
		РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФормеНаТекущуюДату(
			ЭтаФорма,
			"ГражданствоФизическихЛиц",
			ФизическоеЛицоСсылка);

			
		Если ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна) Тогда
			ГражданствоФизическихЛицЛицоБезГражданства = 0;
		Иначе
			ГражданствоФизическихЛицЛицоБезГражданства = 1;
		КонецЕсли;
		
		СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма);
		
		СотрудникиФормыБазовый.ПрочитатьЗаписьОДокументеУдостоверяющемЛичностьДляРедактированияВФорме(ЭтаФорма, ФизическоеЛицоСсылка);
		
	КонецЕсли;
	
	Если НЕ ФормаИнициализированнаДляКонтактнойИнформации Тогда
		
		// Обработчик подсистемы "Контактная информация"
		УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, ФизическоеЛицо, "ГруппаКонтактнаяИнформация");
		
		ФормаИнициализированнаДляКонтактнойИнформации = Истина;
		
	КонецЕсли; 
	
    // СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ФизическоеЛицо);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	СотрудникиФормыБазовый.ДоработатьКонтактнуюИнформацию(ЭтаФорма);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаКонтактнаяИнформация",
		"ТолькоПросмотр",
		НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ФизическиеЛица));
		
	СотрудникиФормы.ОбновитьОтображениеЛичныхДанных(ЭтаФорма);
	
	СотрудникиФормы.ОбновитьОтображениеПредупреждающихНадписей(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Отказ, ОповещениеЗавершения = Неопределено) Экспорт
	
	ЗаполнитьЗначенияСвойств(ВладелецФормы.ФизическоеЛицо, ФизическоеЛицо, "МестоРождения, ДатаРегистрации");
	
	СтруктураКонтактнойИнформации = Новый Структура;
	СтруктураКонтактнойИнформации.Вставить("КонтактнаяИнформацияОписаниеДополнительныхРеквизитов", ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов);
	Для каждого СтрокаКонтактнойИнформации Из ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов Цикл
		СтруктураКонтактнойИнформации.Вставить(СтрокаКонтактнойИнформации.ИмяРеквизита, ЭтаФорма[СтрокаКонтактнойИнформации.ИмяРеквизита]);
	КонецЦикла;
	
	ВладелецФормы.КонтактнаяИнформацияФизическогоЛица = Новый ФиксированнаяСтруктура(СтруктураКонтактнойИнформации);
	
	СтруктураГражданства = Новый Структура;
	Для каждого ЭлементСтруктуры Из ГражданствоФизическихЛицПрежняя Цикл
		СтруктураГражданства.Вставить(ЭлементСтруктуры.Ключ, ГражданствоФизическихЛиц[ЭлементСтруктуры.Ключ]);
	КонецЦикла;
	ВладелецФормы.ГражданствоФизическихЛиц = Новый ФиксированнаяСтруктура(СтруктураГражданства);
	
	СтруктураДокумента = Новый Структура;
	Для каждого ЭлементСтруктуры Из ДокументыФизическихЛицПрежняя Цикл
		СтруктураДокумента.Вставить(ЭлементСтруктуры.Ключ, ДокументыФизическихЛиц[ЭлементСтруктуры.Ключ]);
	КонецЦикла;
	ВладелецФормы.ДокументыФизическихЛиц = Новый ФиксированнаяСтруктура(СтруктураДокумента);
	
	Если ВладелецФормы.ФизическоеЛицоЗаблокировано Тогда
		ВладелецФормы.Модифицированность = Истина;
	КонецЕсли; 
	
	СотрудникиКлиент.ЗапроситьРежимИзмененияГражданства(ЭтаФорма, ГражданствоФизическихЛиц.Период, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиКлиент.ЗапроситьРежимИзмененияУдостоверенияЛичности(ЭтаФорма, ДокументыФизическихЛиц.Период, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьДанныеНаСервере(Отказ);

КонецПроцедуры
	
&НаСервере
Процедура СохранитьДанныеНаСервере(Отказ)
	
	Если ПроверитьЗаполнение() Тогда
		
		РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(
			ЭтаФорма,
			"ГражданствоФизическихЛиц",
			ФизическоеЛицоСсылка);
		СотрудникиФормыБазовый.ЗаписатьЗаписьДокументыФизическихЛицПослеРедактированияВФорме(ЭтаФорма, ФизическоеЛицоСсылка);
		
		Модифицированность = Ложь;
		
	Иначе
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиенте(ЗакрытьФорму = Истина) Экспорт  

	СохранитьДанные(Ложь);
	
	Если Открыта() Тогда
		
		Модифицированность = Ложь;
		Если ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли; 
		
	КонецЕсли; 

	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры



