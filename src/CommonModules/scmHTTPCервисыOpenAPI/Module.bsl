#Область СлужебныйПрограммныйИнтерфейс

// Подготавливает структуру ПараметровЗапроса. Структура (опционально) содержит блоки parameters, requestBody, respondBody
//
// Параметры:
//  Запрос				 - HTTPЗапрос - входящий запрос
//  ОпределениеМетода	 - Структура - описание метода найденное функцией ОпределенияМетодов()
// 
// Возвращаемое значение:
// Структура  - подготовленная структура, в которую будет десериализован запрос и помещен ответ
//
Функция ПараметрыМетодаИзЗапроса(Запрос, ОпределениеМетода) Экспорт
	
	ПараметрыЗапроса = Новый Структура;      	
	Для Каждого Параметр Из ОпределениеМетода Цикл 
		Если Параметр.Ключ = "methodtype" ИЛИ Параметр.Ключ = "description" ИЛИ Параметр.Ключ = "pattern" ИЛИ Параметр.Ключ = "patternConvertFunction" Тогда 
			Продолжить;	
		КонецЕсли;	
		Для Каждого Описание Из Параметр.Значение Цикл 
			Если Параметр.Ключ = "undefinedMethod" Тогда
			ИначеЕсли Параметр.Ключ = "parameters" Тогда
				Описание.Значение.Вставить("value", Запрос.ПараметрыЗапроса.Получить(Описание.Ключ));
			ИначеЕсли Параметр.Ключ = "requestBody" Тогда
				Если Не (Описание.Значение.type = "Array" ИЛИ Описание.Значение.type = "Frame") Тогда	
					Описание.Значение.Вставить("value", "");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;	
		ПараметрыЗапроса.Вставить(Параметр.Ключ, Параметр.Значение)
	КонецЦикла;	
	
	Возврат ПараметрыЗапроса;
		
КонецФункции

//Создает массив ошибок, вызывает десериализацию блока parameters
Функция ВалидацияПараметровЗапроса(ПараметрыЗапроса, Ответ) Экспорт 
	
	Ошибки = Новый Массив;
	
	//Ошибки уровня метода
	Если ПараметрыЗапроса.Свойство("undefinedMethod") Тогда 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.МетодНеОпределен(), ПараметрыЗапроса.undefinedMethod["inputMethod"]); //ПараметрВходящий.Ключ
		Ошибки.Добавить(Новый Структура("errorhandler, context, message", "mtd001", "", ТекстОшибки));
	КонецЕсли;	
	
	//Ошибки уровня представления
	Если Ошибки.Количество() = 0 Тогда 
		Если ПараметрыЗапроса.Свойство("parameters") Тогда //запросы бывают без параметров
			Для Каждого ПараметрОписание Из ПараметрыЗапроса["parameters"] Цикл 
				ПараметрОписание.Значение.value = ДесериализоватьЗначение(ПараметрыЗапроса["parameters"], ПараметрОписание, Ошибки,,ПараметрыЗапроса["parameters"]);
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;	
	
	//Ошибки уровня приложения
	Если Ошибки.Количество() = 0 Тогда 
	КонецЕсли;	
	
	scmHTTPCервисыOpenAPI.ЗаписатьОшибкиВТелоОтвета(Ответ, Ошибки);

	Возврат Ошибки;
	
КонецФункции

//Для запроса содержащего requestBody десериализует тело запроса в структуру
Функция ПолучитьСтруктуруТелаЗапроса(JSON_Структура = "", ПараметрыЗапроса, Ответ, Ошибки) Экспорт
	
	Если ПараметрыЗапроса.Свойство("requestBody") Тогда 
		
		ПараметрОписание = ПараметрыЗапроса["requestBody"];
		Если ПараметрОписание = Неопределено Тогда 
			Если Не ПустаяСтрока(JSON_Структура) Тогда 
				ТекстОшибки =  scmHTTPCервисыOpenAPIСловарь.СхемаНеСодежитОписаниеТелаЗапроса();
				Ошибки.Добавить(Новый Структура("errorhandler, context, message", "map001", "", ТекстОшибки));
			КонецЕсли;
		Иначе 	
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(JSON_Структура);
			ВходящиеПараметры = ПрочитатьJSON(ЧтениеJSON,,ИменаПолейТипаДата(ПараметрОписание), ФорматДатыJSON.ISO); 
			ЧтениеJSON.Закрыть();
			СтруктураЗапроса = Новый Структура;
			Если ТипЗнч(ВходящиеПараметры) = Тип("Структура") Тогда
				Для Каждого ПараметрВходящий Из ВходящиеПараметры Цикл   
					СтруктураЗапроса.Вставить(ПараметрВходящий.Ключ, ДесериализоватьЗначение(ПараметрОписание, ПараметрВходящий, Ошибки,,ВходящиеПараметры));
					Если Ошибки.Количество()>0 Тогда 
						Прервать;
					КонецЕсли;	
				КонецЦикла;
			Иначе
				Ответ = Новый HTTPСервисОтвет(400, "Incorrect body request parameters.");
				Ответ.Заголовки.Вставить("Content-Type", "application/json;charset=utf-8"); //"text/html;charset=utf-8
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураЗапроса;
	
КонецФункции

//Для запроса содержащего respondBody подготавливает структуру тела ответа
Функция ПолучитьСтруктуруТелаОтвета(ПараметрыЗапроса, ИмяСвойства = "respondBody") Экспорт
	
	СтруктураОтвета = Новый Структура;
	Если ПараметрыЗапроса.Свойство(ИмяСвойства) Тогда 
		Для Каждого Параметр Из ПараметрыЗапроса[ИмяСвойства] Цикл   
			СтруктураОтвета.Вставить(Параметр.Ключ, Неопределено);//Параметр.Значение
		КонецЦикла;
	КонецЕсли;	
	Возврат СтруктураОтвета;
	
КонецФункции

Процедура ЗаписатьОшибкиВТелоОтвета(Ответ, Ошибки) Экспорт 
	Если Ошибки.Количество()>0 Тогда 
		Ответ = Новый HTTPСервисОтвет(400, "Incorrect request parameters.");
		Результат = РезультатЗаписатьJSON(Ошибки);
		Ответ.УстановитьТелоИзСтроки(Результат);
	КонецЕсли;
КонецПроцедуры	

Функция РезультатЗаписатьJSON(Знач Значение, Знач НастройкиСериализации = Неопределено, Знач ИмяФункцииПреобразования = Неопределено, Знач МодульФункцииПреобразования = Неопределено, Знач ДополнительныеПараметрыФункцииПреобразования = Неопределено) Экспорт 
	Если НастройкиСериализации = Неопределено Тогда 
		НастройкиСериализации = Новый НастройкиСериализацииJSON;
		НастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO; //"ДатаJSON": "2016-03-15T14:19:48"
		НастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.УниверсальнаяДата; //"ДатаJSON": "2016-01-14T21:00:00Z"
	КонецЕсли;
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();  
	ЗаписатьJSON(ЗаписьJSON, Значение, НастройкиСериализации, ИмяФункцииПреобразования, МодульФункцииПреобразования, ДополнительныеПараметрыФункцииПреобразования);            
	Возврат ЗаписьJSON.Закрыть();
КонецФункции	

#КонецОбласти 

#Область Десериализация

// Преобразует рекурсивно, строки полученных значений ссылочных типов (ref) в ссылки на объект БД
// Значения с описанием типа = Array или Frame преобразуются в массив и структуру соответственно
//	Для переданного значения ПараметрВходящий ищется правило поиска в ПараметрОписание
//	По найденному ОписаниеЗначения выполняется преобразование ПараметрВходящийЗначение в возвращаемое Значение
//
// Параметры:
//  ПараметрОписание - Структура	 - правила преобразования
//  ПараметрВходящий - Структура	 - входящие данные одного значения
//  Ошибки			 - Массив	 - массив накопленных ошибок
//  кешЗначения		 - Соответствие	 - кеш найденных значений для ускорения десериализации значений
//  ВходящиеПараметры - Структура	 - для возможности десериализации значения учитывая все значения (поиск по нескольким полям)
// 
// Возвращаемое значение:
// Найденное значение  - Ссылка на объект, примитивный тип или структура
//
//Функция ДесериализоватьЗначение(ПараметрОписание, ПараметрВходящий, Ошибки)
Функция ДесериализоватьЗначение(ПараметрОписание, ПараметрВходящий, Ошибки, кешЗначения = Неопределено, ВходящиеПараметры = Неопределено) Экспорт 

	ОписаниеЗначения = ПараметрОписание[ПараметрВходящий.Ключ]; //чувствительно к регистру
	
	Если ОписаниеЗначения = Неопределено Тогда  
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.СхемаНеСодержитКлючВходящегоЗначения(), ПараметрВходящий.Ключ);
		Ошибки.Добавить(Новый Структура("errorhandler, context, message", "map002", ПараметрВходящий.Ключ, ТекстОшибки));
	Иначе 	
		
		type = scmHTTPCервисыOpenAPIПовтИсп.ОпределенияТипов()[ОписаниеЗначения.type];
		
		Если type = "Array" Или type = "Frame" Тогда
			ПараметрВходящийЗначение = ПараметрВходящий.Значение;
		ИначеЕсли ТипЗнч(ПараметрВходящий.Значение) = Тип("Структура") Тогда 
			ПараметрВходящийЗначение = ПараметрВходящий.Значение.value;
		Иначе	
			ПараметрВходящийЗначение = ПараметрВходящий.Значение;
		КонецЕсли;
		
		Если ПустаяСтрока(ПараметрВходящийЗначение) И ОписаниеЗначения.Свойство("req") И ОписаниеЗначения.req = Истина Тогда
			//получен пустой обязательный параметр
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.ЗначениеВходящегоПараметраНеЗадано(), ПараметрВходящий.Ключ);
			Ошибки.Добавить(Новый Структура("errorhandler, context, message", "des005", ПараметрВходящий.Ключ, ТекстОшибки));
		ИначеЕсли type = "Array" Тогда 
			//массив значений ссылочных и примитивных типов
			Для Каждого ЭлементМассива Из ПараметрВходящийЗначение Цикл 
				Для Каждого РеквизитЭлементаМассива Из ЭлементМассива Цикл 
					ЭлементМассива[РеквизитЭлементаМассива.Ключ] = ДесериализоватьЗначение(ОписаниеЗначения.value, РеквизитЭлементаМассива, Ошибки, кешЗначения);
 				КонецЦикла;	
			КонецЦикла;	
			Значение = ПараметрВходящийЗначение;
		ИначеЕсли type = "Frame" Тогда //структура значений ссылочных и примитивных типов
			Для Каждого ЭлементСтруктуры Из ПараметрВходящийЗначение Цикл 
				ПараметрВходящийЗначение[ЭлементСтруктуры.Ключ] = ДесериализоватьЗначение(ОписаниеЗначения.value, ЭлементСтруктуры, Ошибки, кешЗначения, ПараметрВходящийЗначение);
			КонецЦикла;	
			Значение = ПараметрВходящийЗначение;
		ИначеЕсли ОписаниеЗначения.Свойство("ref") Тогда  
			Если ПустаяСтрока(ПараметрВходящийЗначение) Тогда 
				//параметр не обязательный	
			Иначе 	
				//ссылочный тип
				МенеджерИмя = СтрРазделить(type, ".");
				Если МенеджерИмя[0] = "Документы" Тогда 
					Если ОписаниеЗначения.ref = "ID" Тогда 
						Значение = Документы[МенеджерИмя[1]].ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрВходящийЗначение));
					Иначе 	
						Значение = Документы[МенеджерИмя[1]].НайтиПоНомеру(ПараметрВходящийЗначение);
					КонецЕсли;		
				ИначеЕсли МенеджерИмя[0] = "Справочники" Тогда 
					Если ОписаниеЗначения.ref = "ID" Тогда 
						Значение = Справочники[МенеджерИмя[1]].ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрВходящийЗначение));
					ИначеЕсли ОписаниеЗначения.ref = "name" Тогда //number
						Значение = Справочники[МенеджерИмя[1]].НайтиПоНаименованию(ПараметрВходящийЗначение);
					ИначеЕсли ОписаниеЗначения.ref = "code" Тогда 
						Значение = Справочники[МенеджерИмя[1]].НайтиПоКоду(ПараметрВходящийЗначение);
					Иначе 
						Значение = Справочники[МенеджерИмя[1]].НайтиПоРеквизиту(ОписаниеЗначения.ref, ПараметрВходящийЗначение);
					КонецЕсли;	
				ИначеЕсли МенеджерИмя[0] = "Макрос" Тогда 
					Выполнить("Значение = " + МенеджерИмя[1]);	
				Иначе
					ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.СхемаНеСодержитТипВходящегоЗначения(), ПараметрВходящий.Ключ, ПараметрВходящийЗначение);
					Ошибки.Добавить(Новый Структура("errorhandler, context, message", "typ001", ПараметрВходящий.Ключ, ТекстОшибки));
				КонецЕсли;	
				Если ОписаниеЗначения.Свойство("req") И ОписаниеЗначения.req И Не ОписаниеЗначения.ref = "structure" Тогда //объект обязательно должен быть найден. структуры пока не проверяются
					Если Значение = Неопределено Тогда 
						ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.ОбъектПоЗначениюНеНайден(), ПараметрВходящий.Ключ, ПараметрВходящийЗначение);
						Ошибки.Добавить(Новый Структура("errorhandler, context, message", "des001", ПараметрВходящий.Ключ, ТекстОшибки));
					//ИначеЕсли Значение.Пустая() Тогда 
					//	ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(HTTPCервисыESBСловарь.ОбъектПоЗначениюНеНайден(), ПараметрВходящий.Ключ, ПараметрВходящийЗначение);
					//	Ошибки.Добавить(Новый Структура("errorhandler, context, message", "des002", ПараметрВходящий.Ключ, ТекстОшибки));
					ИначеЕсли ПустаяСтрока(Значение.ВерсияДанных) Тогда //<Объект не найден>
						ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.ОбъектПоЗначениюНеНайден(), ПараметрВходящий.Ключ, ПараметрВходящийЗначение);
						Ошибки.Добавить(Новый Структура("errorhandler, context, message", "des006", ПараметрВходящий.Ключ, ТекстОшибки));
					КонецЕсли;	
				КонецЕсли;	
			КонецЕсли;	
		Иначе 
			//примитивный тип
			Если type = "число" Тогда 
				Значение = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ПараметрВходящийЗначение);
			ИначеЕсли type = "строка" Тогда 
				Значение = ПараметрВходящийЗначение;
			ИначеЕсли type = "дата" Тогда 
				Значение = ПараметрВходящийЗначение;
				Если Не ЗначениеЗаполнено(Значение) Тогда 
					ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.ЗначениеПримитивногоТипаНеОпределеноПоЗначению(), ПараметрВходящийЗначение, type, ПараметрВходящий.Ключ);
					Ошибки.Добавить(Новый Структура("errorhandler, context, message", "des003", ПараметрВходящий.Ключ, ТекстОшибки));
				КонецЕсли;	
			ИначеЕсли type = "булево" Тогда 
				Если ПустаяСтрока(ПараметрВходящийЗначение) Тогда 
					ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.ЗначениеПримитивногоТипаНеОпределеноПоЗначению(), ПараметрВходящийЗначение, type, ПараметрВходящий.Ключ);
					Ошибки.Добавить(Новый Структура("errorhandler, context, message", "des005", ПараметрВходящий.Ключ, ТекстОшибки));
					Значение = Ложь;	
				Иначе 	
					Значение = Булево(ПараметрВходящийЗначение);//TODO - нужна функция для возможных входных значений, либо наложить фасет
				КонецЕсли;	
			ИначеЕсли type = "facet" Тогда 
			Иначе
				ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(scmHTTPCервисыOpenAPIСловарь.СхемаНеСодержитТипВходящегоЗначения(), ПараметрВходящий.Ключ, ПараметрВходящийЗначение);
				Ошибки.Добавить(Новый Структура("errorhandler, context, message", "typ003", ПараметрВходящий.Ключ, ТекстОшибки));
				Значение = ПараметрВходящийЗначение;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;	
	
	Возврат Значение;
	
КонецФункции  

#КонецОбласти 

#Область Сериализация

//Формирует СтруктуруОтвета по описанию переданному в ПараметрахЗапроса
//Преобразует одноуровневые данные СтруктураЗапроса в сериализованную СтруктуруОтвета
Функция СобратьСтруктуруОтвета(Знач СтруктураЗапроса, ПараметрыЗапроса, СтруктураОтвета = Неопределено)  Экспорт 
	
	Если СтруктураОтвета = Неопределено Тогда 
		СтруктураОтвета = Новый Структура;
	КонецЕсли;
	типСтруктураЗапроса = ТипЗнч(СтруктураЗапроса) = Тип("Структура");

	Для Каждого body Из ПараметрыЗапроса Цикл 
		Если body.Значение.type = "Array" Или body.Значение.type = "Frame" Тогда
			Array = ?(body.Значение.type = "Array", Новый Массив, Новый Структура);
		//	Если ЗначениеЗаполнено(СтруктураЗапроса[body.Ключ]) Тогда 
			Если (типСтруктураЗапроса И СтруктураЗапроса.Свойство(body.Ключ)) 
			ИЛИ (Не типСтруктураЗапроса И ЗначениеЗаполнено(СтруктураЗапроса[body.Ключ])) Тогда 
				Для Каждого Выборка Из СтруктураЗапроса[body.Ключ] Цикл 
					СтруктураПолей = Новый Структура;
					Для Каждого Поле из ПараметрыЗапроса[body.Ключ].value Цикл 
						СтруктураПолей.Вставить(Поле.Ключ, СериализоватьЗначение(Выборка[Поле.Ключ], Поле.Значение)); 
					КонецЦикла;	
					Array.Добавить(СтруктураПолей);
				КонецЦикла;	
			КонецЕсли;
			СтруктураОтвета.Вставить(body.Ключ, Array);
		Иначе
			Если body.Значение.Свойство("value") И Не body.Значение.value = "" Тогда  
				МассивЗначения = СтрРазделить(body.Значение.value, ".");
				СтруктураОтвета.Вставить(body.Ключ, СериализоватьЗначение(СтруктураЗапроса[МассивЗначения[0]].Количество(), body.Значение));
			Иначе 	
				Если типСтруктураЗапроса Тогда 
				//	СтруктураОтвета.Вставить(body.Ключ, СериализоватьЗначение(Неопределено, body.Значение));
					СтруктураОтвета.Вставить(body.Ключ, ?(СтруктураЗапроса.Свойство(body.Ключ), СериализоватьЗначение(СтруктураЗапроса[body.Ключ], Неопределено), body.Значение));
				Иначе 
					СтруктураОтвета.Вставить(body.Ключ, СериализоватьЗначение(СтруктураЗапроса[body.Ключ], body.Значение));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат СтруктураОтвета;
	
КонецФункции

Функция СобратьСтруктуруОтвета_(Знач СтруктураЗапроса, ПараметрыЗапроса, СтруктураОтвета = Неопределено)  Экспорт 
	
	Если СтруктураОтвета = Неопределено Тогда 
		СтруктураОтвета = Новый Структура;
	КонецЕсли;

	Для Каждого body Из ПараметрыЗапроса Цикл 
		Если body.Значение.type = "Array" Или body.Значение.type = "Frame" Тогда
			Array = ?(body.Значение.type = "Array", Новый Массив, Новый Структура);
			Если ЗначениеЗаполнено(СтруктураЗапроса[body.Ключ]) Тогда 
				Для Каждого Выборка Из СтруктураЗапроса[body.Ключ] Цикл 
					СтруктураПолей = Новый Структура;
					Для Каждого Поле из ПараметрыЗапроса[body.Ключ].value Цикл 
						СтруктураПолей.Вставить(Поле.Ключ, СериализоватьЗначение(Выборка[Поле.Ключ], Поле.Значение)); 
					КонецЦикла;	
					Array.Добавить(СтруктураПолей);
				КонецЦикла;	
			КонецЕсли;
			СтруктураОтвета.Вставить(body.Ключ, Array);
		Иначе
			Если body.Значение.Свойство("value") И Не body.Значение.value = "" Тогда  
				МассивЗначения = СтрРазделить(body.Значение.value, ".");
				СтруктураОтвета.Вставить(body.Ключ, СериализоватьЗначение(СтруктураЗапроса[МассивЗначения[0]].Количество(), body.Значение));
			Иначе 	
				СтруктураОтвета.Вставить(body.Ключ, СериализоватьЗначение(СтруктураЗапроса[body.Ключ], body.Значение));
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат СтруктураОтвета;
	
КонецФункции

//Преобразует ссылочные объекты БД в строку
Функция СериализоватьЗначение(Значение, ОписаниеЗначения, СериализоватьПримитивныеТипы = Ложь) Экспорт
	
	//ЗначениеСтрока = "";
	//Если ПустаяСтрока(XMLСтрока(Значение)) Тогда 
	//	ЗначениеСтрока = ""; //Null
	Если ОписаниеЗначения.Свойство("ref") Тогда //ссылочный тип
		Если ОписаниеЗначения.ref = "ID" Тогда 
			ЗначениеСтрока = XMLСтрока(Значение); 
		ИначеЕсли ОписаниеЗначения.ref = "code" Тогда 
			ЗначениеСтрока = Значение.Код; 
		ИначеЕсли ОписаниеЗначения.ref = "name" Тогда 
			ЗначениеСтрока = Строка(Значение); 
		ИначеЕсли ОписаниеЗначения.ref = "structure" Тогда 
			ЗначениеСтрока = Строка(Значение); 
		////	Выполнить("ЗначениеСтрока = СтрокаЗначение." + HTTPCервисыESBПовтИсп.ОпределенияТипов()[ОписаниеЗначения.ref] ); //не использовать - оптимальным способом получения представления значения является получение в запросе
		КонецЕсли;		
	Иначе  //примитивный тип
		Если ОписаниеЗначения.Свойство("format") Тогда 
			Если ОписаниеЗначения.type = "date" Тогда 
				ЗначениеСтрока = Формат(Значение, ОписаниеЗначения.format); 
			КонецЕсли;
		Иначе
			Если ОписаниеЗначения.type = "date" Тогда
				ЗначениеСтрока = ?(СериализоватьПримитивныеТипы, Формат(Значение, "ДФ=yyyy-MM-ddTHH:mm:ss"), Значение); // формат по умолчанию 
			ИначеЕсли ОписаниеЗначения.type = "integer" ИЛИ ОписаниеЗначения.type = "float" Тогда 
				ЗначениеСтрока = ?(СериализоватьПримитивныеТипы, Формат(Значение, "ЧГ="), Значение);//
			ИначеЕсли ОписаниеЗначения.type = "bool"  Тогда   	
				ЗначениеСтрока = Значение;
			ИначеЕсли ОписаниеЗначения.type = "string" Тогда 
				ЗначениеСтрока = Строка(XMLСтрока(Значение));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеСтрока; 
	
КонецФункции

// Используется опционально, как ФункцияПреобразованияJSON для структур которые содержат ссылочные типы
// Не является оптимальным решением по производительности, но может использоваться для исключения ошибок при вызове ЗаписатьJSON
Функция ФункцияСериализацииJSON(Свойство, Значение, ДополнительныеПараметры, Отказ = Ложь) Экспорт
	
	Если ТипЗнч(Значение) = Тип("СправочникСсылка.Номенклатура") Тогда
	    Возврат Строка(Значение.АртикулМодели);
	КонецЕсли;
	Если ТипЗнч(Значение) = Тип("УникальныйИдентификатор") Тогда
	    Возврат Строка(Значение);
	КонецЕсли;

КонецФункции

// Используется только в форме отладки HTTP для получения представления Структур
// Сериализует значение в допустимый для записи в JSON тип
//
// Параметры: 
//	Свойство				- в параметр передается имя свойства, если выполняется запись структуры или соответствия, 
//	Значение				- в параметр передается исходное значение, 
//	ДополнительныеПараметры	- дополнительные параметры, которые указаны в вызове метода ЗаписатьJSON, 
//	Отказ					- отказ от записи свойства.
//
// Возвращаемое значение:
//	+ Неопределено, 
//	+ Булево, 
//	+ Число,
//	+ Строка, 
//	+ Дата (будет преобразована в строку), 
//	+ Структура, 
//	+ ФиксированнаяСтруктура, 
//	+ Массив, 
//	+ ФиксированныйМассив, 
//	+ Соответствие, 
//	+ ФиксированноеСоответствие.
//
//	Если функция возвращает объект, который не поддерживает преобразование в JSON, то будет вызвано исключение.
//	Если данный параметр задан и не задан параметр <МодульФункцииПреобразования>, и наоборот, будет вызвано исключение.
Функция ФункцияСериализацииJSONОтладка(Знач Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт
	
	мета		= Метаданные.НайтиПоТипу(ТипЗнч(Значение));	
	value		= ?(Значение = Неопределено ИЛИ Значение.Пустая(), Неопределено, XMLСтрока(Значение));
	type		= мета.ПолноеИмя();
	baseType	= Лев(type, СтрНайти(type, ".")-1);
	Данные		= Новый Структура("type", type);
		
	Если НРег(baseType) = "справочник" Тогда
		Данные.Вставить("code", ?(value=Неопределено, Неопределено, Значение.Код));
		Данные.Вставить("description", ?(value=Неопределено, Неопределено, Значение.Наименование));
	ИначеЕсли НРег(baseType) = "документ" Тогда
		Данные.Вставить("number", ?(value=Неопределено, Неопределено, Значение.Номер));
		Данные.Вставить("date", ?(value=Неопределено, Неопределено, Значение.Дата));
	ИначеЕсли НРег(baseType) = "перечисление" Тогда
		Данные.Вставить("description", ?(value=Неопределено, Неопределено, Строка(Значение)));		
	ИначеЕсли НРег(baseType) = "планвидовхарактеристик" Тогда
		Данные.Вставить("description", ?(value=Неопределено, Неопределено, Строка(Значение)));		
	ИначеЕсли НРег(baseType) = "плансчетов" Тогда
		Данные.Вставить("description", ?(value=Неопределено, Неопределено, Строка(Значение)));		
	Иначе
		Данные.Вставить("description", ?(value=Неопределено, Неопределено, Строка(Значение)));		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции     

#КонецОбласти 

#Область Методы_Запрос

Функция mobilePostЗапрос(method, ПараметрыЗапроса, СтруктураЗапроса = Неопределено, СтруктураОтвета = Неопределено, Ошибки = Неопределено) Экспорт
	
	header = "";
	RespondBodyJSON = "";
	
	Если Ошибки = Неопределено Тогда 
		Ошибки = Новый Массив;	
	КонецЕсли;	
	
	Если Ошибки.Количество()> 0 Тогда 
		Возврат RespondBodyJSON;	
	КонецЕсли;	
	
	//Если method = "/api/3pl/transfer/v1/doc/create" Тогда  //описание переопределено от postOrderData
	//	getOrderData(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки); 
	//КонецЕсли;	
	Если method = "/api/3pl/transfer/v1/box/create" Тогда //описание переопределено от postWayBillData 
		//getWayBillData(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки); 
	КонецЕсли;	
	Если method = "/api/3pl/transfer/v1/box/commit" Тогда  //postWayBillCommitState
		//postWayBillCommitState(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки); 
	КонецЕсли;	
	
	Если СтруктураОтвета <> Неопределено Тогда 
		RespondBodyJSON = РезультатЗаписатьJSON(СтруктураОтвета);
	КонецЕсли;
	
	Возврат RespondBodyJSON;
	
КонецФункции

#КонецОбласти  

#Область Методы_Ответ

Процедура mobileGetОтвет(method, ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета = Неопределено, Ответ, Ошибки) Экспорт
	
	Если Ошибки.Количество()> 0 Тогда 
		Возврат;	
	КонецЕсли;
	
	header = "";
	
	Если method = "getWayBillList" Тогда 
		//getWayBillList(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	//ИначеЕсли method = "getOrderList" Тогда 
	//	getOrderList(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	//ИначеЕсли method = "getShopStatusList" Тогда 
	//	getShopStatusList(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	ИначеЕсли method = "getWayBillData" Тогда 
		//getWayBillData(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	ИначеЕсли method = "postWayBillData" Тогда 
		//postWayBillData(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	//ИначеЕсли method = "getWayBillCommitState" Тогда 
	//	getWayBillCommitState(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	КонецЕсли;	
	
	Ответ.Причина = header;
	Если Не СтруктураОтвета = Неопределено Тогда 
		RespondBodyJSON = РезультатЗаписатьJSON(СтруктураОтвета);
		Ответ.УстановитьТелоИзСтроки(RespondBodyJSON);
	КонецЕсли;

КонецПроцедуры

Процедура mobilePostОтвет(method, ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета = Неопределено, Ответ = Неопределено, Ошибки) Экспорт
	
	Если Ошибки.Количество()> 0 Тогда 
	//	Возврат;	
	КонецЕсли;	
	
	header = "";
	
	Если method = "postWebhookUpdates" Тогда 
		postWebhookUpdates(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	ИначеЕсли method = "postWayBillData" Тогда 
		//postWayBillData(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	ИначеЕсли method = "postShopStatus" Тогда 
		//postShopStatus(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	ИначеЕсли method = "dropOrder" Тогда 
		//dropOrder(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	ИначеЕсли method = "dropShopStatus" Тогда 
		//dropShopStatus(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	ИначеЕсли method = "postWayBillCommit" Тогда 
		//postWayBillCommit(ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, header, Ошибки);
	КонецЕсли;	
	
	Если Ответ <> Неопределено Тогда 
		Ответ.Причина = header;
		Если Не СтруктураОтвета = Неопределено Тогда 
			RespondBodyJSON = РезультатЗаписатьJSON(СтруктураОтвета);
			Ответ.УстановитьТелоИзСтроки(RespondBodyJSON);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиМетодов_Ответ

#Область mobile

//  
Процедура postWebhookUpdates(ПараметрыЗапроса = Неопределено, СтруктураЗапроса = Неопределено, СтруктураОтвета = Неопределено, Ответ, Ошибки = Неопределено) Экспорт
	
	RequestBodyJSON = "";
	RespondBodyJSON = "";
	кешНастройки = Справочники.scmВнешниеСервисы_ПараметрыСоединения.bot_01;
	ОпределениеМетода_sendMessage = scmHTTPCервисыOpenAPIПовтИсп.ОпределенияЗапросов("/TelegramBot/", "sendMessage");	
	sendMessage_parameters = ОпределениеМетода_sendMessage["parameters"];		
	RespondBodyJSON = Обработки.scmОбработкаТелеграмБот.ОбработатьВходящееСообщениеНаСервере(СтруктураЗапроса, кешНастройки, sendMessage_parameters, RequestBodyJSON, RespondBodyJSON);		
	//Ответ = Новый HTTPСервисОтвет(200); //stub    "схема не содержит ключ входящего значения 'reply_markup' "
	Ошибки.Очистить();
КонецПроцедуры

#КонецОбласти 

#Область schema

// Возвращает актуальное описание схемы API в виде: шаблон/метод/параметры/параметр[type, ref, req] 
Процедура schemaGETОтвет(method, ПараметрыЗапроса = Неопределено, СтруктураЗапроса = Неопределено, СтруктураОтвета = Неопределено,Ответ, Ошибки = Неопределено) Экспорт
	
	ВсеМетоды = Новый Соответствие();
	Для Каждого Шаблон Из Метаданные.HTTPСервисы.scmOpenAPI.ШаблоныURL Цикл 
		ВсеМетоды.Вставить(Шаблон.Шаблон, scmHTTPCервисыOpenAPIПовтИсп.ОпределенияМетодов(Шаблон.Шаблон));
	КонецЦикла;	
	RespondBodyJSON = РезультатЗаписатьJSON(ВсеМетоды);
	Ответ.УстановитьТелоИзСтроки(RespondBodyJSON);
	
КонецПроцедуры

#КонецОбласти 

#КонецОбласти 

#Область Макросы

//Возвращает Ссылку на БизнесЕдиницы по Префиксу
Функция БизнесЕдиницаПоПрефиксу(Префикс)
	
	Если Префикс = "ZR" Тогда 
		 Префикс = Справочники.БизнесЕдиницы.ZARINA;
	ИначеЕсли Префикс = "SL" Тогда 
		 Префикс = Справочники.БизнесЕдиницы.SELA;
	ИначеЕсли Префикс = "BF" Тогда 
		 Префикс = Справочники.БизнесЕдиницы.befree;
	ИначеЕсли Префикс = "LR" Тогда 
		 Префикс = Справочники.БизнесЕдиницы.Taxi;
	КонецЕсли;
	
	Возврат Префикс;
	
КонецФункции

//Возвращает Ссылку на ЗаказПокупателяИнтернетМагазина по НомерЗаказаЦифровой
Функция ЗаказПокупателяИнтернетМагазина(НомерЗаказаЦифровой)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказПокупателяИнтернетМагазина.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаказПокупателяИнтернетМагазина КАК ЗаказПокупателяИнтернетМагазина
		|ГДЕ
		|	ЗаказПокупателяИнтернетМагазина.НомерВходящегоДокументаЭлектронногоОбмена = &НомерЗаказаЦифровой";
	
	Запрос.УстановитьПараметр("НомерЗаказаЦифровой", НомерЗаказаЦифровой);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НомерЗаказаЦифровой = ВыборкаДетальныеЗаписи.Ссылка;
		Прервать; //
	КонецЦикла;
	
	Возврат НомерЗаказаЦифровой;
	
КонецФункции

// Вовзращает значения ШК для заполнения строк документов
//
// Параметры:
//  EAN_13	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция СтруктураЗначенийПоШтрихкоду(EAN_13)
	
	Значение = Неопределено;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШтрихКоды.EAN_13 КАК EAN_13,
		|	ШтрихКоды.Модель КАК Модель,
		|	ШтрихКоды.Размер КАК Размер,
		|	ШтрихКоды.Размер.Код КАК РазмерКод,
		|	ШтрихКоды.Цвет КАК Цвет,
		|	ШтрихКоды.Рост КАК Рост
		|ИЗ
		|	РегистрСведений.ШтрихКоды КАК ШтрихКоды
		|ГДЕ
		|	ШтрихКоды.EAN_13 = &EAN_13";
	
	Запрос.УстановитьПараметр("EAN_13", EAN_13);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Значение = Новый Структура("Модель, Размер, РазмерКод, Цвет, Рост, EAN_13");
		ЗаполнитьЗначенияСвойств(Значение, ВыборкаДетальныеЗаписи);
	КонецЕсли;	

	Возврат Значение;
	
КонецФункции

Функция СтруктураЗначенийПоQRкоду(КодМаркировки)
	
	Значение = Неопределено;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Маркировка.Ссылка КАК КодМаркировки,
		|	Маркировка.Код КАК Код,
		|	Маркировка.Наименование КАК Наименование,
		|	Маркировка.EAN_13 КАК EAN_13,
		|	Маркировка.Номенклатура КАК Модель,
		|	Маркировка.СтатусМетки КАК СтатусМетки,
		|	Маркировка.ДатаСоздания КАК ДатаСоздания,
		|	Маркировка.ДатаПечати КАК ДатаПечати,
		|	Маркировка.ДатаВводаВТоварооборот КАК ДатаВводаВТоварооборот,
		|	Маркировка.ДатаВыводаИзТоварооборота КАК ДатаВыводаИзТоварооборота,
		|	Маркировка.ВладелецМетки КАК ВладелецМетки,
		|	Маркировка.Номер КАК Номер,
		|	Маркировка.ПолноеНаименование КАК ПолноеНаименование,
		|	Маркировка.ШтрихКод КАК ШтрихКод,
		|	Маркировка.ТипЭмиссии КАК ТипЭмиссии,
		|	ШтрихКоды.Размер КАК Размер,
		|	ШтрихКоды.Размер.Код КАК РазмерКод,
		|	ШтрихКоды.Цвет КАК Цвет,
		|	ШтрихКоды.Рост КАК Рост
		|ИЗ
		|	Справочник.КодыМаркировки КАК Маркировка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихКоды КАК ШтрихКоды
		|		ПО (ШтрихКоды.EAN_13 = Маркировка.EAN_13)
		|			И (НЕ ШтрихКоды.Неиспользуемый)
		|ГДЕ
		|	ПОДСТРОКА(Маркировка.Наименование, 0, 31) = ПОДСТРОКА(&КодМаркировки, 0, 31)";
	
	Запрос.УстановитьПараметр("КодМаркировки", Лев(КодМаркировки, 32));
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Значение = Новый Структура("Модель, Размер, РазмерКод, Цвет, Рост, EAN_13, КодМаркировки"); 
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		//структура приведена к структуре EAN_13 только для удобного сравнения структур при отладке - соединение РегистрСведений.ШтрихКоды можно убрать
		//TODO необходимо определиться - где сравнивать соответствие ТЧ маркировки и товаров:
		//1) до записи, по подготовленным структурам 
		//2) до записи унифицированным модулем документа (который выполняется в любом случае при записи)
		//3) вообще отключить проверки - пусть проверки выполняются при проведении для пользователя 1С
		ЗаполнитьЗначенияСвойств(Значение, ВыборкаДетальныеЗаписи);
	КонецЕсли;	

	Возврат Значение;
	
КонецФункции

#КонецОбласти 

#Область Служебные

//Возвращает строку полей с типом Дата, для десериализации Дат в формате timestamp в платформенной функции ПрочитатьJSON
Функция ИменаПолейТипаДата(ПараметрОписание, МассивИменПолей = Неопределено)
	Если МассивИменПолей = Неопределено Тогда 
		МассивИменПолей = Новый Массив;
	КонецЕсли;
	Для Каждого п Из ПараметрОписание Цикл 
		Если п.Значение.type = "date" Тогда //И Не п.Значение.Свойство("format")		
		//	МассивИменПолей.Добавить(п.Ключ);	
		КонецЕсли;
		Если п.Значение.type = "Array" Или п.Значение.type = "Frame" Тогда
			ИменаПолейТипаДата(п.Значение.value, МассивИменПолей);	
		КонецЕсли;
	КонецЦикла;
	Возврат СтрСоединить(МассивИменПолей, ",");
КонецФункции	

//Возвращает json переданной структуры. Используется для отладки: вывода представления структуры
Функция ПредставлениеСтруктуры(ПереданнаяСтруктура) Экспорт 
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();  
	ЗаписатьJSON(ЗаписьJSON, ПереданнаяСтруктура,,"ФункцияСериализацииJSONОтладка", scmHTTPCервисыOpenAPI);            
	Результат = ЗаписьJSON.Закрыть();
	Возврат Результат;
	
КонецФункции

#КонецОбласти