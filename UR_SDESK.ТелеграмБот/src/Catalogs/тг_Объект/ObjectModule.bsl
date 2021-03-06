

Процедура ПередЗаписью(Отказ)
	
	РеквизитыРодителя 	= Справочники.тг_Объект.ПолучитьРеквизиты(Родитель);
	РеквизитыОбъекта 	= Справочники.тг_Объект.ПолучитьРеквизиты(ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект1С)
		И Тип = Перечисления.тг_ТипыОбъектов.Сообщение
		И Тип = РеквизитыРодителя.Тип Тогда
		
		Если Чат <> РеквизитыРодителя.Чат Тогда 
			Объект1С = РеквизитыРодителя.Объект1С;
			ЭтотОбъект.ДополнительныеСвойства.Вставить("СинхронизироватьСообщения");
		КонецЕсли;
		
	КонецЕсли;
	
	сч = 0;
	Пока ДополнительныеРеквизиты.Количество() > сч Цикл
		СтрокаТЧ = ДополнительныеРеквизиты.Получить(сч);
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Строка)
			И НЕ ЗначениеЗаполнено(СтрокаТЧ.Значение) Тогда
			ДополнительныеРеквизиты.Удалить(сч);
		Иначе
			сч = сч + 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Тип = ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Сообщение") 
		И ПометкаУдаления Тогда
		тг_Сервер.УдалитьСообщение(Ссылка);
	КонецЕсли;

КонецПроцедуры