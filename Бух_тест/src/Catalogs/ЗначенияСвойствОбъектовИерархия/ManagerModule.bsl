#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	РедактируемыеРеквизиты.Добавить("Родитель");
	РедактируемыеРеквизиты.Добавить("ПометкаУдаления");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли
