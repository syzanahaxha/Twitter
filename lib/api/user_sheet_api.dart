import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'package:task3_twitter/api/user.dart';

class userSheetApi {
  static final _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheets-344109",
  "private_key_id": "c7a8e3e335a6f648f927ef18014084b0bcd48f82",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCTzw2hO/UwHiPX\nGkCuBfPkPobi0vftzdRs1r/guqc3Vt/cwDwrXuwYRG2vOJThSMTgQXVItvWCzvbX\nRrpj4rtGC0mGD+efs5piRsDkm5APL+pC43d7sKu1Td24Vjf0vy1XN374nJTSz28m\nsf+RyXrhWpyBzaKhEt0NItjBrsgqby4dadq+ywnJM8kyGWy6cTHFIdqNtRR4Le08\nZQSAzBvBzWBoyRUQGAqJnbcaKrtQq682Vdkg2N+urR4AgFI3pmEzwxXR5ntcFMgm\nguhpFSIP61UcE6jEfz7A1bzM+Cj5hog+j8xvx55VhLYt4RJluDbrQDsadGMzC+uG\nekf3I6zLAgMBAAECggEAJEpzI0JQahcMX7T/anrlrgW4Ipr/6rBd1rdHd0r84XaA\nEnhUjaWJvE+YyqvOyh2O0SzhOhBJ6Wsdai/gdcPmjUUaMUNYcHqtjjGnDLoxPblb\nAD9PR9xR3HsY1Di/FmWWIVLr5uizFat+s/aCNG5OsGQKB0jRBFFYWvBSXgOm+9ve\n5UnqWfZcalg07eDWJl3k7c0JskiwBc5cb3EVeAcqCDmJe+pnANwbeWMjuRnXUbCS\ntrbfpFJlUJyd4dbHDZPdKgIVqcS8ZQQNt5qv2MQQa0Mbxq6lzmDhyYplYBDPE+Tj\nxMA7m45xEMg+XBsLeKZ/BGO9Ey6atHfh1+7krvwQYQKBgQDEGC8Qgiy/JecFEqHy\nvdViYUCnQyGuR3LJR47t9j1n1d85INvPfel2tRwW/pzrj4DdePzmCckMDD5gA0Et\nOjEVcLcfk4SNrpdUux0Y1oRC4APbJRTWckWszPs4F4/pYMdfu3DxX/0D24AJ4puY\n7rNmMf7s9AqfL+0A0JKNaoAT0QKBgQDA9qCyNyJVotQescY6aLqfRMsDu48dWUc8\nXV6Tw2Rd3GCsvRorcYSYSvV1+bSXngpv4Cn+s2+TcIJ2SzFaSALxRUcurVRCcpHq\nLG/0NHZpTu9uOhhRFnlE6XY10mhHKI2nOKXn522eSpZKYZ4pLKiDfBpRz30Y98SX\n88P8ctJp2wKBgGpd5+GfiuAgkiCZS8ldGYskz6oq6vEbBnOR4kDH6eUSCOR3I2R4\nmxPuB4+disbn73Gy+BNbyXdEiO0Rtt/uicNkgaCaJzOnOaUXXiAj9FhGJTFQ+u2b\nzJmAEuEJPuHLwjn2dbwoYhkejmROTDJ3gE513h7v/Xb9yyQ+/s/ArjqRAoGAEFON\nqyaBEC/TtLkj5YNA7wLaDnnLFRedsFzSCLyKfGqN/2+MjEpxhpUpCY9UGVP03Bxi\nUTuLYDUvxKR+C352SUWsTSW7MFgTQnX6DvZ1YlmcZn4h2pKFNjBuoQUpb4Pd4F0p\npGJvYuo6pxZ1VFSD+YQBkhR1KCymhJjKZ0yrwusCgYEAi2EtOxk+bigbwbY9qAf1\ncUb1ZsT5eEY38+3x9xxMu70jaoZOaoFT5opWOz8tFQ3sTxcTJ+m5hE2ZSrkTISja\n/LVvvM0T54GGX/RUuWgCxibSXHOgAtGquw7lgTAEP/vTBQK0aDllewwPvWj1BhuF\nFJ/A53iyc4LLEZnJTdTweb0=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-344109.iam.gserviceaccount.com",
  "client_id": "108087555410470748141",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-344109.iam.gserviceaccount.com"
}
  ''';
  static final _spreadsheetId = '1zuBi7G4mPyt5JqEm5MIwQmb1dCGl2zZ9ijddaYo2zZE';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'Users');

      final firstRow = UserFields.getFields();
      _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return await spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return;
    _userSheet!.values.map.appendRows(rowList);
  }
}
