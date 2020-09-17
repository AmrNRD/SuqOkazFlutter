import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class PaymentWebview extends StatefulWidget {
  final String url;
  final Function onFinish;

  PaymentWebview({this.onFinish, this.url});

  @override
  State<StatefulWidget> createState() {
    return PaymentWebviewState();
  }
}

class PaymentWebviewState extends State<PaymentWebview> {
  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("/checkout/order-received/")) {
        final items = url.split("/checkout/order-received/");
        if (items.length > 1) {
          final number = items[1].split("/")[0];
          widget.onFinish(number);
          Navigator.of(context).pop();
        }
      }
      if (url.contains("checkout/success")) {
        widget.onFinish("0");
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var checkoutUrl = "";

    var headers = Map<String, String>();
      checkoutUrl = widget.url;

    return WebviewScaffold(
      withJavascript: true,
      appCacheEnabled: true,
      url: checkoutUrl,
      headers: headers,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0.0,
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(child: kLoadingWidget(context)),
    );
//    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back),
//            onPressed: () {
//              Navigator.of(context).pop();
//            }),
//        backgroundColor: kGrey200,
//        elevation: 0.0,
//      ),
//      body: WebView(
//          javascriptMode: JavascriptMode.unrestricted,
//          initialUrl: checkoutUrl,
//          onPageFinished: (String url) {
//            if(url.contains("/checkout/order-received/")){
//              final items = url.split("/checkout/order-received/");
//              if(items.length > 1){
//                final number = items[1].split("/")[0];
//                onFinish(number);
//                Navigator.of(context).pop();
//              }
//            }
//          }),
//    );
  }


  Widget kLoadingWidget(context) => Container(
    padding: EdgeInsets.all(30),
    child: Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          strokeWidth: 3,
        ),
      ),
    ),
  );

}
