import 'package:flutter/material.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainWebView extends StatefulWidget {
  const MainWebView({super.key});

  @override
  State<MainWebView> createState() => _MainWebViewState();
}

class _MainWebViewState extends State<MainWebView> {
  WebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    initWebViewController();
  }

  void initWebViewController() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          print('You Press Screen');
        },
        onPageStarted: (url) {},
        onPageFinished: (url) {},
        onWebResourceError: (error) {},
      ))
      ..loadRequest(Uri.parse(
          'https://webrtc.livestreaming.in.th/realpost/play.html?name=realpost001'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   foregroundColor: AppConstant.dark,
      // ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return SafeArea(
            child: webViewController == null
                ? const SizedBox()
                : SizedBox(
                    width: boxConstraints.maxWidth,
                    height: boxConstraints.maxHeight,
                    child: WebViewWidget(controller: webViewController!),
                  ));
      }),
    );
  }
}
