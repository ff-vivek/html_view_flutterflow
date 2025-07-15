import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/html_service.dart';

class AmexHtmlDisplay extends StatefulWidget {
  final String? initialHtmlPath;
  final double? height;
  final bool showFullPage;

  const AmexHtmlDisplay({
    Key? key,
    this.initialHtmlPath = 'amex-navigation.html',
    this.height,
    this.showFullPage = false,
  }) : super(key: key);

  @override
  State<AmexHtmlDisplay> createState() => _AmexHtmlDisplayState();
}

class _AmexHtmlDisplayState extends State<AmexHtmlDisplay> {
  String _htmlContent = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadHtmlContent();
  }

  Future<void> _loadHtmlContent() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      String htmlContent;
      if (widget.initialHtmlPath == 'credit-cards.html') {
        htmlContent = await HtmlService.getCreditCardsPage();
      } else {
        htmlContent = await HtmlService.getAmexNavigation();
      }

      setState(() {
        _htmlContent = htmlContent;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _htmlContent = _getErrorHtml(e.toString());
      });
    }
  }

  String _getErrorHtml(String error) {
    return '''
      <div style="
        padding: 20px;
        text-align: center;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 10px;
        margin: 20px;
        font-family: Arial, sans-serif;
      ">
        <h2>🚫 Unable to Load Content</h2>
        <p>Error: $error</p>
        <p style="font-size: 14px; opacity: 0.8; margin-top: 20px;">
          Make sure the server is running:<br>
          <code style="background: rgba(255,255,255,0.2); padding: 4px 8px; border-radius: 4px;">python3 server.py</code>
        </p>
      </div>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: widget.height ?? 300,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006fcf)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading Amex Content...',
                style: TextStyle(
                  color: Color(0xFF006fcf),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: widget.showFullPage ? null : (widget.height ?? 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          child: Html(
            data: _htmlContent,
            // Basic styling - simplified approach
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontFamily: 'HelveticaNeue, Arial, sans-serif',
                backgroundColor: Colors.white,
              ),
              "h1": Style(
                color: const Color(0xFF006fcf),
                fontSize: FontSize(24),
                fontWeight: FontWeight.bold,
              ),
              "h2": Style(
                color: const Color(0xFF333333),
                fontSize: FontSize(20),
                fontWeight: FontWeight.w600,
              ),
              "p": Style(
                color: const Color(0xFF555555),
                fontSize: FontSize(16),
                lineHeight: LineHeight(1.6),
              ),
              "a": Style(
                color: const Color(0xFF006fcf),
                textDecoration: TextDecoration.none,
              ),
              // Navigation specific styles
              ".amex-header": Style(
                backgroundColor: Colors.white,
                padding: HtmlPaddings.symmetric(vertical: 10, horizontal: 20),
              ),
              ".nav-link": Style(
                color: const Color(0xFF333333),
                fontSize: FontSize(16),
                fontWeight: FontWeight.w500,
                textDecoration: TextDecoration.none,
                padding: HtmlPaddings.all(8),
              ),
              ".logo": Style(
                color: const Color(0xFF006fcf),
                fontSize: FontSize(18),
                fontWeight: FontWeight.bold,
              ),
              ".login-btn": Style(
                backgroundColor: const Color(0xFF006fcf),
                color: Colors.white,
                padding: HtmlPaddings.symmetric(vertical: 8, horizontal: 16),
                // borderRadius: BorderRadius.circular(20),
              ),
            },
            // Handle link taps
            onLinkTap: (url, _, __) {
              if (url != null) {
                _handleLinkTap(url);
              }
            },
          ),
        ),
      ),
    );
  }

  void _handleLinkTap(String url) {
    print('Link tapped: $url');

    // Handle internal navigation
    if (url.contains('credit-cards.html')) {
      _navigateToPage('credit-cards.html');
    } else if (url.contains('amex-navigation.html')) {
      _navigateToPage('amex-navigation.html');
    } else if (url.startsWith('http')) {
      // Handle external links
      _launchUrl(url);
    } else {
      // Handle other internal links
      print('Internal link: $url');
    }
  }

  Future<void> _navigateToPage(String htmlPage) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String htmlContent;
      if (htmlPage == 'credit-cards.html') {
        htmlContent = await HtmlService.getCreditCardsPage();
      } else {
        htmlContent = await HtmlService.getAmexNavigation();
      }

      setState(() {
        _htmlContent = htmlContent;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _htmlContent = _getErrorHtml(e.toString());
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
    }
  }
}

// Specialized widget for navigation only
class AmexNavigationDisplay extends StatelessWidget {
  final double height;

  const AmexNavigationDisplay({
    Key? key,
    this.height = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmexHtmlDisplay(
      initialHtmlPath: 'amex-navigation.html',
      height: height,
      showFullPage: false,
    );
  }
}

// Specialized widget for full credit cards page
class AmexCreditCardsDisplay extends StatelessWidget {
  const AmexCreditCardsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmexHtmlDisplay(
      initialHtmlPath: 'credit-cards.html',
      showFullPage: true,
    );
  }
}
