import 'package:brucke_app/sheetsconfig/userfields.dart';
import 'package:gsheets/gsheets.dart';

class SheetsApi {
  static const _credentails = r'''
  {
  "type": "service_account",
  "project_id": "brucke-dae97",
  "private_key_id": "a35cd65e77a6a6acde89611e4d49eac6d6a4152c",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDVfGxeytBhueGo\n4zq7dS9ua7soQCK2Y88ruYl41SVgtgXyhgHqDJymNFFZ1OW1U/GRxyToHL4pOjoj\nyqVa7z3k769UtnwjWuYVgEsr73tLWvc58D9HIP/Q2AnTXvQfi2FlVLtDzYav79jo\nG7G0XR6Hre5Riw6OHOLXn7Q8XFAsnPkafbwxipI+0TeQmq8uEXAv9RyQLmMKebZw\nkRiYHcp5WBP99Gg7ABNg0X7FgIOIEv3viwOTVsKsO/iLPqhVj15xvk9JoJw0v+U3\n5mwhtFbTBJmPn8X88x1mnpmlrfK0C8bzFDJVdgpUsAdg2ff5PA5SqE3SfU231G8G\n59965orJAgMBAAECggEAM8MmmohF5MAXZyXrRmr4LGeKGk0MrZj/MRycKLRTiwKv\nZ/mWirtymvjp9aRBawkWtDArMm1PrTrdQHLgy27hHLqB0kIp0L+4NGPmNhmrlR6R\n/ZYTHamyZR6QqVOnUOOwYoucGSlC3DNFLigS2wbOAXtKYrKa/Zmi5cGnB5ChbuNS\nFfZlqhC2zgtvkDtROl3vbNBhxO35I3WczY7TjqXh5aGjubJjzDbjfWGRx1d2UC3j\n449Rzpaw7MPoxYLav2H7OF9FDUt9dAbSvIoLIbqwoaGgbLILypW7DdFS92ZkpoYB\n4u+hLATNehCinCETczQZfq2sz8h9ujXwlkU5YdwEFQKBgQD3UbLh1dY+FklDAxmM\nLo9bjPB2rXrhXAsAYC0UbwIGr25USvOg7CjY3hCqF9UCOX+GzQ9CnXPdJpaNkW6A\nybJCHrugfm1WedgzHc9kLdASRrbr4/BT51agfi+UlWBJ9Agrtpf3vovpuVnzSN7C\nvLo80F8QMleTfeZ1JrXGhWRe1QKBgQDc+rcRNQFBJdUs3D0IwleKRpZUd1EVFN8B\nWH7GIaqXfybUgSrX2g6DM3fsk2PLdAmpvRWkunJWFTWmj9P+H1Xq63LBuwlnvTZk\nLG9xWe85o91rYwcEv5OoOWtMNk5oUkp6XBLdSYIMriKpu1vl3hIOfaO2pfyQnyYz\nc4qaJdh+JQKBgFbDC30cdkdbrCHdIYZDAzm7zNPlchlDH/zmwInNk6liu9LIZIWM\ns5u486GoMKrSHwHcSEE3WWE421IYtepqV6XIgEwCbjsLDaSJDat4QulWc293jGTy\n4Dn3apu2d4waFw+2w8M+zniU9JBbfQJWEQOqmd7lukFcxo9MoDJfs2FtAoGAdKpJ\nDGSXjPWUXmLINl+kJ/SsWVvFCwRB2EwIYkJT9jfDIF4xaFRPZSU/Iz+NaFSS5XJW\ngumMg7Ye5Rj6KygQDD7SD0XX6VUT6j8rdwSsMBo7Q/68Ld2W7zGhXFMvghQwDfme\nXAX7CwbEdifclLdxgQUD8eIgPZpIaNGPU2K3saECgYBhNRPD1Qj3AtHAWhT/DqhO\nzL8wqJeznxSqm2V2W3MIOIHa2GBk4TBOyVS+raOFtbz42IbvaZMw3CKlgTkWZTgX\njMFK7KOJplRJVE2+diJdq7VwnvUGHnIX8n+VQfhDRq3HmbTXSIDDJMZfCvm54t4Y\n1T5vemCqI/TIAHPuQbBB2g==\n-----END PRIVATE KEY-----\n",
  "client_email": "brucke@brucke-dae97.iam.gserviceaccount.com",
  "client_id": "108460212740617211178",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/brucke%40brucke-dae97.iam.gserviceaccount.com"
  }
''';

  static final _spreadSheetId = '1A7d1U5EwDJQ3iTnRdEcyNjI3tJp38m8Hg2b069vOZIA';
  static final _gsheets = GSheets(_credentails);
  static Spreadsheet _spreadsheet;
  static Worksheet _userSheet;
  static Worksheet _internshipSheet;

  static Future init() async {
    _spreadsheet = await _gsheets.spreadsheet(_spreadSheetId);
    _userSheet = await _getWorkSheet(_spreadsheet, title: "Users");
    final firstRow = UserFields.getFields();
    try {
      _userSheet.values.insertRow(1, firstRow);
    } catch (err) {
      print("err : " + err.toString());
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (_) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  static Future<int> getRowCount() async {
    if (_userSheet == null) {
      return 0;
    }
    final lastrow = await _userSheet.values.lastRow();
    return lastrow == null ? 0 : int.tryParse(lastrow.first) ?? 0;
  }

  static Future addUserToApp(Map<String, dynamic> newUser) async {
    if (_userSheet == null) {
      return;
    }
    print(_userSheet.index);

    _userSheet.values.map.appendRow(newUser);
  }

  static Future addUserToInternship(
      String worksheet, Map<String, dynamic> userInfo) async {
    _internshipSheet = await _getWorkSheet(_spreadsheet, title: worksheet);
    if (_internshipSheet == null) {
      return;
    } else {
      if (_userSheet.index == 0) {
        final firstRow = UserFields.getFields();
        _internshipSheet.values.insertRow(1, firstRow);
      }
      print("Sheet ID : " + _internshipSheet.id.toString());
      _internshipSheet.values.map.appendRow(userInfo);
    }
  }
}
