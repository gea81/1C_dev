
#Область ПрограммныйИнтерфейс

#Область События

// Записывает версию объекта (кроме документов) в информационную базу.
//
// Параметры:
//  ДокументОбъект - Объект - записываемый объект ИБ;
//  Отказ    - Булево - признак отказа от записи объекта.
//
Процедура ПриЗаписиДокумента(ДокументОбъект, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 	
	
	Если НЕ ТипОбъекта1СИспользуется(ДокументОбъект) Тогда
		Возврат;	
	КонецЕсли;
	
	ОтправитьОсновноеСообщение(ДокументОбъект.Ссылка);
		
КонецПроцедуры

//Обработчик подписки на событие "После отправки собщения системы взаимодействия".
// 
Процедура ПослеОтправкиСообщенияСВ(ИдентификаторСообщения) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	Сообщение 	= СистемаВзаимодействия.ПолучитьСообщение(ИдентификаторСообщения);
    
	ОтправитьСвязанноеСообщение(Сообщение);
	
КонецПроцедуры

// Входящий HTTPЗапрос.
// 
// Параметры:
//  Запрос - HTTPСервисЗапрос
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Входящий HTTPЗапрос
Функция ВходящийHTTPЗапрос(Запрос) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("Код", Сред(Запрос.ОтносительныйURL,2));
	Отбор.Вставить("Тип", Перечисления.тг_ТипыОбъектов.Бот);
	
	Бот = Справочники.тг_Объект.ПолучитьОбъектПоОтбору(Отбор);

	Если Запрос.Заголовки["Content-Type"] = "application/json" Тогда
		ВходящиеДанные = ОбработатьJSON(Запрос.ПолучитьТелоКакСтроку());
	Иначе
		ВходящиеДанные = Новый Соответствие;
	КонецЕсли;
	
	Если ВходящиеДанные["message"] <> Неопределено Тогда 	
		Обработать_message(Бот, ВходящиеДанные["message"]); 
	ИначеЕсли ВходящиеДанные["channel_post"]<> Неопределено Тогда 	
		Обработать_message(Бот, ВходящиеДанные["channel_post"]);
 	ИначеЕсли ВходящиеДанные["inline_query"] <> Неопределено Тогда
		Обработать_inline_query(ВходящиеДанные["inline_query"]);
	ИначеЕсли ВходящиеДанные["callback_query"] <> Неопределено Тогда 	
		Обработать_callback_query(ВходящиеДанные["callback_query"]);
	ИначеЕсли ВходящиеДанные["my_chat_member"] <> Неопределено Тогда
		Обработать_my_chat_member(ВходящиеДанные["my_chat_member"]);
	КонецЕсли; 

	Возврат Новый HTTPСервисОтвет(200);

КонецФункции

#КонецОбласти

#Область РаботаСВебхук

Функция ПолучитьВебхук(Токен) Экспорт
	Данные = ПолучитьДанныеВебхук(Токен);
	Возврат Данные["url"];	
КонецФункции

Процедура СохранитьВебхук(Токен, Адрес) Экспорт
	
	Если ЗначениеЗаполнено(Адрес)
		И ПроверитьВебхук(Адрес) Тогда
		УстановитьВебхук(Токен, Адрес);		
	Иначе
        Адрес = "";
        УдалитьВебхук(Токен);
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьВебхук(Вебхук) Экспорт

	Заголовки = Новый Соответствие;
	
	СтруктуруURL = ПолучитьСтруктуруURL(Вебхук);
	
	Результат = ИсходящийHTTPЗапрос(Неопределено, СтруктуруURL.Сервер, СтруктуруURL.АдресРесурса, Заголовки, "GET");
	
	Возврат Результат["ok"]= Истина;
	
КонецФункции

#КонецОбласти

#Область МетодыТелеграм

Функция ПолучитьДанныеБота(Токен) Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("Токен", Токен);
	Данные.Вставить("Метод", "ДанныеБота");
	
	Результат = ОтправитьHTTPЗапрос(Данные);
	Результат = Результат["result"];
	
	Возврат Результат;

КонецФункции

Функция ПолучитьДанныеВебхук(Токен) Экспорт

	Данные = Новый Структура;
	Данные.Вставить("Токен", Токен);
	Данные.Вставить("Метод", "ДанныеВебХук");
	
	Результат = ОтправитьHTTPЗапрос(Данные);

	Возврат Результат["result"];	

КонецФункции

Функция УстановитьВебхук(Токен, Адрес) Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("Токен" , Токен);
	Данные.Вставить("Метод" , "УстановитьВебХук");
	Данные.Вставить("Адрес"	, Адрес);
	
	Результат = ОтправитьHTTPЗапрос(Данные);
		
	Возврат Результат["result"] = Истина;
	
КонецФункции

Функция УдалитьВебхук(Токен) Экспорт

	Данные = Новый Структура;
	Данные.Вставить("Токен", Токен);
	Данные.Вставить("Метод" , "УдалитьВебХук");

	Результат = ОтправитьHTTPЗапрос(Данные);
	
	Возврат Результат["result"];
	
КонецФункции

Функция ОтправитьСообщение(Бот, Чат, Текст, Параметры = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
		
	Если ТипЗнч(Параметры) <> Тип("Структура") Тогда
		Параметры = Новый Структура;		
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("Бот"		, Бот);
	Данные.Вставить("Метод"		, "ТекстовоеСообщение_Отправить");
	Данные.Вставить("ИдЧата"	, Чат.Код);
	Данные.Вставить("Текст"		, Текст);

	Для каждого Параметр Из Параметры Цикл
		Данные.Вставить(Параметр.Ключ,Параметр.Значение);	
	КонецЦикла;	
	
	Если ЗначениеЗаполнено(Бот)
		И ЗначениеЗаполнено(Чат)
		И НЕ ПустаяСтрока(Текст) Тогда
		Результат = ОтправитьHTTPЗапрос(Данные);
	КонецЕсли;

	Результат = Результат["result"];
	
	Если Результат <> Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Бот", Бот);
		Если Параметры.Свойство("Объект1С") Тогда
			ДополнительныеПараметры.Вставить("Объект1С",Параметры.Объект1С); 	
		КонецЕсли;
		Если Параметры.Свойство("Родитель") Тогда
			ДополнительныеПараметры.Вставить("Родитель",Параметры.Родитель); 	
		КонецЕсли;
		Справочники.тг_Объект.ПолучитьОбъектПоДаннымТелеграм(Результат, ДополнительныеПараметры);	
	КонецЕсли;
	
	ОтправитьВложения(Данные, Параметры);
	
	Возврат Результат;
	
КонецФункции

Функция ОбновитьСообщение(Сообщение, Текст, Параметры = Неопределено) Экспорт
 
	РеквизитыОбъекта = Справочники.тг_Объект.ПолучитьРеквизиты(Сообщение);
	
	Если НЕ РеквизитыОбъекта.Свойство("Бот") 
		ИЛИ НЕ ЗначениеЗаполнено(РеквизитыОбъекта.Бот)
		ИЛИ НЕ РеквизитыОбъекта.Свойство("Чат") 
		ИЛИ НЕ ЗначениеЗаполнено(РеквизитыОбъекта.Чат)
		ИЛИ ПустаяСтрока(Текст)
		ИЛИ (РеквизитыОбъекта.Свойство("Текст")
		И СокрЛП(РеквизитыОбъекта.Текст) = СокрЛП(Текст))
		Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("Бот"			, РеквизитыОбъекта.Бот);
	Данные.Вставить("Метод"			, "ТекстовоеСообщение_Обновить");
	Данные.Вставить("ИдЧата"		, РеквизитыОбъекта.Чат.Код);
	Данные.Вставить("ИдСообщения"	, Сообщение.Код);
	Данные.Вставить("Текст"			, Текст);
	
	Если ТипЗнч(Параметры) <> Тип("Структура") Тогда
		Параметры = Новый Структура;		
	КонецЕсли;

	Для каждого Параметр Из Параметры Цикл
		Данные.Вставить(Параметр.Ключ,Параметр.Значение);	
	КонецЦикла;	
	
	Результат = ОтправитьHTTPЗапрос(Данные);
	
	//Если Результат["result"] = Неопределено 
	//	И СтрНайти(Результат["ТекстОшибки"],"message is not modified") = 0 Тогда
	//	Сообщение.ПолучитьОбъект().УстановитьПометкуУдаления(Истина);
	//	ОтправитьСообщение(РеквизитыОбъекта.Бот, РеквизитыОбъекта.Чат, Текст, Параметры);
	//КонецЕсли;

	Результат = Результат["result"];
	Возврат Результат;
		
КонецФункции

Функция ИзменитьПодписьСообщения(Сообщение, Подпись) Экспорт

	Результат = Новый Соответствие;
	
	РеквизитыСообщения = Справочники.тг_Объект.ПолучитьРеквизиты(Сообщение);

	Если НЕ РеквизитыСообщения.Свойство("Бот") 
		ИЛИ НЕ ЗначениеЗаполнено(РеквизитыСообщения.Бот)
		ИЛИ НЕ РеквизитыСообщения.Свойство("Чат") 
		ИЛИ НЕ ЗначениеЗаполнено(РеквизитыСообщения.Чат)
		ИЛИ ПустаяСтрока(Подпись)
		Тогда
		Возврат Результат;
	КонецЕсли;
		
	Данные = Новый Структура;
	Данные.Вставить("Бот"			, РеквизитыСообщения.Бот);
	Данные.Вставить("Метод"			, "ИзменитьПодписьСообщения");
	Данные.Вставить("ИдЧата"		, РеквизитыСообщения.Чат.Код);
	Данные.Вставить("ИдСообщения" 	, РеквизитыСообщения.Код);
	Данные.Вставить("Подпись"		, Подпись);

	Результат = ОтправитьHTTPЗапрос(Данные);

	Возврат Результат;
	
КонецФункции

Функция УдалитьСообщение(Сообщение) Экспорт
	
	РеквизитыОбъекта = Справочники.тг_Объект.ПолучитьРеквизиты(Сообщение);
	
	Данные = Новый Структура;
	Данные.Вставить("Бот"			, РеквизитыОбъекта.Бот);
	Данные.Вставить("Метод" 		, "ТекстовоеСообщение_Удалить");
	Данные.Вставить("ИдЧата"		, РеквизитыОбъекта.Чат.Код);
	Данные.Вставить("ИдСообщения"	, РеквизитыОбъекта.Код);

	Результат = ОтправитьHTTPЗапрос(Данные);
	Результат = Результат["result"];
				
	Возврат Результат;
		
КонецФункции

Процедура ОтправитьВложения(Сообщение, Параметры)
	
	Перем Вложения;
	
	Если НЕ Параметры.Свойство("Вложения",Вложения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Вложения)<>Тип("Массив") Тогда
		Вложения = Новый Массив;	
	КонецЕсли;

	Для Каждого Вложение Из Вложения Цикл
		
		Если ТипЗнч(Вложение)<> Тип("Структура") Тогда
			Продолжить;;	
		КонецЕсли;
				
		ОтправитьВложение(Вложение, Сообщение);
		
	КонецЦикла;

КонецПроцедуры

Функция ОтправитьВложение(Данные, Параметры) Экспорт
	
	Если ТипЗнч(Параметры) <> Тип("Структура") Тогда
		Параметры = Новый Структура;		
	КонецЕсли;

	Для каждого Параметр Из Параметры Цикл
		Если Данные.Свойство(Параметр.Ключ) Тогда
			Продолжить;	
		КонецЕсли;
		Данные.Вставить(Параметр.Ключ,Параметр.Значение);	
	КонецЦикла;	

	Результат = ОтправитьHTTPЗапрос(Данные);
	Результат = Результат["result"];

	Если Результат <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура;
		Если Параметры.Свойство("Бот") Тогда
			ДополнительныеПараметры.Вставить("Бот",Параметры.Бот); 	
		КонецЕсли;
		Если Параметры.Свойство("Объект1С") Тогда
			ДополнительныеПараметры.Вставить("Объект1С",Параметры.Объект1С); 	
		КонецЕсли;
		Если Параметры.Свойство("Родитель") Тогда
			ДополнительныеПараметры.Вставить("Родитель",Параметры.Родитель); 	
		КонецЕсли;
		Справочники.тг_Объект.ПолучитьОбъектПоДаннымТелеграм(Результат, ДополнительныеПараметры);	
		
	КонецЕсли;

КонецФункции

Функция ПолучитьДанныеЧата(Чат, Бот = Неопределено) Экспорт

	Результат = Новый Соответствие;
	
	Если Бот = Неопределено Тогда
		Бот = ПолучитьБотаПоЧату(Чат);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Чат) 
		ИЛИ НЕ ЗначениеЗаполнено(Бот) Тогда
		Возврат Результат;
	КонецЕсли;
		
	Данные = Новый Структура;
	Данные.Вставить("Бот"		, Бот);
	Данные.Вставить("Метод"		, "ДанныеЧата");
	Данные.Вставить("Ид_Чата"	, Чат.Код);

	Ответ = ОтправитьHTTPЗапрос(Данные);
	
	Если Ответ["result"] <> Неопределено Тогда
		Возврат Ответ["result"];	
	Иначе
		Возврат Результат;	
	КонецЕсли; 
	
КонецФункции

Функция УстановитьЗаголовокЧата(Чат, Заголовок = "", Бот = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	
	Если Бот = Неопределено Тогда
		Бот = ПолучитьБотаПоЧату(Чат);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Чат) 
		ИЛИ НЕ ЗначениеЗаполнено(Бот) Тогда
		Возврат Результат;
	КонецЕсли;
		
	Данные = Новый Структура;
	Данные.Вставить("Бот"		, Бот);
	Данные.Вставить("Метод"		, "УстановитьЗаголовокЧата");
	Данные.Вставить("Ид_Чата"	, Чат.Код);
	Данные.Вставить("Заголовок"	, Заголовок);

	Результат = ОтправитьHTTPЗапрос(Данные);

	Возврат Результат["result"] = Истина;
	
КонецФункции

Функция УстановитьОписаниеЧата(Чат, Описание = "", Бот = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	
	Если Бот = Неопределено Тогда
		Бот = ПолучитьБотаПоЧату(Чат);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Чат) 
		ИЛИ НЕ ЗначениеЗаполнено(Бот) Тогда
		Возврат Результат;
	КонецЕсли;
		
	Данные = Новый Структура;
	Данные.Вставить("Бот"		, Бот);
	Данные.Вставить("Метод"		, "УстановитьОписаниеЧата");
	Данные.Вставить("Ид_Чата"	, Чат.Код);
	Данные.Вставить("Описание"	, Описание);

	Результат = ОтправитьHTTPЗапрос(Данные);

	Возврат Результат;
	
КонецФункции

Функция УстановитьНазваниеАдминистрараЧата(Чат, Название, Бот = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	
	Если Бот = Неопределено Тогда
		Бот = ПолучитьБотаПоЧату(Чат);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Чат) 
		ИЛИ НЕ ЗначениеЗаполнено(Бот) Тогда
		Возврат Результат;
	КонецЕсли;
		
	Данные = Новый Структура;
	Данные.Вставить("Бот"			, Бот);
	Данные.Вставить("Метод"			, "УстановитьНазваниеАдминистратораЧата");
	Данные.Вставить("ИдЧата"		, Чат.Код);
	Данные.Вставить("ИдПользователя", Бот.Код);
	Данные.Вставить("Название"		, Название);

	Результат = ОтправитьHTTPЗапрос(Данные);

	Возврат Результат;
	
КонецФункции

Функция ПолучитьФайл(Бот, ИдФайла) Экспорт

	Если ИдФайла <> Неопределено Тогда
		
		Данные = Новый Структура;
		Данные.Вставить("Бот"		, Бот);
		Данные.Вставить("Метод"		, "ПолучитьФайл");
		Данные.Вставить("ИдФайла"	, ИдФайла);	
			
		Результат = ОтправитьHTTPЗапрос(Данные);	
		ДанныеФайла = Результат["result"];
		
		Если ДанныеФайла <> Неопределено Тогда
					
			Данные = Новый Структура;
			Данные.Вставить("Бот"		, Бот);
			Данные.Вставить("Метод"			, ДанныеФайла["file_path"]);
			Данные.Вставить("ПолучитьФайл"	, Истина);
			
			Результат = ОтправитьHTTPЗапрос(Данные);

			Если ТипЗнч(Результат["Данные"]) = Тип("ДвоичныеДанные") Тогда

				мДанныеФайла = Новый Структура;
				мДанныеФайла.Вставить("Поток"			, Результат["Данные"].ОткрытьПотокДляЧтения());
				мДанныеФайла.Вставить("Имя"				, ДанныеФайла["file_path"]);

				Возврат мДанныеФайла; 
				
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли; 

КонецФункции

#КонецОбласти

Процедура ДобавитьОформление(ПараметрыСообщения, Оформление, Позиция, Длина, 
	Пользователь = Неопределено) Экспорт
	
	СтрОформления = Новый Структура;
	СтрОформления.Вставить("type"	, Оформление);
	СтрОформления.Вставить("offset"	, Позиция);
	СтрОформления.Вставить("length"	, Длина);
	Если Пользователь <> Неопределено Тогда
		СтрОформления.Вставить("user"	, Пользователь);
	КонецЕсли;
	
	Если НЕ ПараметрыСообщения.Свойство("Сущности") Тогда
		ПараметрыСообщения.Вставить("Сущности", Новый Массив);	
	КонецЕсли;                                               
		
	ПараметрыСообщения.Сущности.Добавить(СтрОформления);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОтправкаДанныхHTTP

// HTTPЗапрос.
// 
// Возвращаемое значение:
//  HTTPСоединение - HTTPСоединение:
//  
Функция ПолучитьHTTPСоединение(Сервер)
	
	Данные = Новый Структура;
	Данные.Вставить("Сервер"				, Сервер);
	Данные.Вставить("Порт"					, 443);
	Данные.Вставить("Пользователь"			, "");
	Данные.Вставить("Пароль"				, "");
	Данные.Вставить("Прокси"				, Новый ИнтернетПрокси());
	Данные.Вставить("Таймаут"				, 300);
	Данные.Вставить("ЗащищенноеСоединение"	, Новый ЗащищенноеСоединениеOpenSSL());
	
	Попытка	
		Возврат Новый HTTPСоединение(Данные.Сервер,Данные.Порт,Данные.Пользователь,Данные.Пароль,
							Данные.Прокси,Данные.Таймаут,Данные.ЗащищенноеСоединение);
	Исключение
		
		ВызватьИсключение "Не удалось установить соединение с сервером. 
						  |Причина: "  + ОписаниеОшибки();
			
	КонецПопытки;
			
КонецФункции

Функция ИсходящийHTTPЗапрос(Данные, Сервер, АдресРесурса, Заголовки, Метод = "POST")
	
	Результат = Новый Соответствие;
	
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Данные = Новый Структура;	
	КонецЕсли;                  
	
	Попытка
		
		СоединениеHTTP = ПолучитьHTTPСоединение(Сервер);
					
		HTTPЗапрос = Новый HTTPЗапрос;
		HTTPЗапрос.АдресРесурса = АдресРесурса;
		HTTPЗапрос.Заголовки	= Заголовки;
		
		Если Данные.Свойство("ТелоДвоичныеДанные") Тогда
			HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(Данные.ТелоДвоичныеДанные);
		ИначеЕсли Данные.Свойство("ТелоСтрока") Тогда
			HTTPЗапрос.УстановитьТелоИзСтроки(Данные.ТелоСтрока);
		КонецЕсли;
		
		РезультатЗапроса = СоединениеHTTP.ВызватьHTTPМетод(Метод, HTTPЗапрос);
					
		Если РезультатЗапроса.КодСостояния = 200 Тогда

			Если РезультатЗапроса.Заголовки["Content-Type"] = "application/json" Тогда
				Результат = ОбработатьJSON(РезультатЗапроса.ПолучитьТелоКакСтроку());
			ИначеЕсли РезультатЗапроса.Заголовки["Content-Type"] = "application/octet-stream" Тогда
				Результат.Вставить("Данные",РезультатЗапроса.ПолучитьТелоКакДвоичныеДанные());
			ИначеЕсли РезультатЗапроса.Заголовки["Content-Type"] = "text/html" Тогда
				Результат.Вставить("ok",Истина);
			КонецЕсли;
			
		Иначе
			
			Результат.Вставить("ТекстОшибки",РезультатЗапроса.ПолучитьТелоКакСтроку()); 
			
		КонецЕсли; 
			
	Исключение
		
		Результат.Вставить("ТекстОшибки",ОписаниеОшибки()); 
	
		//	РегистрыСведений.СД_ТелеграмЛоги.ЗаписатьОшибку(ИнформацияОбОшибке());
	
	КонецПопытки; 
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПодготовитьДанныеHTTP

// Отправить Формирует данные для отправки HTTPЗапроса.
// 
// Параметры:
//  Метод  - Строка - Имя метода
//  Данные - Структура - Подготовленные данные
//  Параметры -Структура - Параметры
// 
// Возвращаемое значение:
//  Соответствие
Функция ОтправитьHTTPЗапрос(Данные)
	
	Перем Бот, Токен, Метод;
	
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Данные = Новый Структура;	
	КонецЕсли;                  
	
	Данные.Свойство("Токен"	, Токен);
	Данные.Свойство("Бот"	, Бот);
	Данные.Свойство("Метод"	, Метод);
	
	Если Токен = Неопределено 
		И Бот <> Неопределено Тогда
		РеквизитыОтправителя = Справочники.тг_Объект.ПолучитьРеквизиты(Бот);
		РеквизитыОтправителя.Свойство("Токен",Токен);
	КонецЕсли;

	Если Токен = Неопределено 
		ИЛИ Метод = Неопределено Тогда
		Возврат Новый Соответствие;
	КонецЕсли; 
	
	МассивОшибок = Новый Массив;
	
	Правило = тг_СерверПовтИсп.ПолучитьПравилоМетода(Метод);
	ДанныеДляОтправки = ПодготовитьДанные(Правило, Данные, МассивОшибок);
		
	ИсходящиеДанные = Новый Структура;
	
	АдресРесурса 	= СтрШаблон("bot%1/%2", Токен, Правило.Метод);
	Заголовки 		= Новый Соответствие;
	МетодHTTP 		= "POST";
	
	Если Данные.Свойство("ПолучитьФайл") Тогда
		АдресРесурса = "file/" + АдресРесурса;
		МетодHTTP = "GET";
	ИначеЕсли ЗначениеЗаполнено(ДанныеДляОтправки) Тогда
		ИсходящиеДанные.Вставить("ТелоСтрока",СформироватьJSON(ДанныеДляОтправки));
	КонецЕсли;
	
	Если Данные.Свойство("ОтправитьФайл") Тогда 
		
		СтрокиПараметров = Новый Массив;
		Для каждого ПолеДанных Из ДанныеДляОтправки Цикл
			СтрокиПараметров.Добавить(СтрШаблон("%1=%2", ПолеДанных.Ключ, ПолеДанных.Значение));
		КонецЦикла;
		
		АдресРесурса = АдресРесурса + "?" + СтрСоединить(СтрокиПараметров, "&");
		
		ТелоДвоичныеДанные = ПолучитьТелоДвоичныеДанные(Данные.ОтправитьФайл);
		ИсходящиеДанные.Вставить("ТелоДвоичныеДанные",ТелоДвоичныеДанные);	

		Заголовки.Вставить("Content-Type"	, "multipart/form-data; boundary=" 
												+ Данные.ОтправитьФайл["boundary"]);
		Заголовки.Вставить("Content-Length"	, Формат(ТелоДвоичныеДанные.Размер(), "ЧДЦ=0; ЧН=0; ЧГ=0"));

	Иначе

		Заголовки.Вставить("Content-type", "application/json");
	
	КонецЕсли;
	
	Если МассивОшибок.Количество() Тогда
		Возврат Новый Соответствие;
	Иначе
		Возврат ИсходящийHTTPЗапрос(ИсходящиеДанные, "api.telegram.org", АдресРесурса, Заголовки, МетодHTTP);
	КонецЕсли;
		
КонецФункции

Функция ПодготовитьДанные(Правило, ВходящиеДанные, МассивОшибок)
	
	ИсходящиеДанные = Новый Соответствие;
	
	Если ПустаяСтрока(Правило.Метод) Тогда
		МассивОшибок.Добавить(НСтр("ru = 'Не указано имя метода'"));
	КонецЕсли;            
	
	ШаблонОшибки = НСтр("ru = 'Не заполнено обязательное значение %1'");
	
	Для каждого Поле Из Правило.Поля Цикл
		
		Если ВходящиеДанные.Свойство(Поле.Имя) Тогда
			ЗначениеПоля = ВходящиеДанные[Поле.Имя];
		Иначе
			ЗначениеПоля = Неопределено;
		КонецЕсли;
		
		Если Поле.Обязательный 
			И НЕ ЗначениеЗаполнено(ЗначениеПоля) Тогда
			МассивОшибок.Добавить(СтрШаблон(ШаблонОшибки,Поле.Имя));
			Продолжить;		 
		КонецЕсли;
		
		ЗначениеПоля = ПривестиКТипу(ЗначениеПоля, Поле.Тип);
		Если ЗначениеЗаполнено(ЗначениеПоля) Тогда
			Если НЕ ПустаяСтрока(Поле.Параметр) Тогда
				ИсходящиеДанные.Вставить(Поле.Параметр, ЗначениеПоля);
			Иначе
				ИсходящиеДанные.Вставить(Поле.Имя, ЗначениеПоля);	
			КонецЕсли;
		ИначеЕсли Поле.Значение <> Неопределено Тогда
			ИсходящиеДанные.Вставить(Поле.Параметр, Поле.Значение);
		КонецЕсли; 
	
	КонецЦикла;  
	
	Возврат ИсходящиеДанные;
	
КонецФункции

Функция ПолучитьТелоДвоичныеДанные(Данные)

	Данные["boundary"] = "----" + Строка(Новый УникальныйИдентификатор());

	Тело         = Новый ПотокВПамяти();
    ЗаписьДанных = Новый ЗаписьДанных(Тело, КодировкаТекста.UTF8, ПорядокБайтов.LittleEndian, Символы.ВК + Символы.ПС, Символы.ПС, Истина);
	
    ЗаписьДанных.ЗаписатьСтроку("--" + Данные["boundary"]);
    ЗаписьДанных.ЗаписатьСтроку(СтрШаблон("Content-Disposition: form-data; name=""%1""; filename=""%2""", Данные["Имя"], Данные["ИмяФайла"]));
    ЗаписьДанных.ЗаписатьСтроку("Content-Type:" + Данные["Тип"]);
    ЗаписьДанных.ЗаписатьСтроку("");   
	
    ЗаписьДанных.Записать(Данные["ДвоичныеДанные"]);
	
	ЗаписьДанных.ЗаписатьСтроку("");
    ЗаписьДанных.ЗаписатьСтроку("--" + Данные["boundary"] + "--");
    ЗаписьДанных.Закрыть();
    
    ТелоДвоичныеДанные = Тело.ЗакрытьИПолучитьДвоичныеДанные(); 
	
	Возврат ТелоДвоичныеДанные;
	
КонецФункции

Функция ПолучитьВложениеСВ(Вложение)

	Если тг_СерверПовтИсп.ТипыИзображения()[Вложение.ТипСодержимого] = Истина Тогда
		ИмяМетода 	= "Изображение_Отправить";
		Имя 		= "photo"
	ИначеЕсли тг_СерверПовтИсп.ТипыАудио()[Вложение.ТипСодержимого] = Истина Тогда	
		ИмяМетода 	= "Аудиофайл_Отправить";
		Имя			= "audio";
	Иначе
		ИмяМетода 	= "Документ_Отправить";
		Имя			= "document";
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Метод"			, ИмяМетода);
    Результат.Вставить("ОтправитьФайл"	, Новый Соответствие);
	Результат.ОтправитьФайл["ИмяФайла"]	= Вложение.Наименование;
	Результат.ОтправитьФайл["Имя"]		= Имя;
	Результат.ОтправитьФайл["Тип"]		= Вложение.ТипСодержимого;
			
	ЧтениеДанных = Новый ЧтениеДанных(Вложение.ОткрытьПотокДляЧтения());
	Результат.ОтправитьФайл["ДвоичныеДанные"]	= ЧтениеДанных.Прочитать().ПолучитьДвоичныеДанные();
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьБотаПоЧату(Чат)
	
	Выборка = Справочники.тг_Объект.Выбрать(,,Новый Структура("Тип",Перечисления.тг_ТипыОбъектов.Бот));
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеЧата = ПолучитьДанныеЧата(Чат, Выборка.Ссылка);
		Если ДанныеЧата <> Неопределено Тогда
			Возврат Выборка.Ссылка;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Справочники.тг_Объект.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиJSON

Функция СформироватьJSON(СтруктураДанных, ФормироватьСПереносами = Ложь)
	
	Если СтруктураДанных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Попытка
		ЗаписьJSON = Новый ЗаписьJSON;
		Если ФормироватьСПереносами Тогда
			ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(, Символы.Таб));
		Иначе
			ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, Символы.Таб));
		КонецЕсли; 
		
		НастройкиСериализацииJSON = Новый НастройкиСериализацииJSON;
		НастройкиСериализацииJSON.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.ЛокальнаяДатаСоСмещением;
		НастройкиСериализацииJSON.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
		
		ЗаписатьJSON(ЗаписьJSON, СтруктураДанных, НастройкиСериализацииJSON);
		
		Возврат ЗаписьJSON.Закрыть();
	Исключение
		//РегистрыСведений.СД_ТелеграмЛоги.ЗаписатьОшибку(ИнформацияОбОшибке(), Истина);
		//@skip-check module-unused-local-variable
		Загрушка = Истина;
	КонецПопытки; 
	
КонецФункции

Функция ОбработатьJSON(СтрокаJSON) Экспорт
	
	Если СтрокаJSON = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	ДанныеВозврата = Неопределено;
	
	Попытка
		Чтение = Новый ЧтениеJSON;
		Чтение.УстановитьСтроку(СтрокаJSON);
		
		ДанныеВозврата = ПрочитатьJSON(Чтение, Истина,,, "ПреобразованиеJSON", тг_Сервер);
	Исключение
		//РегистрыСведений.СД_ТелеграмЛоги.ЗаписатьОшибку(ИнформацияОбОшибке());
		//@skip-check module-unused-local-variable
		Загрушка = Истина; 
	КонецПопытки; 
	
	Возврат ДанныеВозврата;
	
КонецФункции

Функция ПреобразованиеJSON(Свойство, Значение, ДополнительныеПараметры) Экспорт
	Если Свойство = "date" Тогда
		Попытка
			Возврат Дата("19700101") + ?(ТипЗнч(Значение) = Тип("Строка"), Число(Значение), Значение);
		Исключение
			Возврат Дата(1,1,1);
		КонецПопытки;
	КонецЕсли; 
КонецФункции

#КонецОбласти

#Область СобытияВебхукТелеграм

Процедура Обработать_message(Бот, message)
	
	Если НЕ ЗначениеЗаполнено(Бот) Тогда
		Возврат;
	КонецЕсли;
		
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("Бот"	, Бот);
	ПараметрыСообщения.Вставить("Вебхук", Истина);

	ЭтоКомандаБота = message["entities"] <> Неопределено 
			И message["entities"].Количество() = 1
			И message["entities"][0]["type"] = "bot_command";
		
	Если ЭтоКомандаБота И message["text"] = "/start" Тогда

	Иначе
		Справочники.тг_Объект.ПолучитьОбъектПоДаннымТелеграм(message, ПараметрыСообщения);
		Если ПараметрыСообщения.Свойство("СинхронизироватьСообщения") Тогда
			СинхронизироватьСообщения(ПараметрыСообщения.СинхронизироватьСообщения);	
		КонецЕсли;
	КонецЕсли;
			
КонецПроцедуры

Процедура Обработать_inline_query(inline_query)
	//TODO		
КонецПроцедуры

Процедура Обработать_callback_query(callback_query)
	//TODO
КонецПроцедуры

Процедура Обработать_my_chat_member(my_chat_member)

	Если my_chat_member["chat"] <> Неопределено Тогда
		Справочники.тг_Объект.ПолучитьОбъектПоДаннымТелеграм(my_chat_member["chat"]);	
	КонецЕсли;	

	Если my_chat_member["from"] <> Неопределено Тогда
		Справочники.тг_Объект.ПолучитьОбъектПоДаннымТелеграм(my_chat_member["from"]);	
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область РаботаССообщениями

Процедура ОтправитьОсновноеСообщение(Объект1С)
	
	СобытияОбъекта = Справочники.тг_События.ПолучитьСобытияОбъекта1С(Объект1С);
	Если НЕ СобытияОбъекта.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаОбъект1С = ПолучитьНавигационнуюСсылку(Объект1С);
	
	Для Каждого СобытиеОбъекта Из СобытияОбъекта Цикл
		
		ОтборОбъекта = Новый Структура;
		ОтборОбъекта.Вставить("Объект1С", СсылкаНаОбъект1С);
		ОтборОбъекта.Вставить("Чат"		, СобытиеОбъекта.Получатель);
		
		Сообщение = Справочники.тг_Объект.ПолучитьОбъектПоОтбору(ОтборОбъекта);

		Если НЕ СобытиеОбъекта.УсловиеВыполнено Тогда
			Если ЗначениеЗаполнено(Сообщение) Тогда
				УдалитьСообщение(Сообщение); 
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		СобытиеОбъекта.Параметры.Вставить("Объект1С", СсылкаНаОбъект1С);
		
		Если ЗначениеЗаполнено(Сообщение) Тогда
			ОбновитьСообщение(Сообщение, СобытиеОбъекта.Текст, СобытиеОбъекта.Параметры);
		Иначе
			ОтправитьСообщение(СобытиеОбъекта.Бот, СобытиеОбъекта.Получатель, СобытиеОбъекта.Текст, СобытиеОбъекта.Параметры);
		КонецЕсли;

	КонецЦикла;


КонецПроцедуры

Процедура ОтправитьСвязанноеСообщение(СообщениеСВ)

	Если Не СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(СообщениеСВ.Обсуждение);
	КонтекстОбсуждения = Обсуждение.КонтекстОбсуждения;
	Если КонтекстОбсуждения = Неопределено
		ИЛИ НЕ ЗначениеЗаполнено(КонтекстОбсуждения.НавигационнаяСсылка) Тогда
		Возврат;
	КонецЕсли;

	Объект1С = ПолучитьНавигационнуюСсылку(СообщениеСВ);

	ПараметрыСообщения = Новый Структура;
    ПараметрыСообщения.Вставить("Объект1С", Объект1С);
	ПользовательСВ = СистемаВзаимодействия.ПолучитьПользователя(СообщениеСВ.Автор);
	
	ДопДанные = СообщениеСВ.Данные;
	
	Если ТипЗнч(ДопДанные) <> Тип("Структура") Тогда
		ДопДанные = Новый Структура;
	КонецЕсли;
	
	Если ДопДанные.Свойство("Автор") Тогда
        ДанныеПользователя = ПолучитьДанныеЧата(ДопДанные.Автор);
		Если ДанныеПользователя <> Неопределено Тогда
			ДобавитьОформление(ПараметрыСообщения, "text_mention", 0, СтрДлина(ДанныеПользователя["username"])+1, ДанныеПользователя); 
		КонецЕсли;
		ДопТекст = "@" + ДанныеПользователя["username"];
	Иначе
		ДопТекст = "[" + ПользовательСВ.Имя + " " + СообщениеСВ.Дата + "]" + Символы.ПС;
		ДобавитьОформление(ПараметрыСообщения,"pre", 0, СтрДлина(ДопТекст));
	КонецЕсли;
		
	Для Каждого Получатель Из СообщениеСВ.Получатели Цикл

		ПользовательСВ = СистемаВзаимодействия.ПолучитьПользователя(Получатель);
		ПользователиИБ = Справочники.Пользователи.НайтиПоРеквизиту(
							"ИдентификаторПользователяИБ",	ПользовательСВ.ИдентификаторПользователяИнформационнойБазы);
		
		тгОтбор = Новый Структура;
		тгОтбор.Вставить("Тип"		, ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Пользователь"));
		тгОтбор.Вставить("Объект1С"	, ПолучитьНавигационнуюСсылку(ПользователиИБ));
		
		тгПользователь = Справочники.тг_Объект.ПолучитьОбъектПоОтбору(тгОтбор);
		Если ЗначениеЗаполнено(тгПользователь) Тогда
			ДанныеПользователя = ПолучитьДанныеЧата(тгПользователь);
			Если ДанныеПользователя <> Неопределено Тогда
				ДобавитьОформление(ПараметрыСообщения, "text_mention", СтрДлина(ДопТекст) , СтрДлина(ДанныеПользователя["username"])+1, ДанныеПользователя); 
			КонецЕсли;
			ДопТекст = ДопТекст + "@" + ДанныеПользователя["username"];
		КонецЕсли;
			
	КонецЦикла;
	
	ТекстСообщения = СообщениеСВ.Текст;
	Если ТипЗнч(СообщениеСВ.Данные)=Тип("Структура") 
		И СообщениеСВ.Данные.Свойство("ДопТекст") Тогда
		ТекстСообщения = СтрЗаменить(ТекстСообщения, СообщениеСВ.Данные.ДопТекст,"");	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
				
		ПараметрыСообщения.Вставить("ДопТекст", ДопТекст);
		ТекстСообщения = ДопТекст + ?(ПустаяСтрока(ДопТекст),"",Символы.ПС) + ТекстСообщения;

	КонецЕсли;

	тгОтбор = Новый Структура;
	тгОтбор.Вставить("Тип"		, ПредопределенноеЗначение("Перечисление.тг_ТипыОбъектов.Сообщение"));
	тгОтбор.Вставить("Объект1С"	, КонтекстОбсуждения.НавигационнаяСсылка);

	МассивОснований = Справочники.тг_Объект.ПолучитьОбъектПоОтбору(тгОтбор, Новый Структура("ПолучатьСписок"));
	
	тгОтбор = Новый Структура;
	тгОтбор.Вставить("Объект1С"	, Объект1С);

	ПараметрыСообщения.Вставить("Вложения", Новый Массив);
	
	Для каждого ВложениеСВ Из СообщениеСВ.Вложения Цикл
		ПараметрыСообщения.Вложения.Добавить(ПолучитьВложениеСВ(ВложениеСВ));
	КонецЦикла;   

	Для Каждого Основание Из МассивОснований Цикл
		
		Если НЕ ЗначениеЗаполнено(Основание.Родитель) Тогда
			Продолжить;
		КонецЕсли;

		тгОтбор.Вставить("Родитель"	, Основание);
		
		Данные = Справочники.тг_Объект.ПолучитьРеквизиты(Основание);
		
		ПараметрыСообщения.Вставить("ИдПересылаемогоСообщения", Данные.Код);
		
		мСообщение = Справочники.тг_Объект.ПолучитьОбъектПоОтбору(тгОтбор);
		Если ЗначениеЗаполнено(мСообщение) Тогда
			ОбновитьСообщение(мСообщение, ТекстСообщения, ПараметрыСообщения);
		Иначе
			ОтправитьСообщение(Данные.Бот, Данные.Чат, ТекстСообщения, ПараметрыСообщения);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область РаботаССистемойВзаимодействия

Процедура СинхронизироватьСообщения(Объект1С)
		
	Если Не СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		Возврат;
	КонецЕсли;
	
	Обсуждение = ОбсуждениеКонтекстное(Объект1С);

	УстановитьПривилегированныйРежим(Истина);
	
	ОтборСообщений = Новый ОтборСообщенийСистемыВзаимодействия;
	ОтборСообщений.Обсуждение = Обсуждение.Идентификатор;
	
	МассивСообщений = СистемаВзаимодействия.ПолучитьСообщения(ОтборСообщений);
	
	Для Каждого СообщениеСВ Из МассивСообщений Цикл
		ОтправитьСвязанноеСообщение(СообщениеСВ);	
	КонецЦикла;
	
КонецПроцедуры

Функция ОбсуждениеКонтекстное(Контекст)
	
	Обсуждение = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	КонтекстОбсуждения = Новый КонтекстОбсужденияСистемыВзаимодействия(Контекст);
    
	ОтборОбсуждений = Новый ОтборОбсужденийСистемыВзаимодействия();
	ОтборОбсуждений.КонтекстноеОбсуждение 	= Истина;
	ОтборОбсуждений.КонтекстОбсуждения 		= КонтекстОбсуждения;
	
	НайденноеОбсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(ОтборОбсуждений);
	
	Если НайденноеОбсуждения.Количество() > 0 Тогда
		Возврат НайденноеОбсуждения[0];
	КонецЕсли;
		
	Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
	Обсуждение.КонтекстОбсуждения = КонтекстОбсуждения;
	Обсуждение.Записать();

	Возврат Обсуждение;
	
КонецФункции

Процедура ОтправитьСообщениеСВ(ДанныеСообщения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Если ТипЗнч(ДанныеСообщения)<>Тип("Структура") Тогда
		ДанныеСообщения = Новый Структура;	
	КонецЕсли;
	
	Если НЕ ДанныеСообщения.Свойство("Родитель") Тогда
        Возврат;
	КонецЕсли;

	СообщениеРодитель = СообщениеРодитель(ДанныеСообщения.Родитель);	
	Если ПустаяСтрока(СообщениеРодитель.Объект1С) Тогда
		Возврат;
	КонецЕсли;
	
	Автор = Неопределено;
	
	Если ДанныеСообщения.Свойство("Автор") Тогда
		
		Автор = СсылкаПоНавигационнойСсылке(
			Справочники.тг_Объект.ПолучитьРеквизиты(ДанныеСообщения.Автор).Объект1С);
					
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Автор) Тогда

		Попытка	
			ИдентификаторПользователяСВ = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(Автор.ИдентификаторПользователяИБ);
			ПользовательСВ = СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторПользователяСВ)
		Исключение
			ПользовательСВ = СистемаВзаимодействия.СоздатьПользователя(
				ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Автор.ИдентификаторПользователяИБ));
			ПользовательСВ.Записать();
		КонецПопытки

	КонецЕсли;
	
	ТекстСообщения = "";	
	Если ДанныеСообщения.Свойство("Текст") Тогда
		ТекстСообщения = ДанныеСообщения.Текст;	
	КонецЕсли;
	
	ДопТекст = "";
	
	Обсуждение = ОбсуждениеКонтекстное(СообщениеРодитель.Объект1С);

	СообщениеСВ = СистемаВзаимодействия.СоздатьСообщение(Обсуждение.Идентификатор);
	Если ПользовательСВ <> Неопределено Тогда
		СообщениеСВ.Автор = ПользовательСВ.Идентификатор;
	Иначе
		ДопТекст = ?(ЗначениеЗаполнено(ДанныеСообщения.Автор),"[" 
				+ Строка(ДанныеСообщения.Автор) +"]" + Символы.ПС,"");
	КонецЕсли;

	СообщениеСВ.Текст = ДопТекст + ТекстСообщения;
	
	Если ДанныеСообщения.Свойство("Вложения") 
		И ТипЗнч(ДанныеСообщения.Вложения) = Тип("Массив") Тогда
				
		Для каждого Вложение Из ДанныеСообщения.Вложения Цикл
			СообщениеСВ.Вложения.Добавить(Вложение.Поток, Вложение.Имя);
		КонецЦикла;
			
	КонецЕсли;
	
	ДопДанные = Новый Структура;
	
	Если НЕ ПустаяСтрока(ДопТекст) Тогда
		ДопДанные.Вставить("ДопТекст", ДопТекст);	
   	КонецЕсли;
	
	Если ДанныеСообщения.Свойство("Автор") Тогда
		ДопДанные.Вставить("Автор", ДанныеСообщения.Автор);	
	КонецЕсли;
	
	СообщениеСВ.Данные = ДопДанные;
	
	СообщениеСВ.Записать();
	
	ДанныеСообщения.Вставить("Объект1С", ПолучитьНавигационнуюСсылку(СообщениеСВ));
		
КонецПроцедуры

Функция СообщениеРодитель(Сообщение)

	РеквизитыРодителя = Справочники.тг_Объект.ПолучитьРеквизиты(Сообщение.Родитель);
	Если Сообщение.Чат <> РеквизитыРодителя.Чат Тогда
		Возврат Сообщение;
	Иначе
		Возврат СообщениеРодитель(Сообщение.Родитель);
	КонецЕсли;                                        
	
КонецФункции

#КонецОбласти
#Область Вспомогательные

Функция ПривестиКТипу(Значение, Тип)
	
	ТипЗначения = ТипЗнч(Значение);
	Если ТипЗначения = Тип("Число")
		И Тип = "Строка" Тогда
		Возврат Формат(Значение, "ЧРГ=''; ЧГ=0"); 
	ИначеЕсли Тип = "JSON" Тогда	
		Возврат СформироватьJSON(Значение);
	ИначеЕсли ТипЗначения = Тип("Массив") Тогда
		Возврат Значение;
	Иначе
		Возврат XMLСтрока(Значение); 
	КонецЕсли;
		
КонецФункции

Функция ПолучитьСтруктуруURL(URL)

	СтрокаПроверки = СтрЗаменить(URL,"https://","");
	СтрокаПроверки = СтрЗаменить(СтрокаПроверки,"http://","");
	Поз = СтрНайти(СтрокаПроверки,"/");
	
	Результат = Новый Структура;
	
	Результат.Вставить("Сервер", Лев(СтрокаПроверки,Поз-1));
	Результат.Вставить("АдресРесурса", Сред(СтрокаПроверки,Поз)+1);
	
	Возврат Результат;
	
КонецФункции

Функция ТипОбъекта1СИспользуется(Объект)
	
	Выборка = РегистрыСведений.тг_ДоступныеТипыОбъектов1С.Выбрать(Новый Структура("ТипОбъекта1С",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Объект))));
		
	Возврат Выборка.Следующий();
	
КонецФункции

Функция СсылкаПоНавигационнойСсылке(НавигационнаяСсылка)
	
	ПерваяТочка = СтрНайти(НавигационнаяСсылка, "e1cib/data/");
	Если ПерваяТочка = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;               
	
	ВтораяТочка = СтрНайти(НавигационнаяСсылка, "?ref=");
	ПредставлениеТипа = Сред(НавигационнаяСсылка, ПерваяТочка + 11, ВтораяТочка - ПерваяТочка - 11);
	ШаблонЗначения = ЗначениеВСтрокуВнутр(ПредопределенноеЗначение(ПредставлениеТипа + ".ПустаяСсылка"));
	ЗначениеСсылки = СтрЗаменить(ШаблонЗначения, "00000000000000000000000000000000", Сред(НавигационнаяСсылка, ВтораяТочка + 5));
	
	Возврат ЗначениеИзСтрокиВнутр(ЗначениеСсылки);
	
КонецФункции

#КонецОбласти

#КонецОбласти