//////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

//#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Основные процедуры и функции.

// Возвращает текущего пользователя или текущего внешнего пользователя,
// в зависимости от того, кто выполнил вход в сеанс.
//  Рекомендуется использовать в коде, который поддерживает работу в обоих случаях.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи - пользователь
//    или внешний пользователь.
//
Функция АвторизованныйПользователь() Экспорт
	
	Возврат ПользователиСлужебный.АвторизованныйПользователь();
	
КонецФункции
