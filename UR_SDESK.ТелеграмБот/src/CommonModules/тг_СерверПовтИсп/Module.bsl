#Область ПрограммныйИнтерфейс

// Получить правило метода телеграм.
// 
// Параметры:
//  ИмяМетода - Строка - Объект телеграм
// 
// Возвращаемое значение:
//  Структура - Получить правило метода телеграм:
// 		* Метод - Строка - Метод API Telegram
// 		* Поля - Массив из Структура - Массив полей
//
Функция ПолучитьПравилоМетода(ИмяМетода) Экспорт
	
	ДоступныеМетоды = тг_СерверПовтИсп.ДоступныеМетоды();
	ДанныеМетода = ДоступныеМетоды.Получить(ИмяМетода);

	Если ДанныеМетода = Неопределено Тогда
		Возврат ПолучитьОписаниеМетода();
	Иначе
		Возврат ДанныеМетода;
	КонецЕсли;
	
КонецФункции

// Типы чатов.
// Type of chat, can be either “private”, “group”, “supergroup” or “channel”
// см. https://core.telegram.org/bots/api#chat
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение - Типы чатов
Функция ТипыЧатов() Экспорт
	
	ТипыЧатов = Новый Соответствие;
	ТипыЧатов.Вставить("private"	, Перечисления.тг_ТипыОбъектов.Пользователь);
	ТипыЧатов.Вставить("group"		, Перечисления.тг_ТипыОбъектов.Группа);
	ТипыЧатов.Вставить("supergroup"	, Перечисления.тг_ТипыОбъектов.ГруппаКанала);
	ТипыЧатов.Вставить("channel"	, Перечисления.тг_ТипыОбъектов.Канал);
	
	Возврат ТипыЧатов;
	
КонецФункции

Функция ТипыИзображения() Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить("image/gif"					, Истина);
	Результат.Вставить("image/jpeg"					, Истина);
	Результат.Вставить("image/pjpeg"				, Истина);
	Результат.Вставить("image/png"					, Истина);
	Результат.Вставить("image/svg+xml"				, Истина);
	Результат.Вставить("image/tiff"					, Истина);
	Результат.Вставить("image/vnd.microsoft.icon"	, Истина);
	Результат.Вставить("image/vnd.wap.wbmp"			, Истина);
	Результат.Вставить("image/webp"					, Истина);

	Возврат Результат;
	
КонецФункции

Функция ТипыАудио() Экспорт
	
	Результат = Новый Соответствие;

	Возврат Результат;
	
КонецФункции

Функция ПолучитьБотаСВ() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	ИдентификаторБота = ХранилищеОбщихНастроек.Загрузить("СД_БотТелеграм",,,"ВсеПользователи");
	
	Если ИдентификаторБота = Неопределено Тогда
		
		СвойстваБота = Новый Структура;
		СвойстваБота.Вставить("Имя"			,"СД_БотТелеграм");
		СвойстваБота.Вставить("Картинка"	, БиблиотекаКартинок.ПользовательБезФотографии);
		СвойстваБота.Вставить("ПолноеИмя"	, "Бот телеграм");
		СвойстваБота.Вставить("Внешний"		, Истина);
		
		Бот = СистемаВзаимодействия.СоздатьПользователя();
		ЗаполнитьЗначенияСвойств(Бот,СвойстваБота);
		Бот.Записать();
		
		ИдентификаторБота = Бот.Идентификатор;
		
		ХранилищеОбщихНастроек.Сохранить("СД_БотТелеграм",,ИдентификаторБота,,"ВсеПользователи");
		
	КонецЕсли;

	Возврат СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторБота);
	
КонецФункции

Функция ЦветКодовый() Экспорт
	Возврат Новый Цвет(28,85,174);	
КонецФункции

Функция ШрифтКодовый() Экспорт
	Возврат Новый Шрифт(,,,,,,80);	
КонецФункции 

// Доступные методы.
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение - Доступные методы
//
Функция ДоступныеМетоды() Экспорт
	
	Результат = Новый Соответствие;

	Результат.Вставить("Бот_Инфо"			, Бот_Инфо());

	Результат.Вставить("Сообщение_Отправить", Сообщение_Отправить());
	Результат.Вставить("Сообщение_Обновить"	, Сообщение_Обновить());
	Результат.Вставить("Сообщение_Удалить"	, Сообщение_Удалить());

	Результат.Вставить("Вебхук_Инфо"		, Вебхук_Инфо());
	Результат.Вставить("Вебхук_Установить"	, Вебхук_Установить());
	Результат.Вставить("Вебхук_Удалить"		, Вебхук_Удалить());
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получить описание метода.
// Возвращаемое значение:
//	Структура - Получить описание метода:
// 		* Метод - Строка - Метод API Telegram
// 		* Поля 	- Массив из Структура - Массив полей
//
Функция ПолучитьОписаниеМетода()

	Результат = Новый Структура;
	Результат.Вставить("Метод"	, "");
	Результат.Вставить("Поля"	, Новый Массив);

	Возврат Результат;
		
КонецФункции

// Получить поля метода telegram.
// 
// Возвращаемое значение:
// 	Структура - Получить поле:
// 		* Имя 			- Строка 		- Программное имя
// 		* Параметр 		- Строка 		- Имя параметра telegram
// 		* Тип 			- Строка 		- Тип строкой
// 		* Значение  	- Неопределено 	- Значение по умолчанию
// 		* Обязательный 	- Булево 		- 
//
Функция ПолучитьПоле()
	
	Результат = Новый Структура;
	Результат.Вставить("Имя"			, "");
	Результат.Вставить("Параметр"		, "");
	Результат.Вставить("Тип"			, "Строка");
	Результат.Вставить("Значение"		, Неопределено);
	Результат.Вставить("Обязательный"	, Ложь);
	
	Возврат Результат;
			
КонецФункции

#Область ОписаниеМетодов

#Область РаботаССообщениями

// Описание метода "Отправить сообщение".
// См. https://core.telegram.org/bots/api#sendmessage
//
// Возвращаемое значение:
//		Структура - см. ПолучитьОписаниеМетода()
//
Функция Сообщение_Отправить()

	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "sendMessage";
		
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "Текст";
	Поле.Параметр 		= "text";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Формат";
	Поле.Параметр 		= "parse_mode";
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Сущности";
	Поле.Параметр 		= "entities";
	Поле.Тип			= "JSON";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ПросмотрСсылок";
	Поле.Параметр 		= "disable_web_page_preview";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Оповещение";
	Поле.Значение		= Истина;
	Поле.Параметр 		= "disable_notification";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдПересылаемогоСообщения";
	Поле.Параметр 		= "reply_to_message_id";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ПересылаемоеСообщениеОтправлятьВсегда";
	Поле.Параметр 		= "allow_sending_without_reply";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Защита";
	Поле.Параметр 		= "protect_content";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Клавиатура";
	Поле.Параметр 		= "reply_markup";
	Поле.Тип			= "JSON";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Возврат ОписаниеМетода;
	
КонецФункции

// Описание метода "Обновить сообщение".
// См. https://core.telegram.org/bots/api#editmessagetext
//
// Возвращаемое значение:
//		Структура - см. ПолучитьОписаниеМетода()
//
Функция Сообщение_Обновить()

	ОписаниеМетода = ПолучитьОписаниеМетода();

	ОписаниеМетода.Метод = "editMessageText";
		
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдСообщения";
	Поле.Параметр 		= "message_id";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Текст";
	Поле.Параметр 		= "text";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдВстроенногоСообщения";
	Поле.Параметр 		= "inline_message_id";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Формат";
	Поле.Параметр 		= "parse_mode";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Сущности";
	Поле.Параметр 		= "entities";
	Поле.Тип			= "JSON";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ПросмотрСсылок";
	Поле.Параметр 		= "disable_web_page_preview";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "Клавиатура";
	Поле.Параметр 		= "reply_markup";
	Поле.Тип			= "JSON";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Возврат ОписаниеМетода;
	
КонецФункции

// Описание метода "Удалить сообщение".
// См. https://core.telegram.org/bots/api#deleteMessage
//
// Возвращаемое значение:
//		Структура - см. ПолучитьОписаниеМетода()
//
Функция Сообщение_Удалить()

	ОписаниеМетода = ПолучитьОписаниеМетода();

	ОписаниеМетода.Метод = "deleteMessage";
		
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдСообщения";
	Поле.Параметр 		= "message_id";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Возврат ОписаниеМетода;
	
КонецФункции

#КонецОбласти

#Область РаботаСВебхуком

// Описание метода "Информация о вебхуке".
// См. https://core.telegram.org/bots/api#getWebhookInfo
//
// Возвращаемое значение:
//		Структура - см. ПолучитьОписаниеМетода()
//
Функция Вебхук_Инфо()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "getWebhookInfo";
	
	Возврат ОписаниеМетода;
	
КонецФункции

// Описание метода "Информация о вебхуке".
// См. https://core.telegram.org/bots/api#setWebhook
//
// Возвращаемое значение:
//		Структура - см. ПолучитьОписаниеМетода()
//
Функция Вебхук_Установить()

	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "setWebhook";

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Адрес";
	Поле.Параметр 		= "url";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Сертификат";
	Поле.Параметр 		= "certificate";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "IPАдрес";
	Поле.Параметр 		= "ip_address";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "МаксСоединений";
	Поле.Параметр 		= "max_connections";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "СписокСобытий";
	Поле.Параметр 		= "allowed_updates";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "УдалитьСобытия";
	Поле.Параметр 		= "drop_pending_updates";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Возврат ОписаниеМетода;
	
КонецФункции

// Описание метода "Информация о вебхуке".
// См. https://core.telegram.org/bots/api#deleteWebhook
//
// Возвращаемое значение:
//		Структура - см. ПолучитьОписаниеМетода()
//
Функция Вебхук_Удалить()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "deleteWebhook";

	Поле = ПолучитьПоле();
	Поле.Имя 			= "УдалитьСобытия";
	Поле.Параметр 		= "drop_pending_updates";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Возврат ОписаниеМетода;
	
КонецФункции

#КонецОбласти

// Описание метода "Данные бота".
// См. https://core.telegram.org/bots/api#getme
//
// Возвращаемое значение:
//		Структура - см. ПолучитьОписаниеМетода()
//
Функция Бот_Инфо()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	ОписаниеМетода.Метод = "getMe";
	
	Возврат ОписаниеМетода;
	   
КонецФункции

#КонецОбласти


Функция Чат_ДанныеПользователя()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "getChatMember";
	   
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдПользователя";
	Поле.Параметр 		= "user_id";
	ОписаниеМетода.Поля.Добавить(Поле);

	Возврат ОписаниеМетода;

КонецФункции

Функция Чат_Инфо()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "getChat";
	   
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	Поле.Обязательный	= Истина;
	ОписаниеМетода.Поля.Добавить(Поле);

	Возврат ОписаниеМетода;

КонецФункции

Функция Чат_УстановитьЗаголовок()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "setChatTitle";
	   
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	Поле.Обязательный	= Истина;
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Заголовок";
	Поле.Параметр 		= "title";
	Поле.Обязательный	= Истина;
	ОписаниеМетода.Поля.Добавить(Поле);

	Возврат ОписаниеМетода;
	
КонецФункции

Функция Чат_УстановитьОписание()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "setChatDescription";
	   
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	Поле.Обязательный	= Истина;
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Описание";
	Поле.Параметр 		= "description";
	Поле.Обязательный	= Истина;
	ОписаниеМетода.Поля.Добавить(Поле);

	Возврат ОписаниеМетода;
	
КонецФункции

Функция Сообщение_ОтправитьИзображение()

	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "sendPhoto";
		
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Фото";
	Поле.Параметр 		= "photo";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Подпись";
	Поле.Параметр 		= "caption";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Формат";
	Поле.Параметр 		= "parse_mode";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Сущности";
	Поле.Параметр 		= "caption_entities";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Оповещение";
	Поле.Параметр 		= "disable_notification";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдПересылаемогоСообщения";
	Поле.Параметр 		= "reply_to_message_id";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ПересылаемоеСообщение_ОтправлятьВсегда";
	Поле.Параметр 		= "allow_sending_without_reply";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "Клавиатура";
	Поле.Параметр 		= "reply_markup";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
КонецФункции

Функция Сообщение_ОтправитьАудио()

	ОписаниеМетода = ПолучитьОписаниеМетода();

	ОписаниеМетода.Метод = "sendAudio";
		
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Фото";
	Поле.Параметр 		= "photo";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Подпись";
	Поле.Параметр 		= "caption";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Формат";
	Поле.Параметр 		= "parse_mode";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Сущности";
	Поле.Параметр 		= "caption_entities";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Оповещение";
	Поле.Параметр 		= "disable_notification";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдПересылаемогоСообщения";
	Поле.Параметр 		= "reply_to_message_id";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ПересылаемоеСообщение_ОтправлятьВсегда";
	Поле.Параметр 		= "allow_sending_without_reply";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "Клавиатура";
	Поле.Параметр 		= "reply_markup";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
КонецФункции

Функция Сообщение_ОтправитьФайл()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "sendDocument";
		
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";
	Поле.Обязательный	= Истина;
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Фото";
	Поле.Параметр 		= "photo";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Подпись";
	Поле.Параметр 		= "caption";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Формат";
	Поле.Параметр 		= "parse_mode";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Сущности";
	Поле.Параметр 		= "caption_entities";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Оповещение";
	Поле.Параметр 		= "disable_notification";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдПересылаемогоСообщения";
	Поле.Параметр 		= "reply_to_message_id";
	
	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ПересылаемоеСообщение_ОтправлятьВсегда";
	Поле.Параметр 		= "allow_sending_without_reply";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Поле = ПолучитьПоле();
	Поле.Имя 			= "Клавиатура";
	Поле.Параметр 		= "reply_markup";
	
	ОписаниеМетода.Поля.Добавить(Поле);
	
КонецФункции

Функция ПолучитьФайлТелеграм()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "getFile";
	   
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдФайла";
	Поле.Параметр 		= "file_id";
	Поле.Обязательный	= Истина;
	ОписаниеМетода.Поля.Добавить(Поле);
	
	Возврат ОписаниеМетода;
	
КонецФункции

Функция Сообщение_ИзменитьПодпись()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "editMessageCaption";
	   
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";

	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдСообщения";
	Поле.Параметр 		= "message_id";

	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдВстоенногоСообщения";
	Поле.Параметр 		= "inline_message_id";

	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Подпись";
	Поле.Параметр 		= "caption";

	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Формат";
	Поле.Параметр 		= "parse_mode";

	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Сущности";
	Поле.Параметр 		= "caption_entities";

	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Клавиатура";
	Поле.Параметр 		= "reply_markup";
   	Поле.Тип			= "JSON";

	ОписаниеМетода.Поля.Добавить(Поле);

КонецФункции

Функция Чат_УстановитьНазваниеАдминистратора()
	
	ОписаниеМетода = ПолучитьОписаниеМетода();
	
	ОписаниеМетода.Метод = "setChatAdministratorCustomTitle";
	   
	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдЧата";
	Поле.Параметр 		= "chat_id";

	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "ИдПользователя";
	Поле.Параметр 		= "user_id";

	ОписаниеМетода.Поля.Добавить(Поле);

	Поле = ПолучитьПоле();
	Поле.Имя 			= "Название";
	Поле.Параметр 		= "custom_title";

	ОписаниеМетода.Поля.Добавить(Поле);

КонецФункции

#КонецОбласти