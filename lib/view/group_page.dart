/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'base.dart';
import 'chat_page.dart';
import 'widget/common_dialog.dart';
import 'package:flutter/material.dart';
import 'widget/dialog_bottom_widget.dart';
import 'package:chatbydatabase/config/config.dart';
import 'package:chatbydatabase/utils/toast_utils.dart';
import 'package:chatbydatabase/utils/common_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatbydatabase/utils/navidator_utils.dart';
import 'package:chatbydatabase/view_model/group_page_model.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

/// Created On 2019/3/5
/// Description:
///
class GroupPage extends StatefulWidget {
  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends StateExtension<GroupPage> {
  /// View Model
  GroupPageModel _viewModel;

  /// Realtime database
  GroupDatabaseUtil _databaseUtil;

  /// User
  /// key: userId
  String _loginUserId;
  String _loginUserName;
  String _otherUserId;
  String _otherUserName;

  @override
  void initState() {
    super.initState();
    // View Model
    _viewModel = GroupPageModel.fromState(this);
    // Init
    _loginUserId = '5d64d30c045d1701f869b631';
    _loginUserName = 'Civet';
    _otherUserId = '5d8c173740d04323d0b4b832';
    _otherUserName = 'Pet';
    _initDatabase();
  }

  ///  Init Database
  _initDatabase() async {
    _databaseUtil = GroupDatabaseUtil();
    _databaseUtil.initState(_loginUserId);
  }

  _buildRealtimeList() {
    if (_databaseUtil == null || _databaseUtil.getReference() == null) {
      return Container();
    }
    return FirebaseAnimatedList(
      key: ValueKey<bool>(true),
      physics: BouncingScrollPhysics(),
      query: _databaseUtil.getReference(),
      reverse: false,
      sort: (DataSnapshot a, DataSnapshot b) {
        GroupEntity ac = GroupEntity.fromSnapshot(a);
        GroupEntity bc = GroupEntity.fromSnapshot(b);
        int act = ac.newMessageTime ?? ac.createT;
        int bct = bc.newMessageTime ?? bc.createT;
        return bct - act;
      },
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        return SizeTransition(
          sizeFactor: animation,
          child: showItem(snapshot),
        );
      },
    );
  }

  showItem(DataSnapshot res) {
    GroupEntity chatGroup = GroupEntity.fromSnapshot(res);
    String groupId, title, subTitle;
    int crtT;
    // Value
    groupId = chatGroup.groupId;
    title = chatGroup.groupName ?? '';
    subTitle = chatGroup.newMessage ?? '';
    crtT = chatGroup.newMessageTime ?? chatGroup.createT;
    return Container(
      margin: EdgeInsets.only(bottom: 0.4),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            side: BorderSide.none),
        onPressed: () {
          // Chat
          NavigatorUtils.push(
            context,
            ChatPage(_loginUserId, chatGroup),
          );
        },
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Config.primaryColor),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          subTitle ?? '',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF9E9E9E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        CommonUtils.getNumberTimeUIByTimestamp(
                          crtT,
                          briefMonth: true,
                        ),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Add group
  String _groupName;

  _addGroup() {
    // ToastUtils.showToast(msg: 'Please configure.');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        // Link
        Widget card = Container(
          padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Group Name',
                style: TextStyle(
                  color: Config.primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: Config.commonTextSize,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                maxLength: 60,
                style: TextStyle(
                  color: Config.primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: Config.commonTextSize,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  hintText: '',
                  counterText: '',
                ),
                cursorColor: Config.primaryColor,
                autofocus: false,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  _groupName = value;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Add User Id',
                style: TextStyle(
                  color: Config.primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: Config.commonTextSize,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                maxLength: 60,
                style: TextStyle(
                  color: Config.primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: Config.commonTextSize,
                ),
                controller: TextEditingController(text: _otherUserId),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  counterText: '',
                ),
                cursorColor: Config.primaryColor,
                autofocus: false,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  _otherUserId = value;
                },
                enabled: false,
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
                    if (CommonUtils.isNullOrEmpty(_groupName)) {
                      ToastUtils.showToast(
                          msg: 'Not allowed to be empty of Group name.');
                      return;
                    }
                    String content = 'Create successfully.';
                    int cur = DateTime.now().millisecondsSinceEpoch;
                    var group = GroupEntity(
                      groupId: 'G-$cur',
                      groupName: _groupName,
                      newMessage: content,
                      newMessageTime: cur,
                      createT: cur,
                      newMessageUserId: _loginUserId,
                    );
                    _databaseUtil.addGroup(
                      group,
                      _loginUserName,
                      _otherUserId,
                      _otherUserName,
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
          [card],
          EdgeInsets.symmetric(horizontal: 16.0),
          null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_loginUserName),
      ),
      body: Container(
        child: _buildRealtimeList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGroup,
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class GroupDatabaseUtil {
  // Firebase Database
  FirebaseDatabase database;
  DatabaseReference _userReference;

  static final GroupDatabaseUtil _instance = GroupDatabaseUtil.internal();

  GroupDatabaseUtil.internal();

  factory GroupDatabaseUtil() => _instance;

  void initState(String userId) {
    // Database
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    // Reference
    _userReference = database.reference().child('chat/user/U-$userId');
    _userReference.keepSynced(true);
  }

  DatabaseReference getReference() {
    return _userReference;
  }

  /// Add a Group to Realtime database
  addGroup(GroupEntity groupMessage, String loginUserName, String otherUserId,
      String otherUserName) async {
    // 1. Login User add group
    String groupId = groupMessage.groupId;
    String groupName = groupMessage.groupName;
    String userName = groupMessage.userName;
    int createT = groupMessage.createT;
    String newMessage = groupMessage.newMessage;
    int newMessageTime = groupMessage.newMessageTime;
    String newMessageUserId = groupMessage.newMessageUserId;
    // To Map
    Map<String, dynamic> value = {};
    // Not blank
    value['group_id'] = groupId;
    value['group_name'] = groupName;
    value['user_name'] = userName;
    value['create_t'] = createT;
    value['new_message'] = newMessage;
    value['new_message_time'] = newMessageTime;
    value['new_message_user_id'] = newMessageUserId;
    // Add a message to Group Message
    database
        .reference()
        .child('chat/user/U-$newMessageUserId/$groupId')
        .set(value)
        .then((_) {
      print('$newMessageUserId add a group: $groupName');
    });
    // 2. Other User add group
    database
        .reference()
        .child('chat/user/U-$otherUserId/$groupId')
        .set(value)
        .then((_) {
      print('$otherUserId add a group: $groupName');
    });
    // 3. Group add users
    database.reference().child('chat/group/$groupId/U-$newMessageUserId').set({
      'join_time': createT,
      'operator': newMessageUserId,
      'sex': 1,
      'user_name': loginUserName,
      'user_id': newMessageUserId,
    }).then((_) {
      print('$otherUserId add a group: $groupName');
    });
    database.reference().child('chat/group/$groupId/U-$otherUserId').set({
      'join_time': createT,
      'operator': newMessageUserId,
      'sex': 2,
      'user_name': otherUserName,
      'user_id': otherUserId,
    }).then((_) {
      print('$otherUserId add a group: $groupName');
    });
  }

  void dispose() {}
}

class GroupEntity {
  String groupId;
  String groupName;
  String userName;
  int createT;
  String newMessage;
  int newMessageTime;
  String newMessageUserId;

  GroupEntity({
    this.groupId,
    this.groupName,
    this.userName,
    this.createT,
    this.newMessage,
    this.newMessageTime,
    this.newMessageUserId,
  });

  GroupEntity.fromSnapshot(DataSnapshot snapshot) {
    groupId = snapshot.key;
    Map value = snapshot.value;
    if (value == null) return;
    groupName = value['group_name'];
    userName = value['user_name'];
    createT = value['create_t'];
    newMessage = value['new_message'];
    newMessageTime = value['new_message_time'];
    newMessageUserId = value['new_message_user_id'];
  }
}
