import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/html_service.dart';
import 'package:flutter_html_all/flutter_html_all.dart';

class AmexHtmlWidget extends StatefulWidget {
  final String? initialHtmlPath;
  final double? height;
  final bool showFullPage;

  const AmexHtmlWidget({
    Key? key,
    this.initialHtmlPath = 'amex-navigation.html',
    this.height,
    this.showFullPage = false,
  }) : super(key: key);

  @override
  State<AmexHtmlWidget> createState() => _AmexHtmlWidgetState();
}

class _AmexHtmlWidgetState extends State<AmexHtmlWidget> {
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
      ">
        <h2>🚫 Unable to Load Content</h2>
        <p>Error: $error</p>
        <p style="font-size: 14px; opacity: 0.8; margin-top: 20px;">
          Make sure the server is running:<br>
          <code>python3 server.py</code>
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
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006fcf)),
          ),
        ),
      );
    }

    return Container(
      height: widget.showFullPage ? null : (widget.height ?? 300),
      child: SingleChildScrollView(
        child: Html(
          data: _htmlContent,
          style: {
            // Global styles
            "body": Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontFamily: 'HelveticaNeue, Helvetica Neue, Arial, sans-serif',
            ),
            // Navigation styles
            ".amex-header": Style(
              backgroundColor: Colors.white,
              border: const Border(
                bottom: BorderSide(color: Color(0xFFe5e5e5), width: 1),
              ),
            ),
            ".main-nav": Style(
              display: Display.flex,
              listStyleType: ListStyleType.none,
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
            ".nav-link": Style(
              color: const Color(0xFF333333),
              textDecoration: TextDecoration.none,
              fontSize: FontSize(16),
              fontWeight: FontWeight.w500,
              padding: HtmlPaddings.symmetric(vertical: 8),
            ),
            ".logo": Style(
              color: const Color(0xFF006fcf),
              fontSize: FontSize(18),
              fontWeight: FontWeight.bold,
              textDecoration: TextDecoration.none,
            ),
            ".search-input": Style(
              padding: HtmlPaddings.all(10),
              border: Border.all(color: const Color(0xFFe5e5e5), width: 2),
              // borderRadius: BorderRadius.circular(24),
              fontSize: FontSize(14),
            ),
            ".login-btn": Style(
              backgroundColor: const Color(0xFF006fcf),
              color: Colors.white,
              padding: HtmlPaddings.symmetric(vertical: 10, horizontal: 24),
              // borderRadius: BorderRadius.circular(25),
              textDecoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
            ),
            // Credit cards page styles
            ".hero": Style(
              backgroundColor: const Color(0xFF667eea),
              color: Colors.white,
              padding: HtmlPaddings.all(60),
              textAlign: TextAlign.center,
            ),
            ".hero h1": Style(
              fontSize: FontSize(48),
              fontWeight: FontWeight.w700,
              margin: Margins.only(bottom: 24),
            ),
            ".card-item": Style(
              // borderRadius: BorderRadius.circular(20),
              padding: HtmlPaddings.all(20),
              margin: Margins.only(bottom: 20),
              backgroundColor: Colors.white,
            ),
          },
          onLinkTap: (url, attributes, element) {
            _handleLinkTap(url, attributes, element);
          },
          // onImageTap: (src, attributes, element) {
          //   print('Image tapped: $src');
          // },
        ),
      ),
    );
  }

  void _handleLinkTap(
      String? url, Map<String, String> attributes, _) {
    if (url == null) return;

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
class AmexNavigationWidget extends StatelessWidget {
  final double height;

  const AmexNavigationWidget({
    Key? key,
    this.height = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmexHtmlWidget(
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
    return AmexHtmlWidget(
      initialHtmlPath: 'credit-cards.html',
      showFullPage: true,
    );
  }
}
