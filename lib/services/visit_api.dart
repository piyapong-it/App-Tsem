import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:tsem/models/dmlmessage.dart';
import 'package:tsem/models/visit.dart';
import 'package:tsem/models/visitagenda.dart';
import 'package:tsem/models/visitcallcard.dart';
import 'package:tsem/models/visitcount.dart';
import 'package:tsem/models/visiteoe.dart';
import 'package:tsem/models/visitmjp.dart';
import 'package:tsem/models/itemvisiteoe.dart';

import '../constants.dart';

class VisitApi {
  final Dio _dio = Dio();

  VisitApi() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<DmLmessage> insertVisit(
      {String outletid, DateTime visitdate, String lat, String lng}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/insertVisit");
      Response response = await _dio.post(uri.toString(),
          data: {
            "outletid": outletid,
            "visitdate": DateFormat('dd/MMM/yyyy').format(visitdate),
            "jdecode": _jdecode,
            "lat": lat,
            "lng": lng
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);
      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<VisitAgenda> fetchVisitAgenda(
      {String outletid, DateTime visitdate}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/getVisitAgenda");
      Response response = await _dio.post(uri.toString(),
          data: {
            "outletid": outletid,
            "visitdate": DateFormat('dd/MMM/yyyy').format(visitdate)
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      VisitAgenda result = VisitAgenda.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<VisitEoE> fetchVisitEOE(
      {String outletid, DateTime visitdate, String group}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/getVisitEOE");
      Response response = await _dio.post(uri.toString(),
          data: {
            "outletid": outletid,
            "visitdate": DateFormat('dd/MMM/yyyy').format(visitdate),
            "group": group
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      VisitEoE result = VisitEoE.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<DmLmessage> updateVisit({String visitId, String visitStatus}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _username = await storage.read(key: USERNAME);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/updateVisit");

      print('visit id = ${visitId}');
      print('visit status = ${visitStatus}');
      print('user naem = ${_username}');

      Response response = await _dio.post(uri.toString(),
          data: {
            "visitid": visitId,
            "visitstatus": visitStatus,
            "updateby": _username
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);
      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      print('dmlmessage = ${result.message}');
      return result;
    } catch (e) {
      print('e = ${e}');
      return (e);
    }
  }

  Future<DmLmessage> updateVisitAgenda(
      {String visitId, int agendaId, String visitStatus}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/updateVisitAgenda");
      Response response = await _dio.post(uri.toString(),
          data: {
            "visitid": visitId,
            "agendaid": agendaId,
            "visitstatus": visitStatus
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);
      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<DmLmessage> updateVisitEoE(
      {String visitId, int agendaId, int eoeSeq, String eoeFlag}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/updateVisitEoE");

      Response response = await _dio.post(uri.toString(),
          data: {
            "visitid": visitId,
            "agendaid": agendaId,
            "eoeseq": eoeSeq,
            "eoeflag": eoeFlag
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);
      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<VisitMjp> fetchMjp() async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/getVisitMjp/" + _jdecode);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      VisitMjp result = VisitMjp.fromJson(jsonResponse);

      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<VisitCallCard> fetchCallCard({String visitid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"visitid": visitid};

      final uri =
          Uri.http(endpoint, "/api/visit/getVisitCallCard", queryParameters);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      VisitCallCard result = VisitCallCard.fromJson(jsonResponse);
      return result;
    } catch (e) {
      print(e);
      return (e);
    }
  }

  Future<DmLmessage> updateVisitCallCard(
      {String visitId,
      int agendaId,
      String pmid,
      double premas,
      double mas,
      double price,
      double stock,
      String productdate,
      String outletid,
      String visitdate}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _username = await storage.read(key: USERNAME);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/updateVisitCallCard");
      Response response = await _dio.post(uri.toString(),
          data: {
            "visitid": visitId,
            "agendaid": agendaId,
            "pmid": pmid,
            "premas": premas,
            "mas": mas,
            "price": price,
            "stock": stock,
            "productdate": productdate,
            "updateby": _username,
            "outletid": outletid,
            "visitdate": visitdate
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<DmLmessage> deleteVisitCallCard(
      {String visitId, int agendaId, String pmid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _username = await storage.read(key: USERNAME);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/deleteVisitCallCard");

      Response response = await _dio.post(uri.toString(),
          data: {"visitid": visitId, "agendaid": agendaId, "pmid": pmid},
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<VisitCount> fetchVisitCount() async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/getVisitCount/" + _jdecode);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      VisitCount result = VisitCount.fromJson(jsonResponse);

      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<Visit> fetchVisitHistory(String outletId) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/getVisit/" + outletId);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      Visit result = Visit.fromJson(jsonResponse);

      return result;
    } catch (e) {
      return (e);
    }
  }

// new
  Future<DmLmessage> fetchInsertVisitEOE(data) async {
    try {
      final storage = new FlutterSecureStorage();
      String _username = await storage.read(key: USERNAME);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/insertVisitEoE/");

      Response response = await _dio.post(uri.toString(),
          data: data,
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<DmLmessage> fetchDelVisitEOEAll(data) async {
    try {
      final storage = new FlutterSecureStorage();
      String _username = await storage.read(key: USERNAME);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/deleteVisitEoE/");

      Response response = await _dio.post(uri.toString(),
          data: data,
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<ItemVisitEoE> fetchItemVisitEoE(Object data) async {
    try {
      final storage = new FlutterSecureStorage();
      String _username = await storage.read(key: USERNAME);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.http(endpoint, "/api/visit/getVisitEoEAll/");

      Response response = await _dio.post(uri.toString(),
          data: data,
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      ItemVisitEoE result = ItemVisitEoE.fromJson(jsonResponse);
      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }
}
