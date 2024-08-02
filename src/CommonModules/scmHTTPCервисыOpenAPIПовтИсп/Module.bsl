#Область СлужебныйПрограммныйИнтерфейс

//Описывает связь типов используемыми в обмене с объектами 1С
Функция ОпределенияТипов() Экспорт
	
	reftype = Новый Соответствие();
	reftype.Вставить("ID", "УникальныйИдентификатор()");
	reftype.Вставить("name", "name");
	reftype.Вставить("integer", "число");
	reftype.Вставить("float", "число");
	reftype.Вставить("string", "строка");
	reftype.Вставить("date", "дата");
	reftype.Вставить("bool", "булево");
	reftype.Вставить("facet", "facet");
	reftype.Вставить("Array", "Array");
	reftype.Вставить("Frame", "Frame");
	reftype.Вставить("catalog.Status", "Справочники.Статусы");
	reftype.Вставить("catalog.Склады", "Справочники.Склады");
	reftype.Вставить("catalog.Номенклатура", "Справочники.Номенклатура");
	reftype.Вставить("catalog.BusinessUnit", "Справочники.БизнесЕдиницы");
	reftype.Вставить("catalog.BusinessUnit.Prefix", "Макрос.БизнесЕдиницаПоПрефиксу(ПараметрВходящийЗначение)");
	reftype.Вставить("catalog.ReturnType", "Справочники.ТипыВозвратов");
	reftype.Вставить("catalog.DataStreamsRecipients", "Справочники.ПолучателиИнформацииПотоковДанных");
	reftype.Вставить("document.WayBill", "Документы.scmНакладныеНаВыполнениеРабот");
	reftype.Вставить("document.OrderOnlineStore", "Макрос.ЗаказПокупателяИнтернетМагазина(ПараметрВходящийЗначение)");
	reftype.Вставить("document.Box", "Макрос.КоробкаДокумент(ПараметрВходящийЗначение, ВходящиеПараметры)");
	reftype.Вставить("EAN13_struct", "Макрос.СтруктураЗначенийПоШтрихкоду(ПараметрВходящийЗначение)");
	reftype.Вставить("QRCode_struct", "Макрос.СтруктураЗначенийПоQRкоду(ПараметрВходящийЗначение)");
	
	Возврат reftype;
	
КонецФункции

//Описание исходящих запросов (к внешним сервисам)
Функция ОпределенияЗапросов(inputPattern = "", inputMethod = "") Экспорт
	
	methodContent = Неопределено;
	patternContent = Новый Соответствие;
		
	#Область TelegramBot
	pattern = "/TelegramBot/";	
	Если pattern = inputPattern ИЛИ inputPattern = "" Тогда 
		
		patternMethod = "getUpdates";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда

			parameters = Новый Соответствие;
			parameters.Вставить("offset", Новый Структура("type, req, description", "string", Ложь, "идентификатор первого offset для возврата (update_id)"));  //Identifier of the first update to be returned. Must be greater by one than the highest among the identifiers of previously received updates. By default, updates starting with the earliest unconfirmed update are returned.    
			parameters.Вставить("limit", Новый Структура("type, req, description", "integer", Ложь, "количество последних сообщений"));   //Limits the number of updates to be retrieved. Values between 1—100 are accepted. Defaults to 100.   
			parameters.Вставить("timeout", Новый Структура("type, req, description", "integer", Ложь, "только для long polling, которого нет в реализации 1С")); //Timeout in seconds for long polling. Defaults to 0, i.e. usual short polling     
						
			//параметры тела ответа
			message = ОбщиеСтруктуры("message");
		
			//[] result
			result = Новый Соответствие;
			result.Вставить("update_id", 	Новый Структура("type, req", "string", Истина));
			result.Вставить("message", 		Новый Структура("type, value", "Frame", message));
			
			//Тело ответа
			body = Новый Соответствие;
			body.Вставить("ok", 		Новый Структура("type, req", "bool", Ложь));
			body.Вставить("result", 	Новый Структура("type, value", "Array", result));
			
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Получает последние, не полученные обновления в чатах с ботом (если не указан offset)");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("pattern", pattern);
			methodContent.Вставить("methodtype", "GET");
			methodContent.Вставить("respondBody", body);
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;
		
		patternMethod = "sendMessage";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
			
			reply_markup = ОбщиеСтруктуры("reply_markup");
		
			parameters = Новый Соответствие;
			parameters.Вставить("chat_id", 	Новый Структура("type, req", "string", Истина)); 				//Unique identifier for the target chat or username of the target channel (in the format @channelusername)     
			parameters.Вставить("text", 	Новый Структура("type, req", "string", Истина)); 				//Text of the message to be sent     
			parameters.Вставить("parse_mode", 	Новый Структура("type, req", "string", Ложь)); 				//Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message.     
			parameters.Вставить("disable_web_page_preview", Новый Структура("type, req", "bool", Ложь)); 	//Disables link previews for links in this message     
			parameters.Вставить("disable_notification", Новый Структура("type, req", "bool", Ложь)); 		//Sends the message silently. iOS users will not receive a notification, Android users will receive a notification with no sound.    
			parameters.Вставить("reply_to_message_id", Новый Структура("type, req", "integer", Ложь)); 		//If the message is a reply, ID of the original message     
			parameters.Вставить("reply_markup", Новый Структура("type, req, value", "Frame", Ложь, reply_markup)); //InlineKeyboardMarkup

			
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Посылает сообщения. Возвращает Message в случае успеха");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("pattern", pattern);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;
		
		
		patternMethod = "editMessageReplyMarkup";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
			
			reply_markup = ОбщиеСтруктуры("reply_markup");
			
			parameters = Новый Соответствие;
			parameters.Вставить("chat_id", 			Новый Структура("type, req", "string", Истина)); 				//Unique identifier for the target chat or username of the target channel (in the format @channelusername)     
			parameters.Вставить("message_id", 		Новый Структура("type, req", "integer", Ложь)); 				//Text of the message to be sent     
			parameters.Вставить("inline_message_id",Новый Структура("type, req", "string", Ложь)); 				//Unique identifier for the target chat or username of the target channel (in the format @channelusername)     
			//parameters.Вставить("parse_mode", 	Новый Структура("type, req", "string", Ложь)); 				//Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message.     
			//parameters.Вставить("disable_web_page_preview", Новый Структура("type, req", "bool", Ложь)); 	//Disables link previews for links in this message     
			//parameters.Вставить("disable_notification", Новый Структура("type, req", "bool", Ложь)); 		//Sends the message silently. iOS users will not receive a notification, Android users will receive a notification with no sound.    
			//parameters.Вставить("reply_to_message_id", Новый Структура("type, req", "integer", Ложь)); 		//If the message is a reply, ID of the original message     
			parameters.Вставить("reply_markup", Новый Структура("type, req, value", "Frame", Ложь, reply_markup)); //InlineKeyboardMarkup

			
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Редактирует сообщение");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("pattern", pattern);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;
		
		patternMethod = "setWebhook";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
			
			//[] allowed_updates
			allowed_updates = Новый Соответствие;
			allowed_updates.Вставить("message", 			Новый Структура("type, req", "string", Ложь));
			allowed_updates.Вставить("edited_channel_post", Новый Структура("type, req", "string", Ложь));
			allowed_updates.Вставить("callback_query", 		Новый Структура("type, req", "string", Ложь));
			
			parameters = Новый Соответствие;
			parameters.Вставить("url", 	Новый Структура("type, req, description", "string", Истина, "https://pmjum4ej0omt.share.zrok.io/scmOpenAPI/hs/OpenAPI/mobile/postWebhookUpdates")); //HTTPS url to send updates to. Use an empty string to remove webhook integration	     
			parameters.Вставить("certificate", 	Новый Структура("type, req, description", "string", Ложь, "для самоподписанных сертификатов")); 	//Upload your public key certificate so that the root certificate in use can be checked. See our self-signed guide for details			     
			parameters.Вставить("ip_address", 	Новый Структура("type, req", "string", Ложь)); 		//The fixed IP address which will be used to send webhook requests instead of the IP address resolved through DNS		     
			parameters.Вставить("max_connections", Новый Структура("type, req", "Integer", Ложь)); 	//Maximum allowed number of simultaneous HTTPS connections to the webhook for update delivery, 1-100. Defaults to 40. 	    
			parameters.Вставить("allowed_updates", Новый Структура("type, req, value", "Array", Ложь, allowed_updates)); //A JSON-serialized list of the update types you want your bot to receive. For example, specify [“message”, “edited_channel_post”, “callback_query”] 
			parameters.Вставить("drop_pending_updates", Новый Структура("type, req", "bool", Ложь)); //Pass True to drop all pending updates		     
			
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Переключает бот в режим посылки сообщений на указанный URL (getUpdates отключен и вызовет ошибку)");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("pattern", pattern);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;
		
		patternMethod = "deleteWebhook";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
									
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Переключает бот в режим получения команд по getUpdates (если режим setWebhook был включен)");
			methodContent.Вставить("pattern", pattern);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;		
		
		patternMethod = "getWebhookInfo";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
						
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Возвращает текущий статус Webhook");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("pattern", pattern);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;
		
		patternMethod = "getFile";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
						
			parameters = Новый Соответствие;
			parameters.Вставить("file_id", 	Новый Структура("type, req, description", "string", Истина, "File identifier to get info about")); 		
			
			//{} result
			result = Новый Соответствие;
			result.Вставить("file_id", 			Новый Структура("type, req", "string", Истина));
			result.Вставить("file_unique_id", 	Новый Структура("type, req", "string", Истина));
			result.Вставить("file_size", 		Новый Структура("type, req", "string", Истина));
			result.Вставить("file_path", 		Новый Структура("type, req", "string", Истина));
			
			//Тело ответа
			body = Новый Соответствие;
			body.Вставить("ok", 		Новый Структура("type, req", "bool", Ложь));
			body.Вставить("result", 	Новый Структура("type, value", "Frame", result));
			
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Use this method to get basic info about a file and prepare it for downloading");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("pattern", pattern);
			methodContent.Вставить("methodtype", "GET");
			methodContent.Вставить("respondBody", body);
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;
				
		patternMethod = "sendSticker";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
			
			parameters = Новый Соответствие;
			parameters.Вставить("chat_id", 	Новый Структура("type, req", "string", Истина)); 				//Unique identifier for the target chat or username of the target channel (in the format @channelusername)     
			parameters.Вставить("sticker", 	Новый Структура("type, req", "string", Истина)); 				//Text of the message to be sent     
			parameters.Вставить("disable_notification", Новый Структура("type, req", "bool", Ложь)); 		//Sends the message silently. iOS users will not receive a notification, Android users will receive a notification with no sound.    
			parameters.Вставить("reply_to_message_id", Новый Структура("type, req", "integer", Ложь)); 		//If the message is a reply, ID of the original message     
			parameters.Вставить("reply_markup", Новый Структура("type, req", "string", Ложь)); 				//InlineKeyboardMarkup      
			
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Посылает стикер (.webp stickers). Возвращает Message в случае успеха");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("pattern", pattern);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;
		
	КонецЕсли;
	#КонецОбласти

	Если inputMethod = "" Тогда 
		Возврат patternContent; 
	Иначе
		Возврат methodContent;  
	КонецЕсли;
	
КонецФункции

//Описание входящих запросов (к нашему сервису)
Функция ОпределенияМетодов(pattern, inputMethod = "") Экспорт

	methodContent = Неопределено;
	patternContent = Новый Соответствие;
	//patternContent.Вставить("version", "v1.03");
	#Область schema
	Если pattern = "/schema/*" Тогда 
		
		patternMethod = "getSchema";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
			parameters = Новый Соответствие;
			parameters.Вставить("version", 		Новый Структура("type, req, description", "string", Ложь, "актуальный номер версии API")); 
			parameters.Вставить("method", 		Новый Структура("type, req, description", "string", Ложь, "имя метода. если не указано - все методы")); 
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Возвращает описание всех методов");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
		КонецЕсли;
		
	#КонецОбласти
	
	#Область prices
	ИначеЕсли pattern = "/prices/{method}" Тогда 
		
		patternMethod = "getPrices";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда
			
			parameters = Новый Соответствие;
			parameters.Вставить("brand", 		Новый Структура("type, ref, req, description", "catalog.BusinessUnit", "name", Истина, "бизнес единица по которой запрашиваются цены")); 
			parameters.Вставить("fullPrice", 	Новый Структура("type, req, description", "bool", Ложь, """Полный прайс"" = True возвращает ""Срез последних действующих цен"". ""Полный прайс"" = False возвращает изменения цен, с даты указанной в параметре ""date"" по текущую дату")); 
			parameters.Вставить("date", 		Новый Структура("type, req, description", "date", Ложь, "дата с которой происходит выборка изменений цен (по текущую дату). игнорируется при fullPrice = True"));
			parameters.Вставить("receiver", 	Новый Структура("type, ref, req, description", "catalog.DataStreamsRecipients", "code", Ложь, "получатель данных. определяет ""Тип цен"" по соответствию в справочнике ""ПолучателиИнформацииПотоковДанных""")); 
			parameters.Вставить("article", 		Новый Структура("type, ref, req, description", "catalog.Номенклатура", "name", Ложь, "отбор по номенклатуре (опциональный). может использоваться для отладки"));
			//Тело ответа
			body = Новый Соответствие;
			body.Вставить("brand",		Новый Структура("type", "string"));
			body.Вставить("receiver", 	Новый Структура("type", "string"));      
			body.Вставить("date", 		Новый Структура("type", "date"));
			body.Вставить("waybillType", 	Новый Структура("type", "string"));
			body.Вставить("fullPrice",	Новый Структура("type", "catalog"));
			body.Вставить("currency", 	Новый Структура("type, description", "string", "валюта. буквенное представление по ОКВ"));
			//[] цен
			offers = Новый Соответствие;
			offers.Вставить("article", 		Новый Структура("type", "string"));
			offers.Вставить("barcode", 		Новый Структура("type", "EAN13"));
			offers.Вставить("color", 		Новый Структура("type", "string"));
			offers.Вставить("firstPrice", 	Новый Структура("type", "integer"));
			offers.Вставить("actualPrice", 	Новый Структура("type", "integer"));
			offers.Вставить("discountPercent",Новый Структура("type", "integer"));
			offers.Вставить("sale", 		Новый Структура("type", "bool"));
			
			body.Вставить("offers", 		Новый Структура("type, value", "Array", offers));
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Возвращает массив актуальных цен по бизнес единице. варианты работы метода в описаниях параметров запроса");
			methodContent.Вставить("requestBody", parameters); //TODO parameters определен как requestBody только для совместимости с существующим сервисом. нет никаких показаний к такому применению тела запроса. переделать обратно на parameters
			methodContent.Вставить("respondBody", body);  
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;
		
	#КонецОбласти
	
	#Область mobile
	ИначеЕсли pattern = "/mobile/{method}" Тогда 
		
		patternMethod = "postWebhookUpdates";
		Если inputMethod = patternMethod  ИЛИ inputMethod = "" Тогда
			
			//Параметр запроса
			parameters = Новый Соответствие; //без параметров
			//получает message при вводе текста, либо callback_query как реакцию на нажатие кнопки inline_keyboard (содержит внутри message)
			//{} from
			from = Новый Соответствие;
			from.Вставить("id", 			Новый Структура("type, description", "integer", ""));
			from.Вставить("is_bot",			Новый Структура("type, description, value", "bool", ""));
			from.Вставить("first_name",		Новый Структура("type, description, value", "string", ""));
			from.Вставить("last_name",		Новый Структура("type, description", "string", ""));
			from.Вставить("language_code",	Новый Структура("type, description, value", "string", "")); 
			//{} message
			message = ОбщиеСтруктуры("message");
			//{} callback_query
			callback_query = Новый Соответствие;
			callback_query.Вставить("id", 				Новый Структура("type, description", "string", "id чата (для sendMessage)"));
			callback_query.Вставить("from",				Новый Структура("type, description, value", "Frame", "", from));			
			callback_query.Вставить("chat_instance", 	Новый Структура("type, description", "string", ""));
			callback_query.Вставить("message", 			Новый Структура("type, value", "Frame", message));
			callback_query.Вставить("data",				Новый Структура("type, description, value", "string", "")); 
			//параметры тела ответа
			body = Новый Соответствие;
			body.Вставить("update_id", 		Новый Структура("type, req", "string", Истина));
			body.Вставить("message", 		Новый Структура("type, value", "Frame", message));
			body.Вставить("callback_query", Новый Структура("type, value", "Frame", callback_query));			
			
			methodContent = Новый Соответствие; // в течении 60 секунд нужен ответ с кодом 200, иначе будет повтор запроса от телеги
			methodContent.Вставить("description", "Обработка входящего запроса от telegram (только при включенном setWebhook)");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("requestBody", body);
			methodContent.Вставить("respondBody", ОбщиеСтруктуры("BasicPostRespond"));
			methodContent.Вставить("methodtype", "POST");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;	
		
		patternMethod = "getWayBillList";
		Если inputMethod = patternMethod  ИЛИ inputMethod = "" Тогда
			
			//Параметр запроса
			parameters = Новый Соответствие;
			parameters.Вставить("top", 			Новый Структура("type, req, description", "integer", Ложь, "Ограничение по количеству возвращаемых элементов. Для top=0 или <пусто> возвращаются все элементы")); 
			parameters.Вставить("waybillGuid",	Новый Структура("type, ref, req", "document.WayBill", "ID", Ложь));      
			parameters.Вставить("testMode", 	Новый Структура("type, req, description", "string", Ложь, "Не инициировать отправку заказов в шину")); 
			//Список заказов
			body = Новый Соответствие;
			body.Вставить("qtyTotal", 		Новый Структура("type, value", "integer", "WayBillList.Total"));
			List = Новый Соответствие;
			List.Вставить("waybillGuid",		Новый Структура("type, ref", "document.WayBill", "ID"));
			List.Вставить("waybillDate", 		Новый Структура("type", "date"));
			body.Вставить("waybillList", 		Новый Структура("type, value", "Array", List));
			
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Возвращает список Накладных, зарегистрированных в узле");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("respondBody", body);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;	
		
		patternMethod = "getWayBillData";
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда 
			
			//Параметры запроса
			parameters = Новый Соответствие;
			parameters.Вставить("waybillGuid", 		Новый Структура("type, ref, req", "document.WayBill", "ID", Истина));      
			//Реквизиты документа
			body = Новый Соответствие;
			body.Вставить("waybillGuid",	Новый Структура("type, ref", "document.WayBill", "ID"));
			body.Вставить("waybillName", 	Новый Структура("type", "string"));      
			body.Вставить("waybillDate", 	Новый Структура("type", "date"));
			body.Вставить("comment", 		Новый Структура("type, description", "string", "комментарий (200 символов)"));      
			body.Вставить("qtyTotal",		Новый Структура("type, description", "integer", "Итог количества по документу"));
			//[] Товары
			Items = ОбщиеСтруктуры("WayBillItems");
			body.Вставить("items", 			Новый Структура("type, value", "Array", Items));
						
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Возвращает данные Накладные на выполнение работ");
			methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("respondBody", body);
			methodContent.Вставить("methodtype", "GET");
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;	
		
		patternMethod = "postWayBillData"; 
		Если inputMethod = patternMethod ИЛИ inputMethod = "" Тогда 
			
			body = Новый Соответствие;
			body.Вставить("waybillGuid",	Новый Структура("type, ref", "document.WayBill", "ID"));
			body.Вставить("waybillName", 	Новый Структура("type", "string"));      
			body.Вставить("waybillDate", 	Новый Структура("type", "date"));
			body.Вставить("comment", 		Новый Структура("type, description", "string", "комментарий (200 символов)"));      
			body.Вставить("qtyTotal",		Новый Структура("type, description", "integer", "Итог количества по документу"));
			//[] Товары
			Items = ОбщиеСтруктуры("WayBillItems");
			body.Вставить("items", 			Новый Структура("type, value", "Array", Items));
						
			methodContent = Новый Соответствие;
			methodContent.Вставить("description", "Возвращает данные Заказа на перемещение");
			//methodContent.Вставить("parameters", parameters);
			methodContent.Вставить("requestBody", body);
			methodContent.Вставить("methodtype", "POST");
			methodContent.Вставить("respondBody", ОбщиеСтруктуры("BasicPostRespond")); //результат приема документа будет помещаться в блок, унифицированный в входящим блоком Properties 
			patternContent.Вставить(pattern + patternMethod, methodContent);
			
		КонецЕсли;	
				
	#КонецОбласти
		
	КонецЕсли;
	
	Если methodContent = Неопределено Тогда 
		parameters = Новый Соответствие;
		parameters.Вставить("inputMethod", inputMethod); 
		methodContent = Новый Соответствие;
		methodContent.Вставить("undefinedMethod", parameters);
	КонецЕсли;	
	
	Если inputMethod = "" Тогда 
		Возврат patternContent; 
	Иначе
		Возврат methodContent;  
	КонецЕсли;
	
КонецФункции

#КонецОбласти 

#Область ОбщиеСтруктуры

//Общеприменяемые структуры
Функция ОбщиеСтруктуры(ИмяСтруктуры) Экспорт 
				
	Если ИмяСтруктуры = "WayBillProperties" Тогда  
		Properties = Новый Соответствие;
		Properties.Вставить("stickStickers",	Новый Структура("type, description", "bool", "необходима перемаркировка (WB)")); //stickesRePrintRequired
		Properties.Вставить("waybillCanceled",	Новый Структура("type, description", "bool", "заказ (весь) отменен. (необходимо перенести в признак магазина)"));
		Properties.Вставить("extra",			Новый Структура("type, description", "bool", "разрешение scmНакладныеНаВыполнениеРабот в любых количествах, чего угодно")); //РазрешеноПревышениеЗаказа
		Properties.Вставить("waybillType", 		Новый Структура("type, description", "string", "Возврат для Фамилия, Возврат для WB СПб,…"));
		Properties.Вставить("deliveryType",		Новый Структура("type, description", "string", "в этой версии принимает значения: Самовывоз, Транспортная служба"));
		Properties.Вставить("checkMarking",		Новый Структура("type, description", "bool", "проверка на коды маркировки обязательна")); //labelCodeRequired
		Возврат Properties;
	КонецЕсли;
	
	Если ИмяСтруктуры = "ShopProperties" Тогда  
		Properties = Новый Соответствие;
		Properties.Вставить("isStarted",		Новый Структура("type, description", "bool", "scmНакладныеНаВыполнениеРабот начата"));
		Properties.Вставить("isBlocked",		Новый Структура("type, description", "bool", "scmНакладныеНаВыполнениеРабот начата на устройстве")); 
		Properties.Вставить("blockedBy", 		Новый Структура("type, description", "string", "имя устройства в котором ведется сборка (шина игнорирует это поле, заполняя по данным header = user-agent)")); 
		Properties.Вставить("isCanceled", 		Новый Структура("type, description", "bool", "scmНакладныеНаВыполнениеРабот отменена"));
		Properties.Вставить("isFinished",		Новый Структура("type, description", "bool", "scmНакладныеНаВыполнениеРабот завершена"));
		Возврат Properties;
	КонецЕсли;
	
	Если ИмяСтруктуры = "BoxCommitProperties" Тогда  
		Properties = Новый Соответствие;
		Properties.Вставить("isCommit", 		Новый Структура("type, req, description", "bool", Истина, "Упешно записан в 1С")); 
		Properties.Вставить("isError", 			Новый Структура("type, req, description", "bool", Истина, "Ошибка проведения в 1С")); 
		Properties.Вставить("description", 		Новый Структура("type, req, description", "string", Истина, "Описание состояния документа в 1С")); 
		//Properties.Вставить("updatedBy", 		Новый Структура("type, req, description", "string", Ложь, "идентификатор активного собирающего устройства. пример: 1C, <serial_number>"));
		//Properties.Вставить("lastUpdated",	Новый Структура("type, req, description", "date", Ложь, "дата последнего обновления"));
		Возврат Properties;
	КонецЕсли;
		
	Если ИмяСтруктуры = "scmНакладныеНаВыполнениеРабот" Тогда  
		Boxes = Новый Соответствие;
		Boxes.Вставить("document",		Новый Структура("type, req, description", "string", Истина, "составной ключ GUID||shopCode. пример: e757e1fd-a66e-11eb-8109-00155d0b173f||000001088")); 
		Boxes.Вставить("shopCode", 		Новый Структура("type, ref, req", "catalog.Склады", "code", Истина));
		Boxes.Вставить("GUID",			Новый Структура("type, ref, req", "document.WayBill", "ID", Истина)); 
		Boxes.Вставить("boxDate", 		Новый Структура("type, req", "date", Истина));
		Boxes.Вставить("boxId", 		Новый Структура("type, ref, req, description", "document.Box", "structure", Истина, "уникальный номер коробки")); 
		Boxes.Вставить("lastUpdated", 	Новый Структура("type, req", "date", Ложь));
		Возврат Boxes;
	КонецЕсли;
	
	Если ИмяСтруктуры = "Items" Тогда  
		Items = Новый Соответствие;
		Items.Вставить("itemName", 		Новый Структура("type, description", "string", "представление значений строки items в формате: Наименование Артикул-Цвет-Размер-Рост"));
		Items.Вставить("barcode", 		Новый Структура("type, ref, req", "EAN13_struct", "structure", Истина));
		Items.Вставить("article", 		Новый Структура("type, req", "string", Ложь));
		//Items.Вставить("qtyScanned", 	Новый Структура("type, req", "integer", Истина));
		//Items.Вставить("qtyPlanned", 	Новый Структура("type, req", "integer", Истина));
		Возврат Items;
	КонецЕсли;
	
	Если ИмяСтруктуры = "WayBillItems" Тогда  
		Items = Новый Соответствие;
	//	Items.Вставить("barcode", 		Новый Структура("type, req", "string", Истина));
		Items.Вставить("qty", 			Новый Структура("type", "integer"));
		Items.Вставить("itemName", 		Новый Структура("type, description", "string", "представление значений строки items в формате: Наименование Артикул-Цвет-Размер-Рост"));
		Items.Вставить("article", 		Новый Структура("type, req", "string", Ложь));
		Возврат Items;
	КонецЕсли;
	
	Если ИмяСтруктуры = "Datamatrix" Тогда  
		Datamatrix = Новый Соответствие;
		Datamatrix.Вставить("quarantine", 	Новый Структура("type, req, description", "bool", Ложь, "признак того что КМ не прошел проверку (используется только на стороне SO2)"));
		Datamatrix.Вставить("uit", 			Новый Структура("type, ref, req", "QRCode_struct", "structure", Истина));
		Datamatrix.Вставить("lastUpdated", 	Новый Структура("type, req", "date", Ложь));
		Возврат Datamatrix;
	КонецЕсли;
	
	Если ИмяСтруктуры = "BasicPostRespond" Тогда  
		Properties = Новый Соответствие;
		Properties.Вставить("code",			Новый Структура("type, description", "integer", "код ответа сервера"));
		Properties.Вставить("type",			Новый Структура("type, description", "string", "внутренне представление объека сервера"));
		Properties.Вставить("description",	Новый Структура("type, description", "string", "описание результат выполнения запроса"));
		Возврат Properties;
	КонецЕсли;
	
	Если ИмяСтруктуры = "message" Тогда  
		//[] photo
		photo = Новый Соответствие;
		photo.Вставить("file_id", 		Новый Структура("type", "string"));
		photo.Вставить("file_unique_id",Новый Структура("type", "string"));
		photo.Вставить("file_size", 	Новый Структура("type", "integer"));
		photo.Вставить("width", 		Новый Структура("type", "integer"));
		photo.Вставить("height", 		Новый Структура("type", "integer"));
		
		//[] entities
		entities = Новый Соответствие;
		entities.Вставить("offset", 	Новый Структура("type", "integer"));
		entities.Вставить("length", 	Новый Структура("type", "integer"));
		entities.Вставить("type", 		Новый Структура("type", "string"));
		
		//{} chat
		chat = Новый Соответствие;
		chat.Вставить("id", 			Новый Структура("type, description", "string", "id чата (для sendMessage)"));
		chat.Вставить("title", 			Новый Структура("type, description", "string", ""));
		chat.Вставить("first_name",		Новый Структура("type, description, value", "string", ""));
		chat.Вставить("last_name",		Новый Структура("type, description", "string", ""));
		chat.Вставить("type",			Новый Структура("type, description, value", "string", "")); 
		
		//{} from
		from = Новый Соответствие;
		from.Вставить("id", 			Новый Структура("type, description", "integer", ""));
		from.Вставить("is_bot",			Новый Структура("type, description, value", "bool", ""));
		from.Вставить("first_name",		Новый Структура("type, description, value", "string", ""));
		from.Вставить("last_name",		Новый Структура("type, description", "string", ""));
		from.Вставить("language_code",	Новый Структура("type, description, value", "string", "")); 
		from.Вставить("username",		Новый Структура("type, description", "string", "")); //только для callback_query
		
		//{} reply_to_message
		reply_to_message = Новый Соответствие;
		reply_to_message.Вставить("message_id", 	Новый Структура("type, description", "integer", ""));
		reply_to_message.Вставить("from",			Новый Структура("type, description, value", "Frame", "", from));			
		reply_to_message.Вставить("chat",			Новый Структура("type, description, value", "Frame", "", chat));
		reply_to_message.Вставить("date",			Новый Структура("type, description", "date", ""));
		reply_to_message.Вставить("text",			Новый Структура("type, description", "string", ""));
		
		//{} message
		message = Новый Соответствие;
//			message.Вставить("reply_to_message",Новый Структура("type, description, value, req", "Frame", "эта структура удалена из спецификации", reply_to_message, Ложь));  //
		message.Вставить("message_id", 		Новый Структура("type, description", "integer", ""));
		message.Вставить("from",			Новый Структура("type, description, value", "Frame", "", from));
		message.Вставить("chat",			Новый Структура("type, description, value", "Frame", "", chat));
		message.Вставить("text",			Новый Структура("type, description", "string", ""));
		message.Вставить("entities",		Новый Структура("type, description, value", "Array", "", entities)); 
		message.Вставить("date",			Новый Структура("type, description", "date", ""));
		message.Вставить("photo",			Новый Структура("type, description, value, req", "Array", "", photo, Ложь));
		Возврат message;
	КонецЕсли;
	
	
	Если ИмяСтруктуры = "reply_markup" Тогда  
			//[] KeyboardButton //Простые кнопки с текстом, нажатие возвращает текст как ответ пользователя. который будет обработан как ответ (тип Message)
			button = Новый Соответствие;
			button.Вставить("text", 	Новый Структура("type, req", "string", Истина)); 		//Label text on the button 		
			//button.Вставить("request_contact", 	Новый Структура("type, req", "bool", Ложь)); 	     
			//button.Вставить("request_location", 	Новый Структура("type, req", "bool", Ложь)); 	     
		//	button.Вставить("request_poll", 	Новый Структура("type, req", "string", Ложь)); //KeyboardButtonPollType This object represents type of a poll, which is allowed to be created and sent when the corresponding button is presse	     
			
			//[] keyboard  
			keyboard = Новый Соответствие;
			keyboard.Вставить("button", Новый Структура("type, req, value", "Array", Истина, button)); 
			
			
			//[] InlineKeyboardButton //Кнопки с приязкой к сообщению и действием callback_data. Нажатие возвращает колбэк (тип CallbackQuery)
			button = Новый Соответствие;
			button.Вставить("text", 	Новый Структура("type, req", "string", Истина)); 		//Label text on the button 		
			button.Вставить("callback_data", 	Новый Структура("type, req", "string", Ложь)); 	//Data to be sent in a callback query to the bot when button is pressed, 1-64 bytes!!!      
			
			//[] inline_keyboard
			inline_keyboard = Новый Соответствие;
			inline_keyboard.Вставить("button", Новый Структура("type, req, value", "Array", Истина, button)); 
			
			//{} reply_markup 
			reply_markup = Новый Структура;
			reply_markup.Вставить("keyboard", Новый Структура("type, req, value", "Array", Истина, keyboard)); 
			reply_markup.Вставить("inline_keyboard", Новый Структура("type, req, value", "Array", Истина, inline_keyboard)); 
			reply_markup.Вставить("resize_keyboard", 	Новый Структура("type", "bool"));  //уменьшать размер  KeyboardButton
			reply_markup.Вставить("one_time_keyboard", 	Новый Структура("type", "bool"));  //Requests clients to hide the keyboard as soon as it's been used.
		//	reply_markup.Вставить("input_field_placeholder", Новый Структура("type", "string")); //The placeholder to be shown in the input field when the keyboard is active; 1-64 characters
			reply_markup.Вставить("selective", Новый Структура("type", "bool"));  //Use this parameter if you want to show the keyboard to specific users only.
		Возврат reply_markup;
	КонецЕсли;
	

КонецФункции	

#КонецОбласти 

#Область Фасеты

Функция Debug() Экспорт
	Значение = Новый Соответствие();
	Значение.Вставить("DoNotWriteDoc");
	Значение.Вставить("ReturnParameters");
	Возврат Значение;	
КонецФункции

Функция LabelSize() Экспорт 
	Значение = Новый Соответствие();
	Значение.Вставить("20x40", "20x40");
	Значение.Вставить("40x60", "40x60");
	Возврат Значение;	
КонецФункции

Функция PageOrientation() Экспорт  
	Значение = Новый Соответствие();
	Значение.Вставить("portrait", "portrait");
	Значение.Вставить("landscape", "landscape");
	Возврат Значение;	
КонецФункции

#КонецОбласти

#Область Служебные

// Возвращает код основного языка конфигурации, например "ru".
Функция КодОсновногоЯзыка() Экспорт
	
	Возврат Метаданные.ОсновнойЯзык.КодЯзыка;
	
КонецФункции

#КонецОбласти

Функция СостоянияБота(ИмяМакета = "ТаблицаСостояний") Экспорт
	
	Состояния = Новый Структура;
    Макет = Обработки.scmОбработкаТелеграмБот.ПолучитьМакет(ИмяМакета);
	ИмяОбласти = "R1C2:R" + Формат(Макет.ВысотаТаблицы, "ЧГ=") + "C1";
    ПостроительЗапроса = Новый ПостроительЗапроса;
    ПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(Макет.Область(ИмяОбласти));
    ПостроительЗапроса.Выполнить();
	Для Каждого т Из ПостроительЗапроса.Результат.Выгрузить() Цикл 
		Состояния.Вставить(т.Ключ, т.Значение);	
	КонецЦикла;	
    Возврат Состояния;
   
КонецФункции

Функция МассивСостоянияБота() Экспорт
	
	МассивСостоянияБота = Новый Массив;
	Состояния = СостоянияБота();
	Для Каждого м Из Состояния Цикл 
		МассивСостоянияБота.Добавить(м.Ключ);	
	КонецЦикла;	
    Возврат МассивСостоянияБота;
   
КонецФункции

