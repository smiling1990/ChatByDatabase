/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */
 
import 'base.dart';
import 'package:chatbydatabase/view/chat_page.dart';

/// Created On 2019/12/2
/// Description: 
/// 
class ChatPageModel with ViewModel {
  ChatPageModel.fromState(ChatPageState buildState) {
    state = buildState;
  }

  bool isLink(String text) {
    // RegExp regExp = new RegExp(r"1[0-9]\d{9}$");
    RegExp regExp = new RegExp(r'\[.*\]\(.*\)');
    // RegExp regExp = new RegExp(r"par");
    return regExp.hasMatch(text);
  }

  Map<String, String> parserLinkText(String text) {
    String linkText, linkTo;
    List<int> leftM = []; // [
    List<int> rightM = []; // ]
    List<int> leftS = []; // (
    List<int> rightS = []; // )
    List<String> split = text.split('');
    for (int i = 0; i < split.length; i++) {
      String s = split[i];
      if (s == '[') {
        leftM.add(i);
      } else if (s == ']') {
        rightM.add(i);
      } else if (s == '(') {
        leftS.add(i);
      } else if (s == ')') {
        rightS.add(i);
      }
    }

    linkText = text.substring(leftM[0] + 1, rightM[rightM.length - 1]);
    linkTo = text.substring(leftS[0] + 1, rightS[rightM.length - 1]);
    return {
      'linkText': linkText,
      'linkTo': linkTo,
    };
  }
}