/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

/// Created On 2019/11/30
/// Description: Common Util
///
class CommonUtils {
  static Map<int, String> monthMap = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  static Map<int, String> monthBriefMap = {
    1: 'Jan.',
    2: 'Feb.',
    3: 'Mar.',
    4: 'Apr.',
    5: 'May.',
    6: 'June.',
    7: 'July.',
    8: 'Aug.',
    9: 'Sept.',
    10: 'Oct.',
    11: 'Nov.',
    12: 'Dec.',
  };

  /// Get brief String by int: Month
  static getBriefByMonth(int value) {
    assert(value >= 1 && value <= 12);
    return monthBriefMap[value];
  }

  /// Get String by int: Month
  static getStringByMonth(int value) {
    assert(value >= 1 && value <= 12);
    return monthMap[value];
  }

  /// If String, List, Map is null or empty
  static bool isNullOrEmpty(var value) {
    if (value == null) return true;
    assert(value is String || value is List || value is Map);
    return value.isEmpty;
  }

  static String toDigit(int source, int digit) {
    if (source == null) return '';
    String ret = source.toString();
    int length = ret.length;
    if (length >= digit) return ret;
    int dif = digit - length;
    return '${'0' * dif}$ret';
  }

  /// 2019-02-02 8:23
  static String getNumberTimeUIByTimestamp(int timestamp,
      {bool briefMonth = false}) {
    if (timestamp == null) return '';
    // 0 是1970年，显然是不正确的
    if (timestamp == 0) return '';
    String ret = '';
    var time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String month = toDigit(time.month, 2);
    String day = toDigit(time.day, 2);
    String hour = toDigit(time.hour, 2);
    String min = toDigit(time.minute, 2);
    if (briefMonth) {
      ret = '${getBriefByMonth(time.month)}$day $hour:$min';
    } else {
      ret = '$month-$day $hour:$min';
    }
    var cur = DateTime.now();
    int curYear = cur.year;
    int curMonth = cur.month;
    int curDay = cur.day;
    if (curYear != time.year) {
      ret = '${time.year} $ret';
    } else {
      if (curMonth == time.month && curDay == time.day) {
        // 当天
        ret = '$hour:$min';
      }
    }
    return ret;
  }

  /// Get image width and height by size
  static Map<String, int> getImageWidthAndHeight(
      int sourceWidth, int sourceHeight) {
    int maxWidth = 160;
    int maxHeight = 160;
    int minWidth = 40;
    int minHeight = 30;
    int width = sourceWidth ?? maxWidth;
    int height = sourceHeight ?? maxHeight;
    if (width == null || width <= 0) width = maxWidth;
    if (height == null || height <= 0) height = maxHeight;
    double per;
    if (width > maxWidth) {
      double widthPer = width / maxWidth;
      per = widthPer;
    }
    if (height > maxHeight) {
      double heightPer = height / maxHeight;
      if (heightPer > per) {
        per = heightPer;
      }
    }
    if (per != null) {
      width = (width / per).floor();
      height = (height / per).floor();
    }
    // Not too small
    if (width < minWidth) width = minWidth;
    if (height < minHeight) minHeight = minHeight;
    return {
      'width': width,
      'height': height,
    };
  }
}
