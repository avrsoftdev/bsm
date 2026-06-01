// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter, uri_does_not_exist

import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web show HTMLIFrameElement;

void registerYouTubeView(String videoId) {
  final viewType = 'youtube-$videoId';
  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) => web.HTMLIFrameElement()
      ..width = '100%'
      ..height = '100%'
      ..src = 'https://www.youtube.com/embed/$videoId'
      ..style.border = 'none'
      ..allowFullscreen = true,
  );
}

Future<void> sendEmailJS(Map<String, dynamic> params) async {
  final sendFn = js_util.getProperty(html.window, 'sendEmailJS');
  if (sendFn == null) {
    throw Exception('sendEmailJS is not defined on window');
  }

  final promise = js_util.callMethod(sendFn, 'call', [html.window, params]);
  await js_util.promiseToFuture(promise);
}
