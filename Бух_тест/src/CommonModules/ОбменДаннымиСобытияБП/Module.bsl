


////////////////////////////////////////////////////////////////////////////////
// Выгрузка/загрузка данных в сервисе

// Процедура-обработчик события "ПередЗагрузкойОбъекта" для механизма выгрузки/загрузки данных в сервисе
// Описание параметров см. в комментарии к ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных
// 
Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	Объект.ДополнительныеСвойства.Вставить("РегистрироватьДанныеПервичныхДокументов", Ложь);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
//Обмен Розница для Украины 2.0 - Бухгалтерия для Украины 2.0/////////////////// 
////////////////////////////////////////////////////////////////////////////////

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчик
Процедура ОбменДаннымиОбменРозница20Бухгалтерия20ЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменРозница20Бухгалтерия20", Источник, Отказ);
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
Процедура ОбменДаннымиОбменРозница20Бухгалтерия20ИзменениеДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменРозница20Бухгалтерия20", Источник, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
Процедура ОбменДаннымиОбменРозница20Бухгалтерия20ЗарегистрироватьУдалениеПередУдалением(Источник, Отказ) Экспорт
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменРозница20Бухгалтерия20", Источник, Отказ);
КонецПроцедуры

Процедура ОбменДаннымиОбменРозница20Бухгалтерия20ЗарегистрироватьИзменениеНабораЗаписейПередУдалением(Источник, Отказ, Замещение) Экспорт
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменРозница20Бухгалтерия20", Источник, Отказ, Замещение); 
КонецПроцедуры



// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия20ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеНебольшойФирмойБухгалтерия20", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия20ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменУправлениеНебольшойФирмойБухгалтерия20", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия20ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеНебольшойФирмойБухгалтерия20", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия20ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеНебольшойФирмойБухгалтерия20", Источник, Отказ);
	
КонецПроцедуры
