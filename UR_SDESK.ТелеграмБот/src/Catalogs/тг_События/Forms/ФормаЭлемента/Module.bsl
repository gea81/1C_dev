 &НаКлиенте
 Перем мОбъект;
 
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	мТипы = РегистрыСведений.тг_ДоступныеТипыОбъектов1С.Выбрать();
	Пока мТипы.Следующий() Цикл
		Элементы.ТипОбъекта.СписокВыбора.Добавить(мТипы.ТипОбъекта1С);	
	КонецЦикла;
		
	ОбъектПриИзмененииНаСервере();
	
	ИзменитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	мОбъект = Объект.ТипОбъекта1С;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ТекущийОбъект.НастройкиОтбора = Новый ХранилищеЗначения(КомпоновщикНастроек.ПолучитьНастройки(), 
										Новый СжатиеДанных(9));
	ТекущийОбъект.ФорматированныйТекст = Новый ХранилищеЗначения(ТекстТелеграм, Новый СжатиеДанных(9));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектПриИзменении(Элемент)
	
	Если мОбъект <> Объект.ТипОбъекта1С Тогда
		мОбъект = Объект.ТипОбъекта1С;
		ОбъектПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКоллекции_Реквизиты

 &НаКлиенте
Процедура РеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Реквизит = Реквизиты.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ЭлементДерева = Реквизиты.НайтиПоИдентификатору(Реквизит.ПолучитьИдентификатор());
	Если ЭлементДерева.ПолучитьЭлементы().Количество() = 0 Тогда
		ДобавитьВТекстСообщенияПараметр();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПеретаскиваемыеОбъекты = ПараметрыПеретаскивания.Значение;
	ТекстДляВставки = "";
	Разделитель = "";
	Для каждого ПеретаскиваемыйОбъект Из ПеретаскиваемыеОбъекты Цикл
		ЭлементДерева = Реквизиты.НайтиПоИдентификатору(ПеретаскиваемыйОбъект);
		Если ЭлементДерева.ПолучитьЭлементы().Количество() = 0 Тогда
			ФорматВывода = ?(ПустаяСтрока(ЭлементДерева.Формат), "", "{" + ЭлементДерева.Формат + "}");
			ТекстДляВставки = ТекстДляВставки + Разделитель + "[" + ЭлементДерева.ПолноеПредставление + ФорматВывода + "]";
			Разделитель = " ";
		КонецЕсли;
	КонецЦикла;
	ПараметрыПеретаскивания.Значение = ТекстДляВставки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаКодовый(Команда)

	Перем НачалоВыделения, КонецВыделения;
	
	Элементы.ТекстТелеграм.ПолучитьГраницыВыделения(НачалоВыделения, КонецВыделения);
   	Строки = ТекстТелеграм.ПолучитьЭлементы(НачалоВыделения, КонецВыделения);
	
	ЦветКодовый 	= тг_ВызовСервера.ЦветКодовый();
	ШрифтКодовый 	= тг_ВызовСервера.ШрифтКодовый();
	
	Для каждого Строка Из Строки Цикл
		Строка.ЦветТекста 	= ЦветКодовый;
		Строка.Шрифт 		= ШрифтКодовый;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьВТекстСообщенияПараметр()
	
	Если Элементы.Реквизиты.ВыделенныеСтроки <> Неопределено Тогда
		Текст = "";
		Для каждого НомерСтроки Из Элементы.Реквизиты.ВыделенныеСтроки Цикл
			НайденнаяСтрока = Реквизиты.НайтиПоИдентификатору(НомерСтроки);
			Если НайденнаяСтрока <> Неопределено Тогда
				ФорматВывода = ?(ПустаяСтрока(НайденнаяСтрока.Формат), "", "{" + НайденнаяСтрока.Формат + "}");
				Текст = Текст + "[" + НайденнаяСтрока.ПолноеПредставление + ФорматВывода + "] ";
			КонецЕсли;
		КонецЦикла;

		Если ПустаяСтрока(Элементы.ТекстТелеграм.ВыделенныйТекст) Тогда
			ЗакладкаДляВставкиНачало = Неопределено;
			ЗакладкаДляВставкиКонец  = Неопределено;
			Элементы.ТекстТелеграм.ПолучитьГраницыВыделения(ЗакладкаДляВставкиНачало, ЗакладкаДляВставкиКонец);
			ТекстТелеграм.Вставить(ЗакладкаДляВставкиКонец, Текст);
		Иначе
			Элементы.ТекстТелеграм.ВыделенныйТекст = Текст;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбъектПриИзмененииНаСервере()
	
	Настройки = ЭтотОбъект().НастройкиОтбора.Получить();
	ТекстТелеграм = ЭтотОбъект().ФорматированныйТекст.Получить(); 
	
	Справочники.тг_События.ИнициализироватьКомпоновщикНастроек(Объект.ТипОбъекта1С, 
			КомпоновщикНастроек, УникальныйИдентификатор, Настройки);
	
	СформироватьСписокРеквизитов();
	
КонецПроцедуры

&НаСервере
Функция ЭтотОбъект()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаСервере
Процедура ИзменитьДоступностьЭлементов()
//TODO: Вставить содержимое обработчика
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокРеквизитов()
		
	СведенияОШаблоне = СведенияОШаблоне(Объект.ТипОбъекта1С);
	
	Реквизиты.ПолучитьЭлементы().Очистить();
	СписокРеквизитов = РеквизитФормыВЗначение("Реквизиты");
	ЗаполнитьДеревоРеквизитов(СписокРеквизитов, СведенияОШаблоне.Реквизиты);
	ЗаполнитьДеревоРеквизитов(СписокРеквизитов, СведенияОШаблоне.ОбщиеРеквизиты, Истина);
	ЗначениеВРеквизитФормы(СписокРеквизитов, "Реквизиты");
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДеревоРеквизитов()
	
	ТипСтрока = Новый ОписаниеТипов("Строка");
	
	Реквизиты = Новый ДеревоЗначений;
	Реквизиты.Колонки.Добавить("Имя"				, ТипСтрока);
	Реквизиты.Колонки.Добавить("Представление"		, ТипСтрока);
	Реквизиты.Колонки.Добавить("Подсказка"			, ТипСтрока);
	Реквизиты.Колонки.Добавить("ПолноеПредставление", ОбщегоНазначения.ОписаниеТипаСтрока(300));
	Реквизиты.Колонки.Добавить("Формат"				, ТипСтрока);
	Реквизиты.Колонки.Добавить("Тип"				, Новый ОписаниеТипов("ОписаниеТипов"));
	
	Возврат Реквизиты;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьДеревоРеквизитов(Приемник, Источник, ЭтоОбщиеИлиПроизвольныеРеквизиты = Неопределено)
	
	Для Каждого СтрокаДерева Из Источник.Строки Цикл
		
		Если ЭтоОбщиеИлиПроизвольныеРеквизиты = Неопределено Тогда
			Если СтрокаДерева.Имя = ШаблоныСообщенийКлиентСервер.ЗаголовокПроизвольныхПараметров()
				ИЛИ СтрокаДерева.Имя = ШаблоныСообщенийСлужебный.ЗаголовокОбщиеРеквизиты() Тогда
				ОбщиеИлиПроизвольныеРеквизиты = Истина;
			Иначе
				
				ОбщиеИлиПроизвольныеРеквизиты = Ложь;
			КонецЕсли;
		Иначе
			ОбщиеИлиПроизвольныеРеквизиты = ЭтоОбщиеИлиПроизвольныеРеквизиты;
		КонецЕсли;
		
		ИндексКартинкиЭлемент = ?(ОбщиеИлиПроизвольныеРеквизиты, 1, 3);
		ИндексКартинкиУзел = ?(ОбщиеИлиПроизвольныеРеквизиты, 0, 2);
		
		НоваяСтрока = Приемник.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДерева);
		
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			НоваяСтрока.ИндексКартинки = ИндексКартинкиУзел;
			ЗаполнитьДеревоРеквизитов(НоваяСтрока, СтрокаДерева, ОбщиеИлиПроизвольныеРеквизиты);
		Иначе
			НоваяСтрока.ИндексКартинки = ИндексКартинкиЭлемент;
		КонецЕсли;
	КонецЦикла;
	Приемник.Строки.Сортировать("Представление", Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СформироватьПолныеПредставления(РеквизитыОбъектаНазначения, Представление = "")
	
	Совпадения = Новый Соответствие;
	Для каждого РеквизитОбъектаНазначения Из РеквизитыОбъектаНазначения Цикл
		ПолноеПредставление = Представление + РеквизитОбъектаНазначения.Представление;
		Если РеквизитОбъектаНазначения.Строки.Количество() > 0 Тогда
			СформироватьПолныеПредставления(РеквизитОбъектаНазначения.Строки, ПолноеПредставление + ".");
		КонецЕсли;
		
		Если Совпадения[ПолноеПредставление] = Неопределено Тогда
			РеквизитОбъектаНазначения.ПолноеПредставление = ПолноеПредставление;
			Совпадения.Вставить(ПолноеПредставление, РеквизитОбъектаНазначения);
		Иначе
			Для ПорядковыйНомер = 1 По 100 Цикл
				ПолноеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"%1.%2 (%3)", Представление, РеквизитОбъектаНазначения.Представление, ПорядковыйНомер);
				Если Совпадения[ПолноеПредставление] = Неопределено Тогда
					РеквизитОбъектаНазначения.ПолноеПредставление = ПолноеПредставление;
					Совпадения.Вставить(ПолноеПредставление, РеквизитОбъектаНазначения);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОШаблоне(Объект)
	
	СведенияОШаблоне = Новый Структура();
    СведенияОШаблоне.Вставить("Реквизиты"		, ОпределитьСписокРеквизитов(Объект));
	СведенияОШаблоне.Вставить("ОбщиеРеквизиты"	, ОпределитьОбщиеРеквизиты());
		
	СформироватьПолныеПредставления(СведенияОШаблоне.Реквизиты.Строки);
	СформироватьПолныеПредставления(СведенияОШаблоне.ОбщиеРеквизиты.Строки);
	
	Возврат СведенияОШаблоне;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОпределитьОбщиеРеквизиты()
	
	ОбщиеРеквизиты = ДеревоРеквизитов();
	
	ОбщиеРеквизитыСтроки = ОбщиеРеквизиты.Строки.Добавить();
	ОбщиеРеквизитыСтроки.Имя 					= НСтр("ru = 'ОбщиеРеквизиты'");
	ОбщиеРеквизитыСтроки.ПолноеПредставление	= НСтр("ru = 'Общие реквизиты'");
	ОбщиеРеквизитыСтроки.Представление			= ОбщиеРеквизитыСтроки.ПолноеПредставление;
	
	ДобавитьОбщийРеквизит(ОбщиеРеквизитыСтроки, "ТекущаяДата"				, 
		НСтр("ru = 'Текущая дата'")				, Новый ОписаниеТипов("Дата"));
	ДобавитьОбщийРеквизит(ОбщиеРеквизитыСтроки, "ЗаголовокСистемы"			, 
		НСтр("ru = 'Заголовок системы'"));
	ДобавитьОбщийРеквизит(ОбщиеРеквизитыСтроки, "АдресБазыВИнтернете"		, 
		НСтр("ru = 'Адрес базы в Интернете'")		, Новый ОписаниеТипов("Строка"));
	ДобавитьОбщийРеквизит(ОбщиеРеквизитыСтроки, "АдресБазыВЛокальнойСети"	, 
		НСтр("ru = 'Адрес базы в локальной сети'"), Новый ОписаниеТипов("Строка"));
	ДобавитьОбщийРеквизит(ОбщиеРеквизитыСтроки, "ТекущийПользователь"		, 
		НСтр("ru = 'Текущий пользователь'")		, Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	
	РеквизитыИскл = "Недействителен,ИдентификаторПользователяИБ,ИдентификаторПользователяСервиса,Подготовлен,Служебный";
	
	МассивПроверяемыхТипов = Новый Массив;
	МассивПроверяемыхТипов.Добавить("ФизическоеЛицо");
	МассивПроверяемыхТипов.Добавить("Подразделение");
	
	Для каждого ПроверяемыйТип Из МассивПроверяемыхТипов Цикл
		
		ОпределяемыйТип = Метаданные.ОпределяемыеТипы.Найти(ПроверяемыйТип);
		Если ОпределяемыйТип <> Неопределено 
			И ОпределяемыйТип.Тип.Типы().Количество() = 1
			И ОпределяемыйТип.Тип.Типы()[0] = Тип("Строка") Тогда
			РеквизитыИскл = РеквизитыИскл + "," + ПроверяемыйТип;			
		КонецЕсли;
		
	КонецЦикла;
		
	РазвернутьРеквизит(ОбщиеРеквизитыСтроки.Имя + ".ТекущийПользователь", ОбщиеРеквизитыСтроки.Строки,, РеквизитыИскл);
	
	Возврат ОбщиеРеквизиты;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьОбщийРеквизит(ОбщиеРеквизиты, Имя, Представление, Тип = Неопределено)
	
	НовыйРеквизит = ОбщиеРеквизиты.Строки.Добавить();
	НовыйРеквизит.Имя 					= ОбщиеРеквизиты.Имя + "." + Имя;
	НовыйРеквизит.Представление 		= Представление;
	НовыйРеквизит.ПолноеПредставление 	= ОбщиеРеквизиты.Представление + "." + Представление;
	НовыйРеквизит.Тип 					=?(Тип = Неопределено, Новый ОписаниеТипов("Строка"), Тип);
	
КонецПроцедуры

// Определить список реквизитов.
// 
// Параметры:
//  Объект - СправочникСсылка.ИдентификаторыОбъектовРасширений, 
//  		 СправочникСсылка.ИдентификаторыОбъектовМетаданных
// 
// Возвращаемое значение:
//  ДеревоЗначений - Определить список реквизитов:
// * Имя - Строка
// * Представление - Строка 
// * Подсказка - Строка 
// * ПолноеПредставление - Строка 
// * Формат - Строка
// * Тип - ОписаниеТипов -
&НаСервереБезКонтекста
Функция ОпределитьСписокРеквизитов(Объект)
	
	Реквизиты = ДеревоРеквизитов();
	
	Если НЕ ЗначениеЗаполнено(Объект) Тогда
		Возврат Реквизиты;
	КонецЕсли;
		
	// Реквизиты
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, "ПолноеИмя, Синоним");
	
	МетаданныеОбъект = Метаданные.НайтиПоПолномуИмени(РеквизитыОбъекта.ПолноеИмя);
	РеквизитыОбъектаНазначения = РеквизитыОбъектаНазначения(Реквизиты, 
		РеквизитыОбъекта.ПолноеИмя, РеквизитыОбъекта.Синоним);
	РазворачиватьСсылочныеРеквизиты = Истина;
		
	Если МетаданныеОбъект <> Неопределено Тогда

		Префикс = МетаданныеОбъект.Имя + ".";

		РеквизитыПоМетаданнымОбъекта(РеквизитыОбъектаНазначения, МетаданныеОбъект, , , Префикс);

		Представление = МетаданныеОбъект.Представление();
		СсылкаНаОбъект = РеквизитыОбъектаНазначения.Добавить();
		СсылкаНаОбъект.Представление 		= НСтр("ru = 'Ссылка на'") + " """ + Представление + """";
		СсылкаНаОбъект.Имя           		= Префикс + "ВнешняяСсылкаНаОбъект";
		СсылкаНаОбъект.Тип  				= Новый ОписаниеТипов("Строка");
		СсылкаНаОбъект.ПолноеПредставление	= Представление + "." + НСтр("ru = 'Ссылка на'") + " """ + Представление
			+ """";

	Иначе
		Префикс 		= РеквизитыОбъекта.ПолноеИмя + ".";
		Представление 	= РеквизитыОбъекта.Синоним;
	КонецЕсли;

	Для Каждого РеквизитОбъектаНазначения Из РеквизитыОбъектаНазначения Цикл
		Если Не СтрНачинаетсяС(РеквизитОбъектаНазначения.Имя, Префикс) Тогда
			РеквизитОбъектаНазначения.Имя = Префикс + РеквизитОбъектаНазначения.Имя;
		КонецЕсли;
		Если РазворачиватьСсылочныеРеквизиты Тогда
			Если РеквизитОбъектаНазначения.Тип.Типы().Количество() = 1 Тогда
				ТипОбъекта = Метаданные.НайтиПоТипу(РеквизитОбъектаНазначения.Тип.Типы()[0]);
				Если ТипОбъекта <> Неопределено И СтрНачинаетсяС(ТипОбъекта.ПолноеИмя(), "Справочник") Тогда
					РазвернутьРеквизит(РеквизитОбъектаНазначения.Имя, РеквизитыОбъектаНазначения);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
	Возврат Реквизиты;
	
КонецФункции

&НаСервереБезКонтекста
Функция РеквизитыОбъектаНазначения(Реквизиты, ПолноеИмяТипаНазначения, Знач Представление = "")
	
	МетаданныеОбъект = Метаданные.НайтиПоПолномуИмени(ПолноеИмяТипаНазначения);
	Если МетаданныеОбъект <> Неопределено Тогда
		ИмяРодителя = МетаданныеОбъект.Имя;
		Представление = ?(ЗначениеЗаполнено(Представление), Представление, МетаданныеОбъект.Представление());
	Иначе
		ИмяРодителя = ПолноеИмяТипаНазначения;
		Представление = ?(ЗначениеЗаполнено(Представление), Представление, ПолноеИмяТипаНазначения);
	КонецЕсли;
	
	УзелРеквизитовОбъектаНазначения = Реквизиты.Строки.Найти(ИмяРодителя, "Имя");
	Если УзелРеквизитовОбъектаНазначения = Неопределено Тогда
		УзелРеквизитовОбъектаНазначения = Реквизиты.Строки.Добавить();
		УзелРеквизитовОбъектаНазначения.Имя = ИмяРодителя;
		УзелРеквизитовОбъектаНазначения.Представление = Представление;
		УзелРеквизитовОбъектаНазначения.ПолноеПредставление = Представление;
	КонецЕсли;
	
	Возврат УзелРеквизитовОбъектаНазначения.Строки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура РеквизитыПоМетаданнымОбъекта(Реквизиты, МетаданныеОбъект, СписокРеквизитов = "", ИсключаяРеквизиты = "", Префикс = "")
	
	СведенияОСпискеРеквизитов = Новый Структура("СписокРеквизитов, СписокСодержитДанные");
	СведенияОСпискеРеквизитов.СписокРеквизитов     = СтрРазделить(ВРег(СписокРеквизитов), ",", Ложь);
	СведенияОСпискеРеквизитов.СписокСодержитДанные = (СведенияОСпискеРеквизитов.СписокРеквизитов.Количество() > 0);
	
	СведенияОИсключаемыхРеквизитах = Новый Структура("СписокРеквизитов, СписокСодержитДанные");
	СведенияОИсключаемыхРеквизитах.СписокРеквизитов = СтрРазделить(ВРег(ИсключаяРеквизиты), ",", Ложь);
	СведенияОИсключаемыхРеквизитах.СписокСодержитДанные = (СведенияОИсключаемыхРеквизитах.СписокРеквизитов.Количество() > 0);
	
	Если ТипЗнч(МетаданныеОбъект) = Тип("ОбъектМетаданных") И НЕ ОбщегоНазначения.ЭтоПеречисление(МетаданныеОбъект) Тогда
		Для каждого Реквизит Из МетаданныеОбъект.Реквизиты Цикл
			Если НЕ СтрНачинаетсяС(Реквизит.Имя, "Удалить") Тогда
				Если Реквизит.Тип.Типы().Количество() = 1 И Реквизит.Тип.Типы()[0] = Тип("ХранилищеЗначения") Тогда
					Продолжить;
				КонецЕсли;
				
				ДобавитьРеквизитПоМетаданнымОбъекта(Реквизиты, Реквизит, Префикс, 
					СведенияОСпискеРеквизитов, СведенияОИсключаемыхРеквизитах);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СкрываемыеСтандартныеРеквизиты(СведенияОИсключаемыхРеквизитах.СписокРеквизитов);
	СведенияОИсключаемыхРеквизитах.СписокСодержитДанные = Истина;
	Для каждого Реквизит Из МетаданныеОбъект.СтандартныеРеквизиты Цикл
		ДобавитьРеквизитПоМетаданнымОбъекта(Реквизиты, Реквизит, Префикс, 
			СведенияОСпискеРеквизитов, СведенияОИсключаемыхРеквизитах);
	КонецЦикла;
	
	Если НЕ ОбщегоНазначения.ЭтоПеречисление(МетаданныеОбъект) Тогда
		ДобавитьРеквизитыСвойств(МетаданныеОбъект, Префикс, Реквизиты, 
			СведенияОИсключаемыхРеквизитах, СведенияОСпискеРеквизитов);
		ДобавитьРеквизитыКонтактнойИнформации(МетаданныеОбъект, Префикс, Реквизиты, 
			СведенияОИсключаемыхРеквизитах, СведенияОСпискеРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьРеквизитыСвойств(МетаданныеОбъект, Префикс, Реквизиты, 
			СведенияОИсключаемыхРеквизитах, СведенияОСпискеРеквизитов)
	
	Свойства = Новый Массив;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		ПустаяСсылка = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеОбъект.ПолноеИмя()).ПустаяСсылка();
		ПолучатьДопСведения = МодульУправлениеСвойствами.ИспользоватьДопСведения(ПустаяСсылка);
		ПолучатьДопРеквизиты = МодульУправлениеСвойствами.ИспользоватьДопРеквизиты(ПустаяСсылка);
		
		Если ПолучатьДопРеквизиты Или ПолучатьДопСведения Тогда
			Свойства = МодульУправлениеСвойствами.СвойстваОбъекта(ПустаяСсылка, ПолучатьДопРеквизиты, ПолучатьДопСведения);
			Для каждого Свойство Из Свойства Цикл
				ДобавитьРеквизитПоМетаданнымОбъекта(Реквизиты, Свойство, Префикс, 
					СведенияОСпискеРеквизитов, СведенияОИсключаемыхРеквизитах);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьРеквизитыКонтактнойИнформации(МетаданныеОбъект, Префикс, Реквизиты, 
			СведенияОИсключаемыхРеквизитах, СведенияОСпискеРеквизитов)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Ссылка = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеОбъект.ПолноеИмя()).ПустаяСсылка();
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		ВидыКонтактнойИнформацией = МодульУправлениеКонтактнойИнформацией.ВидыКонтактнойИнформацииОбъекта(Ссылка);
		Если ВидыКонтактнойИнформацией.Количество() > 0 Тогда
			Для каждого ВидКонтактнойИнформацией Из ВидыКонтактнойИнформацией Цикл
				ДобавитьРеквизитПоМетаданнымОбъекта(Реквизиты, ВидКонтактнойИнформацией.Ссылка, Префикс, 
					СведенияОСпискеРеквизитов, СведенияОИсключаемыхРеквизитах);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Добавить реквизит по метаданным объекта.
// 
// Параметры:
//  Реквизиты - КоллекцияСтрокДереваЗначений - Реквизиты
//  Реквизит - ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения, Произвольный, СправочникСсылка.ВидыКонтактнойИнформации - Реквизит
//  Префикс - Строка - Префикс
//  СведенияОСпискеРеквизитов - Структура - Сведения о списке реквизитов:
// * СписокРеквизитов - Строка 
// * СписокСодержитДанные - Булево
//  СведенияОИсключаемыхРеквизитах - Структура - Сведения о исключаемых реквизитах:
// * СписокРеквизитов - Строка
// * СписокСодержитДанные - Булево
&НаСервереБезКонтекста
Процедура ДобавитьРеквизитПоМетаданнымОбъекта(Реквизиты, Реквизит, Префикс, 
			СведенияОСпискеРеквизитов, СведенияОИсключаемыхРеквизитах)
	
	ИмяРеквизита = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		Если ТипЗнч(Реквизит) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения") Тогда
			ЗначенияСвойство = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Реквизит, 
				"ИдентификаторДляФормул, ТипЗначения, ФорматСвойства");
			ИмяРеквизита   = "~Свойство." + ЗначенияСвойство.ИдентификаторДляФормул;
			Представление = Строка(Реквизит);
			Тип           = ЗначенияСвойство.ТипЗначения;
			Формат        = ЗначенияСвойство.ФорматСвойства;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Если ТипЗнч(Реквизит) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
			ИдентификаторДляФормул = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизит, "ИдентификаторДляФормул");
			ИмяРеквизита  =  "~КИ." + ИдентификаторДляФормул;
			Представление = Строка(Реквизит);
			Тип           = Новый ОписаниеТипов("Строка");
			Формат        = "";
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяРеквизита = Неопределено Тогда
		ИмяРеквизита  = Реквизит.Имя;
		Представление = Реквизит.Представление();
		Тип           = Реквизит.Тип;
		Формат        = Реквизит.Формат;
	КонецЕсли;
	
	Если СведенияОСпискеРеквизитов.СписокСодержитДанные
		И СведенияОСпискеРеквизитов.СписокРеквизитов.Найти(ВРег(СокрЛП(ИмяРеквизита))) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОИсключаемыхРеквизитах.СписокСодержитДанные
		И СведенияОИсключаемыхРеквизитах.СписокРеквизитов.Найти(ВРег(СокрЛП(ИмяРеквизита))) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйСтрока = Реквизиты.Добавить();
	НовыйСтрока.Имя           = Префикс + ИмяРеквизита;
	НовыйСтрока.Представление = Представление;
	НовыйСтрока.Тип           = Тип;
	НовыйСтрока.Формат        = Формат;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СкрываемыеСтандартныеРеквизиты(Массив)
	
	ДобавитьВМассивУникальноеЗначение(Массив, "ПометкаУдаления");
	ДобавитьВМассивУникальноеЗначение(Массив, "Проведен");
	ДобавитьВМассивУникальноеЗначение(Массив, "Ссылка");
	ДобавитьВМассивУникальноеЗначение(Массив, "Предопределенный");
	ДобавитьВМассивУникальноеЗначение(Массив, "ИмяПредопределенныхДанных");
	ДобавитьВМассивУникальноеЗначение(Массив, "ЭтоГруппа");
	ДобавитьВМассивУникальноеЗначение(Массив, "Родитель");
	ДобавитьВМассивУникальноеЗначение(Массив, "Владелец");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазвернутьРеквизит(Знач Имя, Узел, СписокРеквизитов = "", ИсключаяРеквизиты = "")
	
	Реквизит = Узел.Найти(Имя, "Имя", Ложь);
	Если Реквизит <> Неопределено Тогда
		РазвернутьРеквизитПоМетаданнымОбъекта(Реквизит, СписокРеквизитов, ИсключаяРеквизиты, Имя);
	Иначе
		Имя = Узел.Родитель.Имя + "." + Имя;
		Реквизит = Узел.Найти(Имя, "Имя", Ложь);
		Если СтрЧислоВхождений(Имя, ".") > 1 Тогда
			Возврат Реквизит.Строки;
		КонецЕсли;
		
		Если Реквизит <> Неопределено Тогда
			РазвернутьРеквизитПоМетаданнымОбъекта(Реквизит, СписокРеквизитов, ИсключаяРеквизиты, Имя);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Реквизит.Строки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура РазвернутьРеквизитПоМетаданнымОбъекта(Реквизит, СписокРеквизитов, ИсключаяРеквизиты, Знач Префикс)
	
	Если ТипЗнч(Реквизит.Тип) = Тип("ОписаниеТипов") Тогда
		УзелРеквизитов = Реквизит.Строки;
		Префикс = Префикс + ?(Прав(Префикс, 1) <> ".", ".", "");
		Для каждого Тип Из Реквизит.Тип.Типы() Цикл
			МетаданныеОбъект = Метаданные.НайтиПоТипу(Тип);
			Если МетаданныеОбъект <> Неопределено Тогда
				РеквизитыПоМетаданнымОбъекта(УзелРеквизитов, МетаданныеОбъект, СписокРеквизитов, ИсключаяРеквизиты, Префикс);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьВМассивУникальноеЗначение(Массив, Значение)
	Если Массив.Найти(Значение) = Неопределено Тогда
		Массив.Добавить(ВРег(Значение));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти