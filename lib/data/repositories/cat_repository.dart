import 'dart:convert';
import 'dart:io';

import 'package:cat_images/domain/models/cat_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class CatRepository {
  final http.Client _client;

  CatRepository(this._client);

  /* Future<CatImage> getCatImage() async {
    final response =
        await _client.get(Uri.parse('https://some-random-api.ml/img/cat'));
    return CatImage.fromJson(jsonDecode(response.body));
  } */

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/certificates.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<CatImage> getCatImage() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response =
        await ioClient.get(Uri.parse('https://some-random-api.ml/img/cat'));
    return CatImage.fromJson(jsonDecode(response.body));
  }
}
