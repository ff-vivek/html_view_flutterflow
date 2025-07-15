import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

class HtmlService {
  static const String baseUrl = 'http://localhost:8000';

  /// Fetch HTML content from the server
  static Future<String> fetchHtmlContent(String path) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$path'),
        headers: {
          'Accept': 'text/html',
          'User-Agent': 'Flutter App',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load HTML: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching HTML: $e');
      return _getErrorHtml('Failed to load content: $e');
    }
  }

  /// Get Bank navigation HTML
  static Future<String> getBankNavigation() async {
    return await fetchHtmlContent('bank-navigation.html');
  }

  /// Get credit cards HTML
  static Future<String> getCreditCardsPage() async {
    return await fetchHtmlContent('credit-cards.html');
  }

  /// Check if server is running
  static Future<bool> isServerRunning() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      return response.statusCode == 200 || response.statusCode == 301;
    } catch (e) {
      return false;
    }
  }

  /// Get error HTML when server is not available
  static String _getErrorHtml(String message) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>Server Error</title>
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
          }
          .error-container {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 40px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            max-width: 500px;
          }
          .error-icon {
            font-size: 4rem;
            margin-bottom: 20px;
          }
          .error-title {
            font-size: 2rem;
            margin-bottom: 15px;
            font-weight: 600;
          }
          .error-message {
            font-size: 1.1rem;
            margin-bottom: 25px;
            opacity: 0.9;
            line-height: 1.6;
          }
          .error-instructions {
            font-size: 0.9rem;
            opacity: 0.8;
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
          }
        </style>
      </head>
      <body>
        <div class="error-container">
          <div class="error-icon">ð«</div>
          <div class="error-title">Server Not Available</div>
          <div class="error-message">$message</div>
          <div class="error-instructions">
            Please start the server by running:<br>
            <code>python3 server.py</code>
          </div>
        </div>
      </body>
      </html>
    ''';
  }
}
