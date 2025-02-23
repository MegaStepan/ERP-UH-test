&НаСервереБезКонтекста
// Функция - Конвертировать hex в dec
//
Функция КонвертироватьHexВDec(Знач ЧислоСтрокой) Экспорт
	
	Результат = 0;
	Шаблон = "0123456789ABCDEF";
	
	ЧислоСтрокой = ВРег(Строка(ЧислоСтрокой));
    Для ТекущийСимвол = 1 По СтрДлина(ЧислоСтрокой) Цикл
        ПозицияВШаблоне = Найти(Шаблон, Сред(ЧислоСтрокой, ТекущийСимвол, 1))-1;
        Результат = Результат * СтрДлина(Шаблон) + ПозицияВШаблоне;
    КонецЦикла;

    Возврат Результат;

КонецФункции

// Функция конвертирует hex в dec
//
Функция КонвертироватьHexВDec(Знач ЧислоСтрокой)
    
    Результат = 0;
    Шаблон = "0123456789ABCDEF";
    
    ЧислоСтрокой = ВРег(Строка(ЧислоСтрокой));
    Для ТекущийСимвол = 1 По СтрДлина(ЧислоСтрокой) Цикл
        ПозицияВШаблоне = Найти(Шаблон, Сред(ЧислоСтрокой, ТекущийСимвол, 1))-1;
        Результат = Результат * СтрДлина(Шаблон) + ПозицияВШаблоне;
    КонецЦикла;
    
    Возврат Результат;

КонецФункции

&НаСервере
// Функция загружает данные из макета в таблицу значений
//
Функция ЗагрузитьТаблицуИзМакета(ИмяМакета, ИмяОбласти) Экспорт
    
    Макет = ПолучитьОбщийМакет(ИмяМакета);
    ПостроительЗапроса = Новый ПостроительЗапроса;
    ПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(Макет.Область(ИмяОбласти));
    ПостроительЗапроса.Выполнить();
        
    Возврат ПостроительЗапроса.Результат.Выгрузить();
    
КонецФункции

Функция scmВыполнитьОбработкуСообщенийЧатБотов() Экспорт 
	
	RespondBodyJSON = "";
	Если Константы.scmИспользоватьТелеграмБоты.Получить() Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ПП.Ссылка КАК Ссылка,
		               |	ПП.Наименование КАК ИмяСервиса,
		               |	ПП.АдресРесурса КАК АдресРесурса,
		               |	ПП.ХостСервера КАК ХостСервера,
		               |	ПП.ПортСервера КАК ПортСервера,
		               |	ПП.Пароль КАК Пароль,
		               |	ПП.ЗащищенноеСоединение КАК ЗащищенноеСоединение
		               |ИЗ
		               |	Справочник.scmВнешниеСервисы_ПараметрыСоединения КАК ПП
		               |ГДЕ
		               |	ПП.ЭтоБот = ИСТИНА
		               |	И ПП.Активно = ИСТИНА
		               |	И ПП.ПометкаУдаления = ЛОЖЬ";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			RespondBodyJSON = Обработки.scmОбработкаТелеграмБот.Обработать_getUpdatesНаСервере(Выборка.Ссылка);		
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат RespondBodyJSON;
	
КонецФункции
