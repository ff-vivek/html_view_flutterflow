import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/html_service.dart';

class AmexWebViewWidget extends StatefulWidget {
  final String? initialHtmlPath;
  final double? height;
  final bool showFullPage;

  const AmexWebViewWidget({
    Key? key,
    this.initialHtmlPath = 'amex-navigation.html',
    this.height,
    this.showFullPage = false,
  }) : super(key: key);

  @override
  State<AmexWebViewWidget> createState() => _AmexWebViewWidgetState();
}

class _AmexWebViewWidgetState extends State<AmexWebViewWidget> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
            print('WebView error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation request: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );

    _loadHtmlContent();
  }

  Future<void> _loadHtmlContent() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Check if server is running
      bool serverRunning = await HtmlService.isServerRunning();

      if (serverRunning) {
        // Load from server
        String url = 'http://localhost:8000/${widget.initialHtmlPath}';
        await _controller.loadRequest(Uri.parse(url));
      } else {
        // Load error HTML
        String errorHtml = _getErrorHtml();
        await _controller.loadHtmlString(errorHtml);
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });

      String errorHtml = _getErrorHtml(e.toString());
      await _controller.loadHtmlString(errorHtml);
    }
  }

  String _getErrorHtml([String? error]) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            animation: fadeIn 0.5s ease-in;
          }
          @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
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
          .retry-button {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 1rem;
            cursor: pointer;
            margin-top: 20px;
            transition: all 0.3s ease;
          }
          .retry-button:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
          }
        </style>
      </head>
      <body>
        <div class="error-container">
          <div class="error-icon">🚫</div>
          <div class="error-title">Unable to Load Content</div>
          <div class="error-message">
            ${error ?? 'Could not connect to the HTML server.'}
          </div>
          <div class="error-instructions">
            Please start the server by running:<br>
            <code>python3 server.py</code><br>
            in your project directory.
          </div>
          <button class="retry-button" onclick="location.reload()">
            🔄 Retry
          </button>
        </div>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.showFullPage ? null : (widget.height ?? 300),
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF006fcf)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading Amex Navigation...',
                      style: TextStyle(
                        color: Color(0xFF006fcf),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Method to refresh the content
  Future<void> refresh() async {
    await _loadHtmlContent();
  }

  // Method to navigate to a specific page
  Future<void> navigateTo(String htmlPath) async {
    try {
      String url = 'http://localhost:8000/$htmlPath';
      await _controller.loadRequest(Uri.parse(url));
    } catch (e) {
      print('Navigation error: $e');
    }
  }
}

// Specialized widget for navigation only
class AmexNavigationWidget extends StatelessWidget {
  final double height;

  const AmexNavigationWidget({
    Key? key,
    this.height = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmexWebViewWidget(
      initialHtmlPath: 'amex-navigation.html',
      height: height,
      showFullPage: false,
    );
  }
}

// Specialized widget for full credit cards page
class AmexCreditCardsWidget extends StatelessWidget {
  const AmexCreditCardsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmexWebViewWidget(
      initialHtmlPath: 'credit-cards.html',
      showFullPage: true,
    );
  }
}
