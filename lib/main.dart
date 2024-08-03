// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Replacer',
      debugShowCheckedModeBanner: false,      
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      
      home: const UrlInputScreen(),
      
    );
  }
}

class UrlInputScreen extends StatefulWidget {
  const UrlInputScreen({super.key});

  @override
  _UrlInputScreenState createState() => _UrlInputScreenState();
}

class _UrlInputScreenState extends State<UrlInputScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  ThemeMode _themeMode = ThemeMode.light;

  void _paste() async {
    try {
      ClipboardData? data = await Clipboard.getData('text/plain');
      if (data != null) {
        setState(() {
          _controller.text = data.text!;
        });
      } else {
        _showToast("Clipboard is empty");
      }
    } catch (e) {
      _showToast("Failed to paste text");
    }
  }

  void _clearText() {
    setState(() {
      _controller.clear();
    });
  }

  void _generateUrl() async {
    setState(() {
      _isLoading = true;
    });

    String inputUrl = _controller.text.trim();
    if (inputUrl.isEmpty) {
      _showToast("URL cannot be empty");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!Uri.tryParse(inputUrl)!.hasAbsolutePath) {
      _showToast("Invalid URL format");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    RegExp regExp = RegExp(r'templates/(\d+)\?');
    Match? match = regExp.firstMatch(inputUrl);

    if (match != null) {
      String urlReplace = match.group(1)!;
      String newUrl =
          'https://ttanchor.onelink.me/VQBU/CapCutSharedPage1?af_force_deeplink=true&af_dp=capcut://template/detail?template_id=$urlReplace&tab_name=template&enter_from=shared_h5link_template';
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UrlOutputScreen(outputUrl: newUrl),
        ),
      );
    } else {
      _showToast("URL does not match the expected pattern");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  var websiteUrl = 'https://www.capcut.com/templates';
  void _openInABrowser() async {
      
      final Uri uri = Uri.parse(websiteUrl);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      _showToast("Could not launch URL");
    }
  }

  void _showTutorialGuide() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: RichText( 
                        textAlign: TextAlign.center,                 
                        text: const TextSpan(                    
                      children: [
                        TextSpan(  text: 'HOW TO USE?', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,),),],),),
                    ),
                    const SizedBox(height: 15.0),
                    
                    RichText(text: const TextSpan(children: [TextSpan(text: 'Step 01 - Use VPN.'), ],),),

                    const SizedBox(height: 8.0),                    
                    RichText(                  
                      text: TextSpan(                    
                    children: [
                      const TextSpan(text: 'Step 02 - Visit CapCut website for Templates '), 
                      TextSpan(  text: 'Visit CapCut Official Website', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = _openInABrowser,
                      ),],),),
                    const SizedBox(height: 8.0),
                    RichText(text: const TextSpan(children: [TextSpan(text: 'Step 03 - Copy URL of your desired template.'), ],),),
                    const SizedBox(height: 8.0),
                    
                    RichText(text: const TextSpan(children: [TextSpan(text: 'Step 04 - Paste the URL here in this app.'), ],),),
                    const SizedBox(height: 8.0),
                    RichText(text: const TextSpan(children: [TextSpan(text: 'Step 05 - Done! Click on Open in Browser Button or Copy URL and open in your desired browser.'), ],),),
                    
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Understood'),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleThemeMode() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CapCut Template Fix'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(_themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
                onPressed: _toggleThemeMode,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Text Field to paste or write URL',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _paste,
                    icon: const Icon(Icons.paste),
                    label: const Text('PASTE'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _clearText,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Text'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: _showTutorialGuide,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _generateUrl,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Generate URL'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class UrlOutputScreen extends StatelessWidget {
  final String outputUrl;

  const UrlOutputScreen({super.key, required this.outputUrl});

  void _openInBrowser() async {
    final Uri uri = Uri.parse(outputUrl);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      _showToast("Could not launch URL");
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Output'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Output URL',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SelectableText(
                outputUrl,
                style: const TextStyle(color: Color.fromARGB(255, 1, 114, 189), fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    try {
                      Clipboard.setData(ClipboardData(text: outputUrl));
                      _showToast("Copied to Clipboard");
                    } catch (e) {
                      _showToast("Failed to copy text");
                    }
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
                ElevatedButton.icon(
                  onPressed: _openInBrowser,
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Open in Browser'),
                ),
              ],
            ),
            const Spacer(),
            const Center(child: Text('Google Ads')),
          ],
        ),
      ),
    );
  }
}

class UrlUtils {
  static String? generateNewUrl(String inputUrl) {
    RegExp regExp = RegExp(r'templates/(\d+)\?');
    Match? match = regExp.firstMatch(inputUrl);

    if (match != null) {
      String urlReplace = match.group(1)!;
      return 'https://ttanchor.onelink.me/VQBU/CapCutSharedPage1?af_force_deeplink=true&af_dp=capcut://template/detail?template_id=$urlReplace&tab_name=template&enter_from=shared_h5link_template';
    } else {
      return null;
    }
  }
}
