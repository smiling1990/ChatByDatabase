/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'group_page.dart';
import 'widget/common_dialog.dart';
import 'widget/bottom_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'widget/dialog_bottom_widget.dart';
import 'widget/custom_play_recording.dart';
import 'package:chatbydatabase/view/base.dart';
import 'widget/circular_progress_indicator.dart';
import 'package:chatbydatabase/config/config.dart';
import 'package:chatbydatabase/utils/toast_utils.dart';
import 'package:chatbydatabase/utils/common_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatbydatabase/view_model/chat_page_model.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

/// Created On 2019/12/2
/// Description:
///
class ChatPage extends StatefulWidget {
  /// Login user
  final String loginUserId;

  /// Group info
  final GroupEntity chatGroup;

  ChatPage(this.loginUserId, this.chatGroup);

  @override
  ChatPageState createState() => ChatPageState(loginUserId, chatGroup);
}

class ChatPageState extends StateExtension<ChatPage> {
  /// View Model
  ChatPageModel _viewModel;

  /// Realtime database
  ChatDatabaseUtil _databaseUtil;

  /// User
  /// key: userId
  String loginUserId;

  /// key:userId
  ///   key: user_id user_name sex join_time
  Map<String, Map<String, dynamic>> _usersInfo;

  /// Group info
  final GroupEntity chatGroup;

  /// Input
  FocusNode _focusNode;

  /// Input state
  int _curState;
  static const SEND_MESSAGE = 0; // Text
  static const int SEND_RECORD = 1; // Sound

  /// Edit message
  String _curEditMessage;

  /// Link
  String _linkText, _linkTo;

  /// Sound state
  /// Record Sound
  bool _isRecording = false;

  ////////////////////////////////////////////////
  // Sound Record Start
  ////////////////////////////////////////////////
  /// On vertical drag
  double _onVerticalDrag;
  double _onVerticalStart;
  int _curTimestamp;

  /// 60 Second is allowed
  static const int MAX_SOUND_LENGTH = 60 * 1000;

  /// Save path
  String _soundPath;

  /// Sound duration
  int _soundDuration;

  /// Record duration
  String _timeText;

  ChatPageState(this.loginUserId, this.chatGroup);

  @override
  void initState() {
    super.initState();
    // View Model
    _viewModel = ChatPageModel.fromState(this);
    // Init
    _focusNode = FocusNode();
    _curState = SEND_MESSAGE;
    _initDatabase();
  }

  ///  Init Database
  _initDatabase() async {
    _databaseUtil = ChatDatabaseUtil();
    _databaseUtil.initState(chatGroup);
    _usersInfo = await _databaseUtil.getUserInfo();
  }

  _buildRealtimeList() {
    if (_databaseUtil == null || _databaseUtil.getReference() == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        // 隐藏输入框
        _focusNode.unfocus();
        // 归位输入类型
        _curState = SEND_MESSAGE;
        triggerUpdate();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Config.chatBgAssets,
            ),
            fit: BoxFit.cover,
          ),
          color: Config.chat_bg,
        ),
        alignment: Alignment.bottomCenter,
        child: FirebaseAnimatedList(
          key: ValueKey<bool>(true),
          physics: BouncingScrollPhysics(),
          query: _databaseUtil.getReference(),
          reverse: true,
          sort: (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return SizeTransition(
              sizeFactor: animation,
              child: showItem(snapshot),
            );
          },
        ),
      ),
    );
  }

  showItem(DataSnapshot res) {
    MessageEntity msgEntity = MessageEntity.fromSnapshot(res);
    String type = msgEntity.type;
    if (type == Config.CHAT_TYPE_TEXT) {
      // Text
      return _buildMessageItem(msgEntity);
    } else if (type == Config.CHAT_TYPE_IMAGE) {
      // Image
      return _buildImageItem(msgEntity);
    } else if (type == Config.CHAT_TYPE_AUDIO) {
      // Video
      return _buildAudioItem(msgEntity);
    } else if (type == Config.CHAT_TYPE_VIDEO) {
      // Video
      return _buildVideoItem(msgEntity);
    }
    return Container(height: 0.1, color: Colors.transparent);
  }

  /// Circle Avatar
  _buildCircleAvatar(MessageEntity msgEntity) {
    bool isMe = msgEntity.senderUserId == loginUserId;
    return Container(
      child: CircleAvatar(
        radius: 20.0,
        backgroundImage: AssetImage(
          isMe ? Config.chatMeAvatarAssets : Config.chatOtherAvatarAssets,
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  /// Common
  _buildItemCommon(MessageEntity msgEntity, Widget child) {
    // User Name
    String userId = msgEntity.senderUserId;
    String userName = msgEntity.senderUserId;
    if (_usersInfo != null && _usersInfo.containsKey(userId)) {
      userName = _usersInfo[userId]['user_name'];
    }
    bool isMe = msgEntity.senderUserId == loginUserId;
    Color bgColor = Color(0xFF9E9E9E);
    // Message and avatar
    List<Widget> rowWidgets = [];
    // Name
    List<Widget> columnWidgets = [];
    // Name and time
    List<Widget> timeAndNameWidgets = [];
    if (isMe) {
      timeAndNameWidgets.add(Text(
        CommonUtils.getNumberTimeUIByTimestamp(
          msgEntity.createT,
          briefMonth: true,
        ),
        style: TextStyle(
          color: bgColor,
          fontWeight: FontWeight.normal,
          fontSize: Config.smallTextSize_4,
        ),
      ));
      timeAndNameWidgets.add(SizedBox(width: 10.0));
      timeAndNameWidgets.add(Text(
        userName,
        style: TextStyle(
          color: bgColor,
          fontWeight: FontWeight.normal,
          fontSize: Config.smallTextSize_4,
        ),
      ));
    } else {
      timeAndNameWidgets.add(Text(
        userName,
        style: TextStyle(
          color: bgColor,
          fontWeight: FontWeight.normal,
          fontSize: Config.smallTextSize_4,
        ),
      ));
      timeAndNameWidgets.add(SizedBox(width: 10.0));
      timeAndNameWidgets.add(Text(
        CommonUtils.getNumberTimeUIByTimestamp(
          msgEntity.createT,
          briefMonth: true,
        ),
        style: TextStyle(
          color: bgColor,
          fontWeight: FontWeight.normal,
          fontSize: Config.smallTextSize_4,
        ),
      ));
    }
    columnWidgets.add(Row(
      mainAxisSize: MainAxisSize.min,
      children: timeAndNameWidgets,
    ));
    columnWidgets.add(SizedBox(height: 4.0));
    columnWidgets.add(child);
    // Avatar
    if (isMe) {
      // Right
      rowWidgets.add(Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: columnWidgets,
        ),
      ));
      rowWidgets.add(SizedBox(width: 8.0));
      rowWidgets.add(_buildCircleAvatar(msgEntity));
    } else {
      // Left
      rowWidgets.add(_buildCircleAvatar(msgEntity));
      rowWidgets.add(SizedBox(width: 8.0));
      rowWidgets.add(Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnWidgets,
        ),
      ));
    }
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowWidgets,
      ),
    );
  }

  /// Build Message Widget
  _buildMessageItem(MessageEntity msgEntity) {
    bool isMe = msgEntity.senderUserId == loginUserId;
    String content = msgEntity.content;
    bool isLink = _viewModel.isLink(content);
    String linkText, linkTo;
    if (isLink) {
      var map = _viewModel.parserLinkText(content);
      linkText = map['linkText'];
      linkTo = map['linkTo'];
    } else {
      linkText = content;
    }
    Widget child = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: linkText,
            style: isLink
                ? TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: Config.commonTextSize,
                    decoration: TextDecoration.underline,
                    color: isMe ? Config.chat_text_me : Config.chat_text_other,
                  )
                : TextStyle(
                    fontSize: Config.commonTextSize,
                    fontWeight: FontWeight.normal,
                    color: isMe ? Config.chat_text_me : Config.chat_text_other,
                  ),
            recognizer: isLink
                ? (TapGestureRecognizer()
                  ..onTap = () {
                    ToastUtils.showToast(msg: linkTo);
                  })
                : null,
          ),
        ],
      ),
    );
    return _buildItemCommon(
      msgEntity,
      Container(
        decoration: BoxDecoration(
          color: isMe ? Config.chat_bg_me : Config.chat_bg_other,
          borderRadius:
              isMe ? Config.borderRadiusMe : Config.borderRadiusOthers,
        ),
        padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
        margin: isMe
            ? EdgeInsets.fromLTRB(48.0, 0.0, 0.0, 0.0)
            : EdgeInsets.fromLTRB(0.0, 0.0, 48.0, 0.0),
        child: child,
      ),
    );
  }

  /// Build Image Widget
  _buildImageItem(MessageEntity msgEntity) {
    bool isMe = msgEntity.senderUserId == loginUserId;
    var ret = CommonUtils.getImageWidthAndHeight(
      msgEntity.width,
      msgEntity.height,
    );
    var width = ret['width'].toDouble();
    var height = ret['height'].toDouble();
    return _buildItemCommon(
      msgEntity,
      GestureDetector(
        onTap: () {
          // 查看图片
        },
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius:
                isMe ? Config.borderRadiusMe : Config.borderRadiusOthers,
            image: DecorationImage(
              image: NetworkImage(Config.netImageAddress1),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  /// Build Audio Widget
  _buildAudioItem(MessageEntity msgEntity) {
    bool isMe = msgEntity.senderUserId == loginUserId;
    String audioUrl = Config.netAudioAddress1;
    int duration = msgEntity.duration;
    Color bgColor = isMe ? Config.chat_bg_me : Config.chat_bg_other;
    Color textColor = isMe ? Config.chat_text_me : Config.chat_text_other;
    return _buildItemCommon(
      msgEntity,
      Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius:
              isMe ? Config.borderRadiusMe : Config.borderRadiusOthers,
        ),
        padding: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 8.0),
        margin: isMe
            ? EdgeInsets.fromLTRB(48.0, 0.0, 0.0, 0.0)
            : EdgeInsets.fromLTRB(0.0, 0.0, 48.0, 0.0),
        alignment: Alignment.center,
        child: CustomPlayRecordingSlider(
          key: Key(msgEntity.id),
          soundUrl: audioUrl ?? '',
          soundDuration: duration ?? 0,
          iconColor: textColor,
          negativeColor: textColor,
          leftStyle: TextStyle(
            color: textColor,
            fontWeight: FontWeight.normal,
            fontSize: Config.smallTextSize_2,
          ),
          rightStyle: TextStyle(
            color: textColor,
            fontWeight: FontWeight.normal,
            fontSize: Config.smallTextSize_2,
          ),
        ),
      ),
    );
  }

  /// Build Video Widget
  _buildVideoItem(MessageEntity msgEntity) {
    bool isMe = msgEntity.senderUserId == loginUserId;
    // String videoUrl = Address.getDownLoadUrl(chatMessage.resUri);
    String videoUrl = msgEntity.resUri;
    String videoId = msgEntity.createT.toString();
    // if isMe is false, and videoUrl is NUll, return
    if (!isMe && (videoUrl == null || videoUrl.isEmpty)) {
      return Container(height: 0.1, color: Colors.transparent);
    }
    var ret = CommonUtils.getImageWidthAndHeight(
      msgEntity.width,
      msgEntity.height,
    );
    var width = ret['width'].toDouble();
    var height = ret['height'].toDouble();
    // Upload Progress
    bool showUpProgress = false;
    var upProgress = 50;
    if (upProgress != null && upProgress < 100) {
      showUpProgress = true;
    }
    // Upload Failed
    bool upFailed = false;
    if (videoUrl == null && upProgress == null) {
      upFailed = true;
    }
    return _buildItemCommon(
      msgEntity,
      Stack(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        children: <Widget>[
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius:
                  isMe ? Config.borderRadiusMe : Config.borderRadiusOthers,
            ),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius:
                    isMe ? Config.borderRadiusMe : Config.borderRadiusOthers,
                image: DecorationImage(
                  image: NetworkImage(Config.netImageAddress2),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius:
                  isMe ? Config.borderRadiusMe : Config.borderRadiusOthers,
            ),
            // 黑色背景
            child: Opacity(
              opacity: 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      isMe ? Config.borderRadiusMe : Config.borderRadiusOthers,
                ),
                child: Text(
                  '' ?? videoUrl ?? 'Empty',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: Config.commonTextSize,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: width,
            height: height,
            child: IconButton(
              icon: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 48.0,
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
                // Video Player
              },
            ),
          ),
          showUpProgress
              ? Container(
                  width: width + 40.0,
                  height: height,
                  alignment:
                      isMe ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    key: Key(videoId),
                    width: 40.0,
                    height: height,
                    child: GradientCircularProgressIndicator(
                      colors: [Colors.red, Colors.red],
                      radius: 12.0,
                      stokeWidth: 2.0,
                      strokeCapRound: true,
                      backgroundColor: Colors.transparent,
                      value: upProgress / 100,
                      text: '',
                    ),
                  ),
                )
              : Container(),
          upFailed
              ? Container(
                  width: width + 50.0,
                  height: height,
                  alignment:
                      isMe ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    child: Text(
                      'Upload\nFailed',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.normal,
                        fontSize: Config.smallTextSize_4,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  /// Add item
  _buildAddItemWidget(IconData icon, String text, Function onPress) {
    return Expanded(
      child: MaterialButton(
        onPressed: () {
          // 关闭
          Navigator.of(context).pop();
          // 逻辑
          onPress();
        },
        padding: EdgeInsets.symmetric(vertical: 8.0),
        //color: Color(0xFF575757),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: Config.primaryColor,
              size: 48.0,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Config.primaryColor,
                fontWeight: FontWeight.normal,
                fontSize: Config.smallTextSize_4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Input
  _buildBottomWidget() {
    return Container(
      height: 64.0,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 15.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 48.0,
              margin: EdgeInsets.only(right: 12.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Config.primaryColor,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: _curState == SEND_MESSAGE
                  ? TextField(
                      focusNode: _focusNode,
                      maxLines: 999,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: Config.smallTextSize_2,
                      ),
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: Config.primaryColor,
                      controller: TextEditingController(text: _curEditMessage),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 8.0),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) {
                        // 当前消息
                        _curEditMessage = value;
                      },
                    )
                  : GestureDetector(
                      onVerticalDragDown: (_) {
                        // _showDialogToSound();
                      },
                      onVerticalDragUpdate: (DragUpdateDetails details) {
                        // Max length in a 1s
                        if (_curTimestamp == null) {
                          _onVerticalDrag = 0.0;
                          _onVerticalStart = details.globalPosition.dy;
                          _curTimestamp = DateTime.now().millisecondsSinceEpoch;
                        } else {
                          int cur = DateTime.now().millisecondsSinceEpoch;
                          double curDy = details.globalPosition.dy;
                          if (cur - _curTimestamp > 1000) {
                            _onVerticalDrag = 0.0;
                            _onVerticalStart = details.globalPosition.dy;
                          } else {
                            _onVerticalDrag = _onVerticalStart - curDy;
                          }
                          _curTimestamp = cur;
                          if (_onVerticalDrag > 100.0) {
                            // Cancel
                            _cancelRecord();
                          }
                        }
                      },
                      onVerticalDragEnd: (DragEndDetails details) {
                        _stopRecordAndSend();
                      },
                      onVerticalDragCancel: () {
                        _stopRecordAndSend();
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Press and hold to record message',
                          style: TextStyle(
                            color: Config.primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Config.smallTextSize_2,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Config.primaryColor,
              size: 28.0,
            ),
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            onPressed: () {
              // 显示对话框
              // 归位输入类型
              _curState = SEND_MESSAGE;
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) {
                  // Voice Photos link video
                  Widget _card = Row(
                    children: <Widget>[
                      _buildAddItemWidget(
                        // Voice
                        Icons.record_voice_over,
                        'Voice\nMessage',
                        () {
                          _curState = SEND_RECORD;
                          triggerUpdate();
                        },
                      ),
                      _buildAddItemWidget(
                        Icons.photo,
                        'Send\nPhotos',
                        () {},
                      ),
                      _buildAddItemWidget(
                        Icons.link,
                        'Insert\nhyper-link',
                        () {
                          // Link
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) {
                              // Link
                              Widget lindCard = Container(
                                padding:
                                    EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Link text',
                                      style: TextStyle(
                                        color: Config.primaryColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Config.smallTextSize_4,
                                      ),
                                    ),
                                    TextField(
                                      maxLength: 60,
                                      style: TextStyle(
                                        color: Config.primaryColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Config.commonTextSize,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        hintText: '',
                                        counterText: '',
                                      ),
                                      cursorColor: Config.primaryColor,
                                      autofocus: false,
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {
                                        _linkText = value;
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      'Link to',
                                      style: TextStyle(
                                        color: Config.primaryColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Config.smallTextSize_4,
                                      ),
                                    ),
                                    TextField(
                                      maxLength: 60,
                                      style: TextStyle(
                                        color: Config.primaryColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Config.commonTextSize,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        counterText: '',
                                      ),
                                      cursorColor: Config.primaryColor,
                                      autofocus: false,
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {
                                        _linkTo = value;
                                      },
                                    ),
                                    SizedBox(height: 32.0),
                                    // Cancel Insert
                                    Container(
                                      child: DialogBottomWidget(
                                        leftBtn: 'CANCEL',
                                        rightBtn: 'INSERT',
                                        onCancel: null,
                                        onApplyCallback: () {
                                          // 校验
                                          if (CommonUtils.isNullOrEmpty(
                                              _linkTo)) {
                                            ToastUtils.showToast(
                                                msg:
                                                    'Not allowed to be empty of LinkTo.');
                                            return;
                                          }
                                          if (CommonUtils.isNullOrEmpty(
                                              _linkText)) {
                                            _linkText = _linkTo;
                                          }
                                          String content =
                                              '[$_linkText]($_linkTo)';
                                          var chatMessage = MessageEntity(
                                            senderUserId: loginUserId,
                                            content: content,
                                            type: Config.CHAT_TYPE_TEXT,
                                            createT: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            length: content.length,
                                          );
                                          _databaseUtil.sendMessage(
                                            chatMessage,
                                            groupContent: '[$_linkText]',
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                              return CommonDialog(
                                'MessageLinkDialog',
                                [lindCard],
                                EdgeInsets.symmetric(horizontal: 16.0),
                                null,
                              );
                            },
                          );
                          triggerUpdate();
                        },
                      ),
                      _buildAddItemWidget(
                        Icons.video_library,
                        'Send\nVideos',
                        () {},
                      ),
                    ],
                  );
                  return BottomDialog(
                    'MessageAddDialog',
                    [_card],
                    EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    null,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Config.primaryColor,
              size: 28.0,
            ),
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            onPressed: () {
              if (CommonUtils.isNullOrEmpty(_curEditMessage)) {
                ToastUtils.showToast(msg: 'Message is not allowed empty.');
                return;
              }
              // Send
              var message = MessageEntity(
                senderUserId: loginUserId,
                content: _curEditMessage,
                type: Config.CHAT_TYPE_TEXT,
                createT: DateTime.now().millisecondsSinceEpoch,
                length: _curEditMessage.length,
              );
              _databaseUtil.sendMessage(message);
              _curEditMessage = '';
              triggerUpdate();
            },
          ),
        ],
      ),
    );
  }

  /// Cancel record and not send
  _cancelRecord() {}

  /// Stop record and send sudio
  _stopRecordAndSend() {
    _isRecording = false;
    triggerUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(chatGroup.groupName ?? 'Chat'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(child: _buildRealtimeList()),
              _buildBottomWidget(),
            ],
          ),
          _isRecording
              ? Container(
                  margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 64.0),
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.record_voice_over,
                              color: Config.primaryColor,
                              size: 48.0,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              _timeText ?? '00:00',
                              style: TextStyle(
                                color: Config.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Config.bigTextSize_16,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 64.0,
                          alignment: Alignment.center,
                          child: Text(
                            'Release to send, slide up to cancel',
                            style: TextStyle(
                              color: Config.primaryColor,
                              fontWeight: FontWeight.normal,
                              fontSize: Config.commonTextSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class ChatDatabaseUtil {
  /// Firebase Database
  FirebaseDatabase database;
  DatabaseReference _msgReference;

  /// Group
  String _groupId;

  /// key:userId
  ///   key: user_id user_name sex join_time
  Map<String, Map<String, dynamic>> _groupUsers;

  static final ChatDatabaseUtil _instance = ChatDatabaseUtil.internal();

  ChatDatabaseUtil.internal();

  factory ChatDatabaseUtil() => _instance;

  void initState(GroupEntity groupEntity) {
    // Database
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    // Reference
    _groupId = groupEntity.groupId;
    String child = 'chat/message/$_groupId';
    _msgReference = database.reference().child(child);
    _msgReference.keepSynced(true);
  }

  /// key:userId
  ///   key: user_id user_name sex join_time
  Future<Map<String, Map<String, dynamic>>> getUserInfo() async {
    String child = 'chat/group/$_groupId';
    var snap = await database.reference().child(child).once();
    String sk = snap.key; // G-$groupId
    print('Key: $sk');
    Map users = snap.value; // Users
    Map<String, Map<String, dynamic>> ret = {};
    users.forEach((k, v) {
      Map<String, dynamic> user = {};
      String userId = v['user_id'];
      user['user_id'] = userId;
      user['user_name'] = v['user_name'];
      user['sex'] = v['sex'];
      user['join_time'] = v['join_time'];
      ret[userId] = user;
    });
    _groupUsers = ret;
    return ret;
  }

  DatabaseReference getReference() {
    return _msgReference;
  }

  /// Send a message to Realtime database
  sendMessage(MessageEntity msgEntity, {String groupContent}) async {
    String type = msgEntity.type;
    String content = msgEntity.content;
    String senderUserId = msgEntity.senderUserId;
    String thumbUri = msgEntity.thumbUri;
    String resUri = msgEntity.resUri;
    int length = msgEntity.length;
    int size = msgEntity.size;
    int width = msgEntity.width;
    int height = msgEntity.height;
    int duration = msgEntity.duration;
    int createT = msgEntity.createT;
    // To Map
    Map<String, dynamic> value = {};
    // Not blank
    value['type'] = type;
    value['sender_user_id'] = senderUserId;
    // Verify
    if (content != null) value['content'] = content;
    if (thumbUri != null) value['thumb_uri'] = thumbUri;
    if (resUri != null) value['res_uri'] = resUri;
    if (length != null) value['length'] = length;
    if (size != null) value['size'] = size;
    if (duration != null) value['duration'] = duration;
    if (createT != null) value['create_t'] = createT;
    if (width != null) value['width'] = width;
    if (height != null) value['height'] = height;
    if (createT != null) value['create_t'] = createT;
    // Add a message
    await _msgReference.push().set(value);
    print('Send a new message.');
    // Add the new message to group
    if (_groupUsers != null && _groupUsers.isNotEmpty) {
      var users = _groupUsers.keys;
      for (var userId in users) {
        var groupRef =
            database.reference().child('chat/user/U-$userId/$_groupId');
        await groupRef.update({
          'new_message': groupContent ?? content,
          'new_message_time': createT,
          'new_message_user_id': senderUserId,
        });
        print('Update a new message.');
      }
    }
  }

  void dispose() {}
}

class MessageEntity {
  String id;
  String type;
  String content;
  int length; // text
  int size; // media
  int width; // image
  int height; // image
  String senderUserId;
  String thumbUri;
  String resUri;
  int duration; // ms
  int createT; // timestamp

  MessageEntity({
    this.type,
    this.content,
    this.length,
    this.width,
    this.height,
    this.size,
    this.senderUserId,
    this.thumbUri,
    this.resUri,
    this.duration,
    this.createT,
  });

  MessageEntity.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    Map value = snapshot.value;
    if (value == null) return;
    type = value['type'];
    content = value['content'];
    length = value['length'];
    size = value['size'];
    width = value['width'];
    height = value['height'];
    senderUserId = value['sender_user_id'];
    thumbUri = value['thumb_uri'];
    resUri = value['res_uri'];
    var d = value['duration'];
    if (d is int) {
      duration = d;
    } else if (d is double) {
      duration = d.floor();
    } else if (d is String) {
      duration = int.parse(d);
    }
    createT = value['create_t'];
  }
}
