#Если Сервер ИЛИ ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получить объект по данным телеграм.
// 
// Параметры:
//  ДанныеТелеграм - Соответствие - Данные телеграм
//	Объект1С - НавигационнаяСсылка - Объект 1С
//	 
// Возвращаемое значение:
//  СправочникСсылка.тг_Объект - Получить объект по данным телеграм
Функция ПолучитьОбъектПоДаннымТелеграм(ДанныеТелеграм, ДополнительныеПараметры = Неопределено) Экспорт

	Результат = Справочники.тг_Объект.ПустаяСсылка();

 	РеквизитыОбъекта = ЗаполнитьРеквизиты(ДанныеТелеграм);
 	
 	Если НЕ РеквизитыОбъекта.Свойство("Код") Тогда
		Возврат РеквизитыОбъекта;
	КонецЕсли;            
	
	Если ТипЗнч(ДополнительныеПараметры)<>Тип("Структура") Тогда
		ДополнительныеПараметры = Новый Структура;	
	КонецЕсли;
	
	Результат = ПолучитьОбъектПоОтбору(РеквизитыОбъекта,Новый Структура("Исключения", "Наименование"));
		
	Если Результат.Пустая() Тогда
		Объект = Справочники.тг_Объект.СоздатьЭлемент();
	Иначе
		Объект = Результат.ПолучитьОбъект();
	КонецЕсли;
			
	ЗначенияРевизитов = ПолучитьРеквизиты(Объект.Ссылка);	
	ОсновныеРеквизиты = ОсновныеРеквизиты();
	Для каждого КЗ Из ДополнительныеПараметры Цикл
		РеквизитыОбъекта.Вставить(КЗ.Ключ,КЗ.Значение);	
	КонецЦикла;
	
	Для каждого РеквизитОбъекта Из РеквизитыОбъекта Цикл
		
		Если ЗначенияРевизитов.Свойство(РеквизитОбъекта.Ключ)
			И ЗначенияРевизитов[РеквизитОбъекта.Ключ] = РеквизитОбъекта.Значение Тогда
			Продолжить;
		КонецЕсли;
		
		Если ОсновныеРеквизиты.Найти(РеквизитОбъекта.Ключ) = Неопределено Тогда
			
			СтрокаТЧ = Объект.ДополнительныеРеквизиты.Найти(РеквизитОбъекта.Ключ,"Имя");
			Если СтрокаТЧ = Неопределено Тогда
				СтрокаТЧ = Объект.ДополнительныеРеквизиты.Добавить();
				СтрокаТЧ.Имя = РеквизитОбъекта.Ключ;
			КонецЕсли;
			
			Если ТипЗнч(РеквизитОбъекта.Значение) = Тип("Строка") Тогда
				СтрокаТЧ.Строка = РеквизитОбъекта.Значение;
			Иначе
				СтрокаТЧ.Значение = РеквизитОбъекта.Значение;
			КонецЕсли;
			
		Иначе		
			Объект[РеквизитОбъекта.Ключ] = РеквизитОбъекта.Значение;
		КонецЕсли;
		
 	КонецЦикла;
	
	Если ДополнительныеПараметры.Свойство("Вебхук") 
		И РеквизитыОбъекта.Свойство("Родитель") Тогда

		ИдФайла = Неопределено;
		Если ДанныеТелеграм["photo"] <> Неопределено Тогда
			ПоследнийРазмерФайла = 0;
			Для каждого photo Из ДанныеТелеграм["photo"] Цикл
				РазмерФайла = photo["file_size"];
				Если РазмерФайла > ПоследнийРазмерФайла Тогда
					ПоследнийРазмерФайла = РазмерФайла;
					ИдФайла = photo["file_id"];	
				КонецЕсли; 
			КонецЦикла; 
		ИначеЕсли  ДанныеТелеграм["document"] <> Неопределено Тогда
			ИдФайла = ДанныеТелеграм["document"]["file_id"];
		КонецЕсли;      
		
		Если ИдФайла <> Неопределено Тогда

			РеквизитыОбъекта.Вставить("Вложения", Новый Массив);
			
			ДанныеФайла = тг_Сервер.ПолучитьФайл(ДополнительныеПараметры.Бот, ИдФайла);
			Если ДанныеФайла <> Неопределено Тогда
				РеквизитыОбъекта.Вложения.Добавить(ДанныеФайла);
			КонецЕсли;
			
		КонецЕсли;
		
		Если РеквизитыОбъекта.Чат = РеквизитыОбъекта.Родитель.Чат Тогда
			
			тг_Сервер.ОтправитьСообщениеСВ(РеквизитыОбъекта);	
	    	РеквизитыОбъекта.Свойство("Объект1С", Объект.Объект1С);
		    Объект.ДополнительныеСвойства.Вставить("ОтправитьСвязанноеСообщение", Объект.Объект1С);
			
		КонецЕсли;
		
	КонецЕсли; 
	
	Если Объект.Модифицированность() Тогда
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Записать();
	КонецЕсли;
	
	Если Объект.ДополнительныеСвойства.Свойство("СинхронизироватьСообщения") Тогда
		ДополнительныеПараметры.Вставить("СинхронизироватьСообщения", Объект.Объект1С); 
	КонецЕсли;	                          
	
	Если Объект.ДополнительныеСвойства.Свойство("ОтправитьСвязанноеСообщение") Тогда

		тг_Сервер.ПослеОтправкиСообщенияСВ(
			Новый ИдентификаторСообщенияСистемыВзаимодействия(
			СтрЗаменить(Объект.Объект1С,"e1ccs/data/msg?id=","")));

	КонецЕсли;	                          
    
	Возврат Объект.Ссылка;
	
КонецФункции

// Получить объект по отбору.
// 
// Параметры:
//  Отбор - Структура - Отбор:
// * Родитель - СправочникСсылка.тг_Объект, Произвольный -
// * Тип - ПеречислениеСсылка.тг_ТипыОбъектов -
// 
// Возвращаемое значение:
//  СправочникСсылка.тг_Объект, Произвольный - Получить объект по отбору
Функция ПолучитьОбъектПоОтбору(Знач Отбор, Параметры = Неопределено) Экспорт
	
	Если ТипЗнч(Отбор)<>Тип("Структура") Тогда
		Отбор = Новый Структура;	
	КонецЕсли;

	Если ТипЗнч(Параметры)<>Тип("Структура") Тогда
		Параметры = Новый Структура;	
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("Исключения") Тогда
		Параметры.Вставить("Исключения", "");	
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);

	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст = "ВЫБРАТЬ
	                           |	Об.*
	                           |ИЗ
	                           |	Справочник.тг_Объект КАК Об
	                           |ГДЕ
	                           |	НЕ Об.ПометкаУдаления";

    ПостроительЗапроса.ЗаполнитьНастройки();
	ОсновныеРеквизиты = ОсновныеРеквизиты();
	Для каждого КЗ Из Отбор Цикл
		
		Если (НЕ ПустаяСтрока(Параметры.Исключения) 
			И СтрНайти(Параметры.Исключения,кз.Ключ) > 0) 
			ИЛИ НЕ ЗначениеЗаполнено(КЗ.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		Значение = КЗ.Значение;
		
		Если КЗ.Ключ = "Код"
			И ТипЗнч(Значение) = Тип("Число") Тогда
			Значение = Формат(Значение,"ЧГ=");	
		КонецЕсли;
		
		Если ОсновныеРеквизиты.Найти(КЗ.Ключ) <> Неопределено Тогда
			
			ЭлементОтбора = ПостроительЗапроса.Отбор.Добавить(КЗ.Ключ);
			ЭлементОтбора.Использование = Истина;
			ЭлементОтбора.Значение 		= Значение;
		
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПостроительЗапроса.Отбор.Количество() Тогда

		ПостроительЗапроса.Выполнить();
		Выборка = ПостроительЗапроса.Результат.Выбрать();

		Если Параметры.Свойство("ПолучатьСписок") Тогда
			
			Результат = Новый Массив;
			Пока Выборка.Следующий() Цикл
				Результат.Добавить(Выборка.Ссылка);	
			КонецЦикла;
			
			Возврат Результат;
			
		Иначе	

			Если Выборка.Следующий() Тогда
				Возврат Выборка.Ссылка;	
			Иначе
				Возврат Справочники.тг_Объект.ПустаяСсылка();
			КонецЕсли;
	
		КонецЕсли;
		
	КонецЕсли;
		
КонецФункции

// Заполнить реквизиты.
// 
// Параметры:
//  ДанныеТелеграм - Соответствие - Данные телеграм
// 
// Возвращаемое значение:
//  Структура - реквизиты 
Функция ЗаполнитьРеквизиты(ДанныеТелеграм) Экспорт	

	Если ТипЗнч(ДанныеТелеграм) <> Тип("Соответствие") Тогда
		ДанныеТелеграм = Новый Соответствие;	
	КонецЕсли;			

	РеквизитыОбъекта = Новый Структура;

	// Установка типа
	РеквизитыОбъекта.Вставить("Тип");
	
	Тип 		 = ДанныеТелеграм["type"];
	ЭтоБот 		 = ДанныеТелеграм["is_bot"] = Истина;
	ЭтоСообщение = ДанныеТелеграм["message_id"] <> Неопределено;
	
	Если Тип <> Неопределено Тогда
		РеквизитыОбъекта.Тип = тг_СерверПовтИсп.ТипыЧатов().Получить(Тип);	
	ИначеЕсли ЭтоСообщение Тогда
		РеквизитыОбъекта.Тип = Перечисления.тг_ТипыОбъектов.Сообщение;
	ИначеЕсли ЭтоБот Тогда
		РеквизитыОбъекта.Тип = Перечисления.тг_ТипыОбъектов.Бот;
	Иначе
		РеквизитыОбъекта.Тип = Перечисления.тг_ТипыОбъектов.Пользователь;
	КонецЕсли;

	СоответствияРеквизитов = Новый Соответствие;
	Если РеквизитыОбъекта.Тип = Перечисления.тг_ТипыОбъектов.Сообщение Тогда
		СоответствияРеквизитов.Вставить("message_id"		, "Код");
		СоответствияРеквизитов.Вставить("chat"				, "Чат");
		СоответствияРеквизитов.Вставить("reply_to_message"	, "Родитель");
		СоответствияРеквизитов.Вставить("from"				, "Автор");
	ИначеЕсли РеквизитыОбъекта.Тип = Перечисления.тг_ТипыОбъектов.Пользователь
		ИЛИ РеквизитыОбъекта.Тип = Перечисления.тг_ТипыОбъектов.Бот Тогда
        СоответствияРеквизитов.Вставить("id"				, "Код");
		СоответствияРеквизитов.Вставить("username"			, "ИмяПользователя");
		СоответствияРеквизитов.Вставить("first_name"		, "Имя");
		СоответствияРеквизитов.Вставить("last_name"			, "Фамилия");
	Иначе
		СоответствияРеквизитов.Вставить("id"				, "Код");
	КонецЕсли;

	Для каждого Реквизит Из СоответствияРеквизитов Цикл
		
		Значение = ДанныеТелеграм[Реквизит.Ключ];
		Если Значение = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		Если Реквизит.Значение <> "Код" 
			И ТипЗнч(Значение) = Тип("Соответствие") Тогда
			Значение = ПолучитьОбъектПоДаннымТелеграм(Значение);	
		ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда	
			Значение = Формат(Значение,"ЧГ=");	
		КонецЕсли;
				
		РеквизитыОбъекта.Вставить(Реквизит.Значение,Значение);
		
	КонецЦикла;

	Если ДанныеТелеграм["forward_from_chat"] <> Неопределено 
		И ДанныеТелеграм["forward_from_message_id"] <> Неопределено Тогда
		
		ОтборРодителя = Новый Структура;
		ОтборРодителя.Вставить("Чат", ПолучитьОбъектПоДаннымТелеграм(ДанныеТелеграм["forward_from_chat"]));
		ОтборРодителя.Вставить("Код", ДанныеТелеграм["forward_from_message_id"]);
		ОтборРодителя.Вставить("Тип", Перечисления.тг_ТипыОбъектов.Сообщение);
		
		РеквизитыОбъекта.Вставить("Родитель",ПолучитьОбъектПоОтбору(ОтборРодителя)); 
		
	КонецЕсли;	
	
	// Установка наименования
	Если ДанныеТелеграм["title"] <> Неопределено Тогда
		РеквизитыОбъекта.Вставить("Наименование",ДанныеТелеграм["title"]);
	ИначеЕсли РеквизитыОбъекта.Свойство("Фамилия") Тогда
		РеквизитыОбъекта.Вставить("Наименование",РеквизитыОбъекта.Фамилия 
			+ ?(РеквизитыОбъекта.Свойство("Имя")," " + РеквизитыОбъекта.Имя,"")
			+ ?(РеквизитыОбъекта.Свойство("ИмяПользователя")," (" + РеквизитыОбъекта.ИмяПользователя + ")",""));
	ИначеЕсли РеквизитыОбъекта.Свойство("ИмяПользователя") Тогда
		РеквизитыОбъекта.Вставить("Наименование",РеквизитыОбъекта.ИмяПользователя); 
	ИначеЕсли ДанныеТелеграм["text"] <> Неопределено 
		И РеквизитыОбъекта.Свойство("Код") Тогда
		РеквизитыОбъекта.Вставить("Наименование","Сообщение №" + РеквизитыОбъекта.Код);
	ИначеЕсли ДанныеТелеграм["photo"] <> Неопределено
		И РеквизитыОбъекта.Свойство("Код") Тогда
		РеквизитыОбъекта.Вставить("Наименование","Изображение №" + РеквизитыОбъекта.Код);
	ИначеЕсли ДанныеТелеграм["document"] <> Неопределено
		И РеквизитыОбъекта.Свойство("Код") Тогда
		РеквизитыОбъекта.Вставить("Наименование","Изображение №" + РеквизитыОбъекта.Код);
	КонецЕсли;

	Если ДанныеТелеграм["text"] <> Неопределено Тогда
		РеквизитыОбъекта.Вставить("Текст",ДанныеТелеграм["text"]);
	КонецЕсли;
		
	Возврат РеквизитыОбъекта;	

КонецФункции

Функция ПолучитьРеквизиты(Объект) Экспорт
	
	Реквизиты = Новый Структура;
	
	ОсновныеРеквизиты = ОсновныеРеквизиты();
	Для Каждого Реквизит Из ОсновныеРеквизиты Цикл
		Реквизиты.Вставить(Реквизит, Объект[Реквизит]);	
	КонецЦикла;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.тг_Объект"));
	МассивТипов.Добавить(Тип("СправочникОбъект.тг_Объект"));
	
	Если МассивТипов.Найти(ТипЗнч(Объект)) = Неопределено Тогда
		Возврат Реквизиты;
	КонецЕсли;
		
	ТЧРеквизиты = Объект.ДополнительныеРеквизиты.Выгрузить();
	РеквизитыПоиска = Новый Структура;
	
	Если Объект.Тип = Перечисления.тг_ТипыОбъектов.Бот Тогда
		РеквизитыПоиска.Вставить("Токен"	, "Строка");				
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Сообщение") Тогда 
		РеквизитыПоиска.Вставить("Текст"	, "Строка");
		РеквизитыПоиска.Вставить("Бот"		, "Значение");
		РеквизитыПоиска.Вставить("Автор"	, "Значение");
	ИначеЕсли Объект.Тип = Перечисления.тг_ТипыОбъектов.Группа
		ИЛИ Объект.Тип = Перечисления.тг_ТипыОбъектов.ГруппаКанала
		ИЛИ Объект.Тип = Перечисления.тг_ТипыОбъектов.Канал Тогда 
		РеквизитыПоиска.Вставить("Описание"	,"Строка");
	КонецЕсли;                                
	
	Для Каждого ЭлементПоиска Из РеквизитыПоиска Цикл
		
		Значение = Неопределено;
		СтрокаТЧ = ТЧРеквизиты.Найти(ЭлементПоиска.Ключ,"Имя");
		Если СтрокаТЧ <> Неопределено Тогда
			Значение  = СтрокаТЧ[ЭлементПоиска.Значение];
		КонецЕсли;
		Реквизиты.Вставить(ЭлементПоиска.Ключ, Значение);
	КонецЦикла;
	
	Возврат Реквизиты;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	сФормы = Новый Соответствие;
	сФормы.Вставить(ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Бот")		 , "Справочник.тг_Объект.Форма.ФормаБота");
	сФормы.Вставить(ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Группа")	 	 , "Справочник.тг_Объект.Форма.ФормаЧата");
	сФормы.Вставить(ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Канал")	 	 , "Справочник.тг_Объект.Форма.ФормаЧата");
	сФормы.Вставить(ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.ГруппаКанала"), "Справочник.тг_Объект.Форма.ФормаЧата");
	сФормы.Вставить(ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Сообщение")	 , "Справочник.тг_Объект.Форма.ФормаСообщения");
	сФормы.Вставить(ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Пользователь"), "Справочник.тг_Объект.Форма.ФормаПользователя");
	
	Если Параметры.Свойство("Ключ") Тогда
		Тип = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "Тип");
		ВыбраннаяФорма = сФормы.Получить(Тип);
	КонецЕсли;

	Если ЗначениеЗаполнено(ВыбраннаяФорма) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОсновныеРеквизиты()
	
	Реквизиты = Новый Массив;
	Реквизиты.Добавить("Код");
	Реквизиты.Добавить("Наименование");
	Реквизиты.Добавить("Родитель");
	Реквизиты.Добавить("Тип");
	Реквизиты.Добавить("Чат");
	Реквизиты.Добавить("Объект1С");
	
	Возврат Реквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли
