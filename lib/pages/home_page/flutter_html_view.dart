import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class AmexNavigationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HtmlElementView.fromTagName(
      tagName: 'iframe',
      onElementCreated: (element) {
        final iframe = element as web.HTMLIFrameElement;

        // Set the source to load the amex-navigation.html file
        iframe.src = 'http://localhost:8000/amex-navigation.html';

        // Configure iframe styling
        iframe.style.width = '100%';
        iframe.style.height = '100vh';
        iframe.style.border = 'none';
        iframe.style.position = 'fixed';
        iframe.style.top = '0';
        iframe.style.left = '0';
        iframe.style.zIndex = '1000';
        iframe.style.backgroundColor = 'white';

        // Allow navigation within the iframe
        iframe.allow = 'navigation-top';

        // Handle iframe load events
        iframe.onLoad.listen((event) {
          print('Amex Navigation loaded successfully');
        });

        // Handle iframe errors
        iframe.onError.listen((event) {
          print('Error loading Amex Navigation: $event');
        });
      },
    );
  }
}

// Alternative approach using direct HTML injection
class AmexNavigationViewDirect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HtmlElementView.fromTagName(
      tagName: 'div',
      onElementCreated: (element) async {
        // final div = element as web.HTMLDivElement;

        // // Configure container styling
        // div.style.width = '100%';
        // div.style.height = '100vh';
        // div.style.position = 'fixed';
        // div.style.top = '0';
        // div.style.left = '0';
        // div.style.zIndex = '1000';
        // div.style.backgroundColor = 'white';
        // div.style.overflow = 'hidden';

        // try {
        //   // Fetch the HTML content
        //   final response = web.window.fetch(
        //     'http://localhost:8000/amex-navigation.html',
        //   );
        //   final htmlContent = response.text();

        //   // Inject the HTML content
        //   div.innerHTML = htmlContent;

        //   print('Amex Navigation HTML loaded successfully');
        // } catch (e) {
        //   print('Error loading Amex Navigation HTML: $e');
        //   div.innerHTML = '''
        //     <div style="padding: 20px; text-align: center; color: red;">
        //       <h2>Error Loading Navigation</h2>
        //       <p>Could not load amex-navigation.html. Make sure the server is running on localhost:8000</p>
        //     </div>
        //   ''';
        // }
      },
    );
  }
}

// Usage in your home page widget
class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your existing content
          Container(
            // Your main content here
          ),

          // Amex Navigation Overlay
          AmexNavigationView(), // Use this for iframe approach
          // or
          // AmexNavigationViewDirect(), // Use this for direct HTML injection
        ],
      ),
    );
  }
}

// If you want to replace the existing header code directly:
Widget buildAmexNavigationHeader() {
  return HtmlElementView.fromTagName(
    tagName: 'iframe',
    onElementCreated: (element) {
      final iframe = element as web.HTMLIFrameElement;

      // Load the beautiful Amex navigation
      iframe.src = 'http://localhost:8000/amex-navigation.html';

      // Style the iframe to match your requirements
      iframe.style.width = '100%';
      iframe.style.height = '80px'; // Adjust height as needed
      iframe.style.border = 'none';
      iframe.style.position = 'fixed';
      iframe.style.top = '0';
      iframe.style.left = '0';
      iframe.style.zIndex = '1000';
      iframe.style.backgroundColor = 'white';
      iframe.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';

      // Optional: Handle iframe communication
      iframe.onLoad.listen((event) {
        print('Amex Navigation loaded in Flutter app');
      });
    },
  );
}
