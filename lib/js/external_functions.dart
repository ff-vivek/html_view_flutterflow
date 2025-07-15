import 'dart:js_interop';

@JS('parent.toggleBankHeader')
external void toggleBankHeader();

@JS('parent.showBankHeader')
external void showHeader();

@JS('parent.hideBankHeader')
external void hideHeader();

@JS('console.log')
external void consoleLog(String message);

@JS('parent.testFunction')
external void testFunction();