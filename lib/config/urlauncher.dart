import 'package:url_launcher/url_launcher.dart';

Future<void> openURl(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Unable to launch URL';
  }
}
