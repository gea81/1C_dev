
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получить таблицу типов объектов1 С.
// 
// Параметры:
//  Отборы - Структура,Неопределено - Необязательное
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Получить таблицу типов объектов1 С
Функция ПолучитьТаблицуТиповОбъектов1С(Отборы = Неопределено) Экспорт
	
	Если ТипЗнч(Отборы)<>Тип("Структура") Тогда
		Отборы = Новый Структура;	
	КонецЕсли;
		
	Построитель = Новый ПостроительЗапроса(ТекстЗапроса());
	Построитель.ЗаполнитьНастройки();
	
	Для каждого Отбор Из Отборы Цикл
		
		ТипЗначения = ТипЗнч(Отбор.Значение);
		Поле = Построитель.ДоступныеПоля.Найти(Отбор.Ключ);
		
		Если Поле = Неопределено 
			ИЛИ Поле.ТипЗначения.Типы().Найти(ТипЗначения) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементОтбора = Поле.Отбор.Добавить(Отбор.Ключ);
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.Значение 		= Отбор.Значение;
			
	КонецЦикла;
	
	Построитель.Выполнить();
	
	Возврат Построитель.Результат.Выгрузить();
		
КонецФункции

#КонецОбласти

// Текст запроса.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
Функция ТекстЗапроса()
	Возврат "ВЫБРАТЬ
			|	Элементы.Ссылка КАК ТипОбъекта1С
			|ПОМЕСТИТЬ Вт_Доступные
			|ИЗ
			|	Справочник.ИдентификаторыОбъектовМетаданных КАК Элементы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыОбъектовМетаданных КАК Родители
			|		ПО (Элементы.Родитель = Родители.Ссылка)
			|ГДЕ
			|	Родители.ПолноеИмя = ""Документы""
			|	И ПОДСТРОКА(Элементы.Имя, 1, 7) <> ""удалить""
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	Элементы.Ссылка
			|ИЗ
			|	Справочник.ИдентификаторыОбъектовРасширений КАК Элементы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыОбъектовРасширений КАК Родители
			|		ПО Элементы.Родитель = Родители.Ссылка
			|ГДЕ
			|	Родители.ПолноеИмя = ""Документы""
			|	И ПОДСТРОКА(Элементы.Имя, 1, 7) <> ""удалить""
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	тг_События.ТипОбъекта1С КАК ТипОбъекта1С
			|ПОМЕСТИТЬ Вт_Используемые
			|ИЗ
			|	Справочник.тг_События КАК тг_События
			|
			|СГРУППИРОВАТЬ ПО
			|	тг_События.ТипОбъекта1С
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	тг_ДоступныеТипыОбъектов1С.ТипОбъекта1С КАК ТипОбъекта1С
			|ПОМЕСТИТЬ Вт_Выбранные
			|ИЗ
			|	РегистрСведений.тг_ДоступныеТипыОбъектов1С КАК тг_ДоступныеТипыОбъектов1С
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	НЕ(Вт_Используемые.ТипОбъекта1С ЕСТЬ NULL
			|			И Вт_Выбранные.ТипОбъекта1С ЕСТЬ NULL) КАК Пометка,
			|	Вт_Доступные.ТипОбъекта1С КАК ТипОбъекта1С,
			|	НЕ Вт_Используемые.ТипОбъекта1С ЕСТЬ NULL КАК ТолькоПросмотр
			|ИЗ
			|	Вт_Доступные КАК Вт_Доступные
			|		ЛЕВОЕ СОЕДИНЕНИЕ Вт_Используемые КАК Вт_Используемые
			|		ПО (Вт_Доступные.ТипОбъекта1С = Вт_Используемые.ТипОбъекта1С)
			|		ЛЕВОЕ СОЕДИНЕНИЕ Вт_Выбранные КАК Вт_Выбранные
			|		ПО (Вт_Доступные.ТипОбъекта1С = Вт_Выбранные.ТипОбъекта1С)";	
КонецФункции

#КонецЕсли