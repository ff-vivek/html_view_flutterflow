import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class AmexIframeWidget extends StatefulWidget {
  final String htmlPath;
  final double? height;
  final bool showFullPage;
  final VoidCallback? onLoad;
  final VoidCallback? onError;

  const AmexIframeWidget({
    Key? key,
    this.htmlPath = 'amex-navigation.html',
    this.height,
    this.showFullPage = false,
    this.onLoad,
    this.onError,
  }) : super(key: key);

  @override
  State<AmexIframeWidget> createState() => _AmexIframeWidgetState();
}

class _AmexIframeWidgetState extends State<AmexIframeWidget> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.showFullPage ? null : (widget.height ?? 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // The iframe itself
            HtmlElementView.fromTagName(
              tagName: 'iframe',
              onElementCreated: (element) {
                final iframe = element as web.HTMLIFrameElement;

                // Configure iframe source and properties
                iframe.src = 'http://localhost:8000/${widget.htmlPath}';
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.border = 'none';
                iframe.style.backgroundColor = 'white';
                iframe.style.borderRadius = '12px';

                // Enable JavaScript and allow navigation
                iframe.allow = 'navigation-top';
                                 // Sandbox restrictions removed for better compatibility

                // Handle successful load
                iframe.onLoad.listen((event) {
                  setState(() {
                    _isLoading = false;
                    _hasError = false;
                  });

                  widget.onLoad?.call();

                  print('✅ ${widget.htmlPath} loaded successfully in Flutter');

                  // Note: Custom CSS injection would require additional setup
                  // for cross-origin communication. The HTML files already
                  // have responsive design built-in.
                });

                // Handle load errors
                iframe.onError.listen((event) {
                  setState(() {
                    _isLoading = false;
                    _hasError = true;
                  });

                  widget.onError?.call();

                  print(
                      '❌ Error loading ${widget.htmlPath}: Make sure server is running on localhost:8000');
                });

                // Start loading immediately
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
              },
            ),

            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.white.withOpacity(0.9),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF006fcf)),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading Amex ${_getPageName()}...',
                        style: const TextStyle(
                          color: Color(0xFF006fcf),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please wait while we load the content',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Error overlay
            if (_hasError)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Color(0xFFff6b6b),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Unable to Load Content',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Make sure the server is running',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006fcf),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getPageName() {
    if (widget.htmlPath.contains('credit-cards')) {
      return 'Credit Cards';
    } else if (widget.htmlPath.contains('navigation')) {
      return 'Navigation';
    }
    return 'Content';
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    // The iframe will automatically retry loading
  }
}

// Specialized widget for navigation only
class AmexNavigationWidget extends StatelessWidget {
  final double height;
  final VoidCallback? onNavigationLoad;

  const AmexNavigationWidget({
    Key? key,
    this.height = 120,
    this.onNavigationLoad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmexIframeWidget(
      htmlPath: 'amex-navigation.html',
      height: height,
      showFullPage: false,
      onLoad: onNavigationLoad,
    );
  }
}

// Specialized widget for full credit cards page
class AmexCreditCardsWidget extends StatelessWidget {
  final VoidCallback? onPageLoad;

  const AmexCreditCardsWidget({
    Key? key,
    this.onPageLoad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmexIframeWidget(
      htmlPath: 'credit-cards.html',
      showFullPage: true,
      onLoad: onPageLoad,
    );
  }
}

// Widget that can switch between different pages
class AmexPageSwitcher extends StatefulWidget {
  final double? height;

  const AmexPageSwitcher({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  State<AmexPageSwitcher> createState() => _AmexPageSwitcherState();
}

class _AmexPageSwitcherState extends State<AmexPageSwitcher> {
  String _currentPage = 'amex-navigation.html';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Page selector buttons
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () =>
                    setState(() => _currentPage = 'amex-navigation.html'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPage == 'amex-navigation.html'
                      ? const Color(0xFF006fcf)
                      : Colors.grey[300],
                  foregroundColor: _currentPage == 'amex-navigation.html'
                      ? Colors.white
                      : Colors.black,
                ),
                child: const Text('Navigation'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () =>
                    setState(() => _currentPage = 'credit-cards.html'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPage == 'credit-cards.html'
                      ? const Color(0xFF006fcf)
                      : Colors.grey[300],
                  foregroundColor: _currentPage == 'credit-cards.html'
                      ? Colors.white
                      : Colors.black,
                ),
                child: const Text('Credit Cards'),
              ),
            ],
          ),
        ),
        // Content iframe
        Expanded(
          child: AmexIframeWidget(
            htmlPath: _currentPage,
            height: widget.height,
            showFullPage: true,
          ),
        ),
      ],
    );
  }
}
