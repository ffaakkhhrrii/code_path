import 'package:code_path/config/app_asset.dart';
import 'package:code_path/model/roles.dart';
import 'package:intl/intl.dart';

class AppFormat {
  static String date(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('d MMM yyyy', 'en_US').format(dateTime);
  }

  static String dateMonth(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('d MMM', 'en_US').format(dateTime);
  }

  static String dateTime(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('d MMM yyy HH:mm', 'en_US').format(dateTime);
  }

  static String currency(double number) {
    return NumberFormat.currency(
      decimalDigits: 0,
      locale: 'en_US',
      symbol: '\$',
    ).format(number);
  }

  static String formatPathName(String text){
    var result = text.replaceFirst(" ", "\n");
    return result;
  }

  static String formatIdPathName(String text){
    var result = text.split("_").map((word) => word[0].toUpperCase() + word.substring(1))
      .join(" ");
    return result;
  }

  static String showImageRoles(String roles){
    if(roles == "android_developer"){
      return AppAsset.androidBg;
    }else if(roles == "web_developer"){
      return AppAsset.webBg;
    }else{
      return AppAsset.bgDefaultNews;
    }
  }

  static String generateIdRoles(String text){
    var result = text.toLowerCase().replaceAll(' ', '_');
    return result;
  }
}