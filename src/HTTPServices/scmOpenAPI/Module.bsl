#Область Служебные

Функция schemaGET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8"); 
	scmHTTPCервисыOpenAPI.schemaGETОтвет(Запрос.ПараметрыURL["*"],,,,Ответ);
	Возврат Ответ;
	
КонецФункции

Функция mobileGET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200, "");
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8"); 
	МетодОпределение = scmHTTPCервисыOpenAPIПовтИсп.ОпределенияМетодов("/mobile/{method}", Запрос.ПараметрыURL["method"]);
	ПараметрыЗапроса = scmHTTPCервисыOpenAPI.ПараметрыМетодаИзЗапроса(Запрос, МетодОпределение);
	Ошибки			 = scmHTTPCервисыOpenAPI.ВалидацияПараметровЗапроса(ПараметрыЗапроса, Ответ);
	Если Ошибки.Количество() = 0 Тогда //если нет ошибок уровней Представления и Приложения
		СтруктураЗапроса = scmHTTPCервисыOpenAPI.ПолучитьСтруктуруТелаЗапроса(Запрос.ПолучитьТелоКакСтроку(), ПараметрыЗапроса, Ответ, Ошибки);
		СтруктураОтвета =  scmHTTPCервисыOpenAPI.ПолучитьСтруктуруТелаОтвета(ПараметрыЗапроса);
		scmHTTPCервисыOpenAPI.mobileGetОтвет(Запрос.ПараметрыURL["method"], ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, Ответ, Ошибки);
	КонецЕсли;
	scmHTTPCервисыOpenAPI.ЗаписатьОшибкиВТелоОтвета(Ответ, Ошибки);
	
	Возврат Ответ;
	
КонецФункции

Функция mobilePost(Запрос)
		
	Ответ = Новый HTTPСервисОтвет(200, "");
	МетодОпределение = scmHTTPCервисыOpenAPIПовтИсп.ОпределенияМетодов("/mobile/{method}", Запрос.ПараметрыURL["method"]);
	ПараметрыЗапроса = scmHTTPCервисыOpenAPI.ПараметрыМетодаИзЗапроса(Запрос, МетодОпределение);
	Ошибки			 = scmHTTPCервисыOpenAPI.ВалидацияПараметровЗапроса(ПараметрыЗапроса, Ответ);
	Если Ошибки.Количество() = 0 Тогда //если нет ошибок уровней Представления и Приложения
		СтруктураЗапроса = scmHTTPCервисыOpenAPI.ПолучитьСтруктуруТелаЗапроса(Запрос.ПолучитьТелоКакСтроку(), ПараметрыЗапроса, Ответ, Ошибки);
		СтруктураОтвета =  scmHTTPCервисыOpenAPI.ПолучитьСтруктуруТелаОтвета(ПараметрыЗапроса);
		scmHTTPCервисыOpenAPI.mobilePostОтвет(Запрос.ПараметрыURL["method"], ПараметрыЗапроса, СтруктураЗапроса, СтруктураОтвета, Ответ, Ошибки);
	КонецЕсли;
	scmHTTPCервисыOpenAPI.ЗаписатьОшибкиВТелоОтвета(Ответ, Ошибки);
		
	Возврат Ответ;
	
КонецФункции

Функция pricesGET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200, "");
	МетодОпределение = scmHTTPCервисыOpenAPIПовтИсп.ОпределенияМетодов("/prices/{method}", Запрос.ПараметрыURL["method"]);
	ПараметрыЗапроса = scmHTTPCервисыOpenAPI.ПараметрыМетодаИзЗапроса(Запрос, МетодОпределение);
	Ошибки			 = scmHTTPCервисыOpenAPI.ВалидацияПараметровЗапроса(ПараметрыЗапроса, Ответ);
	Если Ошибки.Количество() = 0 Тогда //если нет ошибок уровней Представления и Приложения
		СтруктураЗапроса = scmHTTPCервисыOpenAPI.ПолучитьСтруктуруТелаЗапроса(Запрос.ПолучитьТелоКакСтроку(), ПараметрыЗапроса, Ответ, Ошибки);
		scmHTTPCервисыOpenAPI.pricesGetОтвет(Запрос.ПараметрыURL["method"], ПараметрыЗапроса, СтруктураЗапроса, Ответ, Ошибки);
	КонецЕсли;
	scmHTTPCервисыOpenAPI.ЗаписатьОшибкиВТелоОтвета(Ответ, Ошибки);
	
	Возврат Ответ;
	
КонецФункции

Функция pricesPOST(Запрос)
	Ответ = Новый HTTPСервисОтвет(200); //stub
	Возврат Ответ;
КонецФункции

Функция balanceGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200); //stub
	Возврат Ответ;
КонецФункции

Функция printGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200); //stub
	Возврат Ответ;
КонецФункции

Функция printPUT(Запрос)
	Ответ = Новый HTTPСервисОтвет(200); //stub
	Возврат Ответ;
КонецФункции

Функция internetstoreGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200); //stub
	Возврат Ответ;
КонецФункции

#КонецОбласти


