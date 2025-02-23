#Область СлужебныйПрограммныйИнтерфейс

#Область УровеньПараметровЗапроса

Функция МетодНеОпределен() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'метод ''%1'' не определен';
					|en = 'method ''% 1'' not defined'", КодЯзыка);
	
КонецФункции

Функция ЗначениеВходящегоПараметраНеЗадано() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Значение входящего параметра ''%1'' не задано';
					|en = 'The value of the input parameter ''% 1'' is not specified'", КодЯзыка);
	
КонецФункции

Функция ЗначениеПримитивногоТипаНеОпределеноПоЗначению() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'значение ''%1'' типа ''%2'' не определено по значению ''%3''';
					|en = 'value ''%1'' type ''%2'' is undefined by value ''%3'''", КодЯзыка);
	
КонецФункции

Функция ОбъектПоЗначениюНеНайден() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'ссылочный объект ''%1'' по значению ''%2'' не найден';
					|en = 'reference object ''% 1'' by value ''% 2'' not found'", КодЯзыка);
	
КонецФункции

Функция СхемаНеСодержитКлючВходящегоЗначения() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'схема не содержит ключ входящего значения ''%1'' ';
					|en = 'the schema does not contain an incoming write key ''%1'''", КодЯзыка);
	
КонецФункции

Функция СхемаНеСодержитТипВходящегоЗначения() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'для поля ''%1'' схема не содержит тип для входящего значения ''%2''';
					|en = 'for field ''%1'' schema does not contain type for input value ''%2'''", КодЯзыка);
	
КонецФункции

Функция СхемаНеСодежитОписаниеТелаЗапроса() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Схема не содежит описание тела запроса';
					|en = 'The schema does not contain a description of the request body'", КодЯзыка);
	
КонецФункции

#КонецОбласти 

#Область УровеньЛогическойЦелостности

//+++Документ.ВнутреннееПеремещение
Функция НеСоответствияТЧТоварыИМаркировкиПоНоменклатуреСРазмерами() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'В строке таблицы ''%1'' [ ''%2''] нет соответствия c таблицей Товары по EAN13 = ''%3'' ';
					|en = 'In the table row ''%1'' [''%2''] there is no correspondence with the table Items according to EAN13 = ''%3'' '", КодЯзыка);
	
КонецФункции

Функция КоличествоЗагруженныхКодовМаркировкиНеСоответствуетКоличествуТоваровПодлежащихМаркировке() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Количество загруженных кодов маркировки не соответствует количеству товаров ''%1'', подлежащих маркировке с даты ''%2'' ';
					|en = 'The number of tagged codes loaded does not match the number of items ''%1'' that have been tagged since the date ''%2'' '", КодЯзыка);
	
КонецФункции
//---Документ.ВнутреннеПеремещение

#КонецОбласти 

#Область УровеньБизнесЛогики

//+++Перечисления.Состояния

Функция ПереходВСостояниеНеВозможен() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Переход из состояния ''%1'' в состояние ''%2'' не возможен. Причина: ''%3'' ';
					|en = 'The transition from state ''% 1 '' to state ''% 2 '' is not possible. Reason: ''%3'' '", КодЯзыка);
	
КонецФункции

Функция СостояниеНеОпределенаКонвертацияФлаговВСостояние() Экспорт
    
    КодЯзыка = scmHTTPCервисыOpenAPIПовтИсп.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Не определена конвертация состояния ''%1''. Причина: ''%3'' ';
					|en = 'Could not convert  state ''% 1 ''. Reason: ''%3'' '", КодЯзыка);
	
КонецФункции

//---Перечисления.Состояния

#КонецОбласти 

#КонецОбласти 

