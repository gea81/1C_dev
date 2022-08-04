
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТаблицаТипов1С.Загрузить(РегистрыСведений.тг_ДоступныеТипыОбъектов1С.ПолучитьТаблицуТиповОбъектов1С());
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если Модифицированность Тогда
		Оповещение 		= Новый ОписаниеОповещения("ВопросПриЗакрытииЗавершение", ЭтотОбъект);
		ТекстВопроса	= НСтр("ru='Записать?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВопросПриЗакрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	ЗаписатьНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	ЗаписатьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ТаблицаДляЗаписи = ТаблицаТипов1С.Выгрузить(Новый Структура("Пометка", Истина));
	
	НЗ = РегистрыСведений.тг_ДоступныеТипыОбъектов1С.СоздатьНаборЗаписей();
	Для Каждого СтрокаТЗ Из ТаблицаДляЗаписи Цикл
		СтрокаНЗ = НЗ.Добавить();
		СтрокаНЗ.ТипОбъекта1С = СтрокаТЗ.ТипОбъекта1С;
	КонецЦикла;
	НЗ.Записать();
	
	Модифицированность = Ложь;
		 
КонецПроцедуры

#КонецОбласти