&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПараметрыСоединения = Справочники.scmВнешниеСервисы_ПараметрыСоединения.bot_01;
	ПараметрыСоединенияПриИзмененииНаСервере();
	scmИспользоватьТелеграмБоты = Константы.scmИспользоватьТелеграмБоты.Получить();
	РЗ = РегламентныеЗадания.НайтиПредопределенное("scmОбработкаСообщенийЧатБота");
	scmОбработкаСообщенийЧатБота = РЗ.Использование;	
	ПостроитьТаблицуПереходовНаСервере();
	scmПодключитьОбработчикОжиданияИнтервал = 5;
//	СхемаПереходов = ПостроитьСхемуНаСервере();
	Элементы.СписокСостоянияБота.СписокВыбора.ЗагрузитьЗначения(scmHTTPCервисыOpenAPIПовтИсп.МассивСостоянияБота());
	//ТаблицаПереходовОтражение = Обработки.scmОбработкаТелеграмБот.ПолучитьМакет("ТаблицаПереходов");
	ТаблицаПереходов.Загрузить(Обработки.scmОбработкаТелеграмБот.ТаблицаПереходов_ТелеграмБот());
КонецПроцедуры

&НаСервере
Процедура ПараметрыСоединенияПриИзмененииНаСервере()
	кешНастройкиОтладки = scmОбщегоНазначенияПовтИсп.ПараметрыСоединения(ПараметрыСоединения);	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыСоединенияПриИзменении(Элемент)
	ПараметрыСоединенияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Обработать_getUpdates(Команда)
	Обработать_getUpdatesНаСервере();
КонецПроцедуры

&НаСервере
Процедура Обработать_getUpdatesНаСервере()
	Обработки.scmОбработкаТелеграмБот.Обработать_getUpdatesНаСервере(ПараметрыСоединения, RequestBodyJSON, Bot_AnswerJSON, RespondBodyJSON);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистрОчередьЗапросов(Команда)
	стрОтбор = Новый Структура("ПараметрыСоединения", ПараметрыСоединения);	
	ПараметрыФормы = Новый Структура("Отбор", стрОтбор);
	Форма = ПолучитьФорму("РегистрСведений.scmОчередьЗапросовЧатБота.ФормаСписка", ПараметрыФормы);
	Форма.Открыть();
КонецПроцедуры

&НаСервере
Процедура scmИспользоватьТелеграмБотыПриИзмененииНаСервере()
	Константы.scmИспользоватьТелеграмБоты.Установить(scmИспользоватьТелеграмБоты);
КонецПроцедуры

&НаКлиенте
Процедура scmИспользоватьТелеграмБотыПриИзменении(Элемент)
	scmИспользоватьТелеграмБотыПриИзмененииНаСервере();
КонецПроцедуры

//&НаСервере
//Процедура scmОбработкаСообщенийЧатБотаПриИзмененииНаСервере()
//	РЗ = РегламентныеЗадания.НайтиПредопределенное("scmОбработкаСообщенийЧатБота");
//	РЗ.Использование = scmОбработкаСообщенийЧатБота;
//	РЗ.Записать();
//КонецПроцедуры

//&НаКлиенте
//Процедура scmОбработкаСообщенийЧатБотаПриИзменении(Элемент)
//	scmОбработкаСообщенийЧатБотаПриИзмененииНаСервере();
//КонецПроцедуры

&НаСервере
Процедура ПостроитьТаблицуПереходовНаСервере()
	ЗначениеВРеквизитФормы(Обработки.scmОбработкаТелеграмБот.ТаблицаПереходов_ТелеграмБот(), "ТаблицаПереходов");
КонецПроцедуры

&НаСервере
Функция ПостроитьСхемуНаСервере()
	
	Обработка = РеквизитФормыВЗначение("Объект");
	СтруктураСхемы = Обработка.ИнициализироватьСтруктуру();
	
	ТТ = Обработки.scmОбработкаТелеграмБот.ТаблицаПереходов_ТелеграмБот();
	мСостояний = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ТТ.выгрузитьКолонку("СледующееСостояние"));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(мСостояний, ТТ.выгрузитьКолонку("ТекущееСостояние"), Истина);
	мСостояний.Удалить(мСостояний.Найти(scmHTTPCервисыOpenAPIПовтИсп.СостоянияБота().Неопределено));
	мДействий1 = Новый Массив;
	Для Каждого м Из мСостояний Цикл
		//костыли расположения
		Если Строка(м) = "Поиск документов" Тогда 
			Позиция = Новый Структура("Верх,Лево", 100, 200);
		ИначеЕсли Строка(м) = "Поиск номенклатуры" Тогда 
			Позиция = Новый Структура("Верх,Лево", 200, 10);
		ИначеЕсли Строка(м) = "Документ выбран" Тогда 
			Позиция = Новый Структура("Верх,Лево", 200, 300);
		ИначеЕсли Строка(м) = "Документ изменения подтверждение" Тогда 
			Позиция = Новый Структура("Верх,Лево", 300, 300);
		ИначеЕсли Строка(м) = "Документ изменения приняты" Тогда 
			Позиция = Новый Структура("Верх,Лево", 400, 300);
		ИначеЕсли Строка(м) = "Файл документа загрузка" Тогда 
			Позиция = Новый Структура("Верх,Лево", 200, 500);
		ИначеЕсли Строка(м) = "Файл документа загрузка подтверждение" Тогда 
			Позиция = Новый Структура("Верх,Лево", 300, 500);
		ИначеЕсли Строка(м) = "Старт" Тогда 
			Позиция = Новый Структура("Верх,Лево", 100, 10);
		ИначеЕсли Строка(м) = "Стоп" Тогда 
			Позиция = Новый Структура("Верх,Лево", 10, 10);
		Иначе
			Позиция = Неопределено;
		КонецЕсли;
		//костыли расположения
		мДействий1.Добавить(Обработка.ДобавитьДействие(СтруктураСхемы,, Строка(м),,Позиция))
	КонецЦикла;
	
	Для Каждого д1 Из мДействий1 Цикл
		Для Каждого т Из ТТ Цикл
			Если Строка(т.СледующееСостояние) = д1.Заголовок Тогда            
				ИсходныеСостояния = НайтиИсходныеСостояния(ТТ, мДействий1,  т.ТекущееСостояние, т.СледующееСостояние);
				Для Каждого д0 Из ИсходныеСостояния Цикл  
					//+++вычисление действий
					Обработчик = "";
					Ошибки = Новый Массив;
					Действия = Неопределено;
					Отказ = Ложь;
					ТекущееСостояние = т.ТекущееСостояние;
					СледующееСостояние = т.СледующееСостояние;
					//Попытка
					//	Выполнить("Действия = " + т.Действие);
					//	Если Действия <> Неопределено Тогда 
					//		Для Каждого д Из Действия Цикл 
					//			Обработчик = Обработчик + д.Действие;	
					//		КонецЦикла;	
					//	КонецЕсли;	
					//Исключение
						Обработчик = т.Действие;//"<>"	
					//КонецПопытки;	
					//---вычисление действий
					Обработка.СвязатьЭлементы(СтруктураСхемы, д0, д1, 4, 2, ?(Отказ,"Отказ","") + Обработчик); //д0.Заголовок д1.Заголовок
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;
	КонецЦикла;
	
	Возврат Обработка.ПостроитьСхему(СтруктураСхемы);
	
КонецФункции

Функция НайтиИсходныеСостояния(ТТ, мДействий, ТекущееСостояние, СледующееСостояние)
	мДействий0 = Новый Массив;
	Для Каждого Действие Из мДействий Цикл
		Для Каждого т Из ТТ Цикл
			Если Строка(т.ТекущееСостояние) = Действие.Заголовок И т.ТекущееСостояние = ТекущееСостояние И т.СледующееСостояние = СледующееСостояние Тогда 
				мДействий0.Добавить(Действие);
			КонецЕсли;	
		КонецЦикла;
	КонецЦикла;
	Возврат мДействий0;
КонецФункции

&НаКлиенте
Процедура ОбработчикОжидания() Экспорт
	Обработать_getUpdatesНаСервере();
	//ОбработчикОжиданияНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура scmПодключитьОбработчикОжиданияПриИзменении(Элемент)
	Элементы.ОбработатьВходящиеСообщения.Доступность = Не scmПодключитьОбработчикОжидания;
	Если scmПодключитьОбработчикОжидания Тогда 
		ПодключитьОбработчикОжидания("ОбработчикОжидания", scmПодключитьОбработчикОжиданияИнтервал);
	Иначе 
		ОтключитьОбработчикОжидания("ОбработчикОжидания");
	КонецЕсли;	
КонецПроцедуры
