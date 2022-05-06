
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РеквизитыОбъекта = Справочники.тг_Объект.ПолучитьРеквизиты(Объект.Ссылка);
				
	РеквизитыОбъекта.Свойство("Бот"		, Бот);
	РеквизитыОбъекта.Свойство("Текст"	, Текст);					
	РеквизитыОбъекта.Свойство("Автор"	, Автор);					
	
	Элементы.Родитель.Видимость = ЗначениеЗаполнено(Объект.Родитель);
	Элементы.Текст.Видимость	= ЗначениеЗаполнено(Текст);
	Элементы.Автор.Видимость	= ЗначениеЗаполнено(Автор);
	
	Если ЗначениеЗаполнено(Объект.Объект1С) Тогда
		Элементы.Объект1С.Видимость = Истина;
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока("Объект 1С: "));
		
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(Объект.Объект1С);
		
		МассивСсылок = ПолучитьПредставленияНавигационныхСсылок(МассивСсылок);
		Если МассивСсылок.Количество() Тогда
			ТекстСсылки = МассивСсылок[0].Текст;
		Иначе
			ТекстСсылки = "Ссылка";
		КонецЕсли;                 
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ТекстСсылки,,ЦветаСтиля.ЦветГиперссылки,,Объект.Объект1С));
	
		Элементы.Объект1С.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти