////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет наборы свойств объекта. Обычно требуется, если наборов более одного.
//
// Параметры:
//  Объект       - Ссылка на владельца свойств.
//                 Объект владельца свойств.
//                 ДанныеФормыСтруктура (по типу объекта владельца свойств).
//
//  ТипСсылки    - Тип - тип ссылки владельца свойств.
//
//  НаборыСвойств - ТаблицаЗначений с колонками:
//                    Набор - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//
//                    // Далее свойства элемента формы типа ГруппаФормы вида обычная группа
//                    // или страница, которая создается, если наборов больше одного без учета
//                    // пустого набора, который описывает свойства группы удаленных реквизитов.
//                    
//                    // Если значение Неопределено, значит использовать значение по умолчанию.
//                    
//                    // Для любой группы управляемой формы.
//                    Высота                   - Число.
//                    Заголовок                - Строка.
//                    Подсказка                - Строка.
//                    РастягиватьПоВертикали   - Булево.
//                    РастягиватьПоГоризонтали - Булево.
//                    ТолькоПросмотр           - Булево.
//                    ЦветТекстаЗаголовка      - Цвет.
//                    Ширина                   - Число.
//                    ШрифтЗаголовка           - Шрифт.
//                    
//                    // Для обычной группы и страницы.
//                    Группировка              - ГруппировкаПодчиненныхЭлементовФормы.
//                    
//                    // Для обычной группы.
//                    Отображение                - ОтображениеОбычнойГруппы.
//                    ШиринаПодчиненныхЭлементов - ШиринаПодчиненныхЭлементовФормы.
//                    
//                    // Для страницы.
//                    Картинка                 - Картинка.
//                    ОтображатьЗаголовок      - Булево.
//
//  СтандартнаяОбработка - Булево - начальное значение Истина. Указывает получать ли
//                         основной набор, когда НаборыСвойств.Количество() равно нулю.
//
//  КлючНазначения   - Неопределено - (начальное значение) - указывает вычислить ключ
//                      назначения автоматически и добавить к значению свойства формы
//                      КлючНазначенияИспользования, чтобы изменения формы сохранялись
//                      отдельно для разного состава наборов.
//                      Например, для каждого вида номенклатуры - свой состав наборов.
//
//                    - Строка - (не более 32 символа) - использовать указанный ключ назначения
//                      для добавления к значению свойства формы КлючНазначенияИспользования.
//                      Пустая строка - не изменять КлючНазначенияИспользования, т.к.
//                      он устанавливается в форме и уже учитывает различия состава наборов.
//
//                    Добавка имеет формат "КлючНаборовСвойств<КлючНазначения>", чтобы
//                    <КлючНазначения> можно было обновлять без повторной добавки.
//                    При автоматическом вычислении <КлючНазначения> содержит хэш
//                    идентификаторов ссылок упорядоченных наборов свойств.
//
Процедура ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка, КлючНазначения) Экспорт
	
	
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции БСП.
// 
// Теперь вместо указания имени реквизита, содержащего вид владельца свойств,
// например, ВидНоменклатуры типа СправочникСсылка.ВидыНоменклатуры,
// у которого должен быть реквизит НаборСвойств типа
// СправочникСсылка.НаборыДополнительныхРеквизитовИСведений
// следует заполнить набор свойств для объекта СправочникСсылка.Номенклатура
// в процедуре ЗаполнитьНаборыСвойствОбъекта, как и в случае нескольких
// наборов свойств. Отличие лишь в том, что набор будет получен из реквизита
// объекта вида владельца самостоятельно, что позволяет использовать несколько
// разных реквизитов с удобными именами для разных типов объектов у которых
// один вид объектов. Например, Справочник.Проекты это вид владельца свойств
// у Справочник.Ошибки и Справочник.Задачи, для которых в справочнике Проекты
// будут реквизиты НаборСвойствОшибок, НаборСвойствЗадач.
//
Функция ПолучитьИмяРеквизитаВидаОбъекта(Ссылка) Экспорт
	
	Возврат "";
	
КонецФункции



#КонецОбласти
