
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РеквизитыОбъекта = Справочники.тг_Объект.ПолучитьРеквизиты(Объект.Ссылка);
	
	ЭтоЧат 			= (Объект.Тип = Перечисления.тг_ТипыОбъектов.Группа
						ИЛИ Объект.Тип = Перечисления.тг_ТипыОбъектов.ГруппаКанала
						ИЛИ Объект.Тип = Перечисления.тг_ТипыОбъектов.Канал);
	ЭтоБот 			= Объект.Тип = Перечисления.тг_ТипыОбъектов.Бот;
	ЭтоПользователь = Объект.Тип = Перечисления.тг_ТипыОбъектов.Пользователь;
	ЭтоСообщение 	= Объект.Тип = Перечисления.тг_ТипыОбъектов.Сообщение;
	
	Элементы.ГруппаБот.Видимость 			= ЭтоБот;
	Элементы.ГруппаЧат.Видимость 			= ЭтоЧат;
	Элементы.ГруппаПользователь.Видимость	= ЭтоПользователь;
	Элементы.ГруппаСообщение.Видимость		= ЭтоСообщение;
	
	Элементы.Наименование.ТолькоПросмотр 	= НЕ ЭтоЧат;
			
	Если ЭтоБот Тогда
		РеквизитыОбъекта.Свойство("Токен"	, Токен);
		Если НЕ ПустаяСтрока(Токен) Тогда
			Вебхук = СтрЗаменить(тг_Сервер.ПолучитьВебхук(Токен),"/" + Объект.Код,"");
		КонецЕсли;
	ИначеЕсли ЭтоСообщение Тогда
		РеквизитыОбъекта.Свойство("Бот"		, Бот);
		РеквизитыОбъекта.Свойство("Чат"		, Объект.Чат);
		РеквизитыОбъекта.Свойство("Текст"	, Текст);					
	ИначеЕсли ЭтоЧат Тогда
		РеквизитыОбъекта.Свойство("Описание", Описание);					
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ДополнительныеРеквизиты = Новый Структура;
	
	Если ЭтоЧат Тогда
		
		ДанныеЧата = тг_Сервер.ПолучитьДанныеЧата(ТекущийОбъект.Ссылка);
		
		Если ДанныеЧата <> Неопределено Тогда
			
			Если ДанныеЧата["title"] <> ТекущийОбъект.Наименование Тогда
				тг_Сервер.УстановитьЗаголовокЧата(ТекущийОбъект.Ссылка, ТекущийОбъект.Наименование);
			КонецЕсли;
			
			Если ДанныеЧата["description"] <> Описание Тогда
				тг_Сервер.УстановитьОписаниеЧата(ТекущийОбъект.Ссылка, Описание);
			КонецЕсли;
			
		КонецЕсли;
		
		ДополнительныеРеквизиты.Вставить("Описание", Описание);
		
	КонецЕсли;
	
	Для Каждого ДополнительныйРеквизит Из ДополнительныеРеквизиты Цикл

		СтрокаТЧ = ТекущийОбъект.ДополнительныеРеквизиты.Найти(ДополнительныйРеквизит.Ключ,"Имя");

		Если СтрокаТЧ = Неопределено Тогда
			СтрокаТЧ = ТекущийОбъект.ДополнительныеРеквизиты.Добавить();
			СтрокаТЧ.Имя = ДополнительныйРеквизит.Ключ;
		КонецЕсли;
			
		Если ТипЗнч(ДополнительныйРеквизит.Значение) = Тип("Строка") Тогда
			СтрокаТЧ.Строка = ДополнительныйРеквизит.Значение;
		Иначе
			СтрокаТЧ.Значение = ДополнительныйРеквизит.Значение;
		КонецЕсли;	
	
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТокенПриИзменении(Элемент)
	ТокенПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВебхукПриИзменении(Элемент)
	ВебхукПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТокенПриИзмененииНаСервере()

	ДанныеБота = тг_Сервер.ПолучитьДанныеБота(Токен);
	РеквизитыОбъекта = Справочники.тг_Объект.ЗаполнитьРеквизиты(ДанныеБота);
	
	Если Не РеквизитыОбъекта.Свойство("Код",Объект.Код) Тогда
		Токен = "";
		Возврат;
	КонецЕсли;
	
	РеквизитыОбъекта.Свойство("Наименование", Объект.Наименование);
	
	Реквизиты = Объект.ДополнительныеРеквизиты;
	
	СтрокиТЧ = Реквизиты.НайтиСтроки(Новый Структура("Имя","Токен"));
	Если СтрокиТЧ.Количество() = 1 Тогда
		РеквизитТокен = СтрокиТЧ[0];
	Иначе
		РеквизитТокен = Реквизиты.Добавить();
		РеквизитТокен.Имя = "Токен";
	КонецЕсли;
	
	РеквизитТокен.Строка = Токен;
	
	Вебхук = тг_Сервер.ПолучитьВебхук(Токен);
			
КонецПроцедуры

&НаСервере
Процедура ВебхукПриИзмененииНаСервере()
	тг_Сервер.СохранитьВебхук(Токен, Вебхук + "/" + Объект.Код);
КонецПроцедуры

#КонецОбласти
