## 前言：聊天管理涉及到的知识点

### Realtime Database配置

- Realtime Database是托管在云端的实时数据库，数据会同步到所有客户端，并支持离线状态使用。本文档通过Realtime Database存储聊天数据。
    
### 聊天数据存储结构实现

- Realtime Database的存储是一个大型的**JSON存储树**，本文档的存储包含三个节点 **group**, **user**和**message**，group存储群组内成员信息，user存储用户参与的群组信息，message存储群组内聊天数据。
    
### 支持文本、链接、图片、语音、视频
    
- 链接通过**Markdown**格式存储，通过**RichText GestureRecognizer**实现点击功能。
- 图片、语音和视频的上传到个人服务器，Realtime Database中保存下载链接地址及资源详细数据，如尺寸，时长，大小等信息。
    
### 聊天界面UI实现
### Android涉及到权限的申请
- RECORD_AUDIO
- WRITE_EXTERNAL_STORAGE
- CAMERA

## 1. Realtime Database配置

### 1.1 pubspec.yaml
- [firebase_core](https://pub.flutter-io.cn/packages/firebase_core)
- [firebase_database](https://pub.flutter-io.cn/packages/firebase_database)

### 1.2 [Firebase Console](https://console.firebase.google.com/)创建项目
- 按包名注册
- 下载配置文件google-services.json
- Android端：复制google-services.json到android/app文件夹下
### 1.3 Android
- build.gradle(project)
    - classpath 'com.google.gms:google-services:4.3.2'
- build.gradle(app)
    - apply plugin: 'com.google.gms.google-services'
### 1.4 在Database Console创建Realtime Database
![](https://user-gold-cdn.xitu.io/2019/11/30/16ebb5ff815fa88a?w=1457&h=879&f=png&s=357766)

## 2. 聊天页面
先上图

### 2.1 群组页面UI
![](https://user-gold-cdn.xitu.io/2019/12/2/16ec5e433879c634?w=1040&h=1920&f=jpeg&s=252792)

### 2.2 聊天页面UI
![](https://user-gold-cdn.xitu.io/2019/12/2/16ec5ec501872c9a?w=1040&h=1920&f=jpeg&s=435063)
![](https://user-gold-cdn.xitu.io/2019/12/2/16ec5ec764fb6b64?w=1040&h=1920&f=jpeg&s=338530)

## 3. 数据存储结构
### 3.1 Group
存储G-XXXX群组下所有的成员信息，包含加入时间、用户昵称、用户ID、操作者、性别等信息。
~~~
"G-1574046712857": {
    "U-5d8c173740d04323d0b4b832": {
      "join_time": 1575006582872,
      "user_name": "Civet",
      "user_id": "5d8c173740d04323d0b4b832",
      "operator": "5d8c173740d04323d0b4b832",
      "sex": 1
    }
}
~~~
### 3.2 User
存储U-XXXX所有的群组及群组详情。并包含群组的最新一条消息new_message，主要是为了首页展示。

~~~
"user": {
  "U-5d8c173740d04323d0b4b832": {
    "G-1574046712857": {
      "create_t": 1574046713338,
      "group_id": G-1574046712857,
      "group_name": "London",
      "new_message": "Hello",
      "new_message_time": 1572936399285,
      "new_message_user_id": "5d8c173740d04323d0b4b832"
    }
  }
}
~~~

### 3.3 Message
群组内的聊天信息，支持文本、链接、语音、视频等多种类型。
~~~
"message": {
  "G-1574046712857": {
    "-LuphIWhBLLNt7groful": {
      "content": "Who are you? Tan?",
      "create_t": 1575006582872,
      "length": 17,
      "sender_user_id": "5d8c173740d04323d0b4b832",
      "type": "text"
    }
  }
~~~
### 3.4 整体结构
```	
{
  "chat": {
    "group": {
      "G-1574046712857": {
        "U-5d8c173740d04323d0b4b832": {
          "join_time": 1575006582872,
          "user_name": "Civet",
          "user_id": "5d8c173740d04323d0b4b832",
          "operator": "5d8c173740d04323d0b4b832",
          "sex": 1
        },
        "U-5d64d30c045d1701f869b631": {
          "join_time": 1575013538610,
          "user_name": "Pet",
          "user_id": "5d64d30c045d1701f869b631",
          "operator": "5d8c173740d04323d0b4b832",
          "sex": 2
        }
      }
    },
    "user": {
      "U-5d8c173740d04323d0b4b832": {
        "G-1574046712857": {
          "create_t": 1574046713338,
          "group_id": G-1574046712857,
          "group_name": "London",
          "new_message": "Hello",
          "new_message_time": 1572936399285,
          "new_message_user_id": "5d8c173740d04323d0b4b832"
        }
      },
      "U-5d64d30c045d1701f869b631": {
        "G-1574046712857": {
          "create_t": 1574046713338,
          "group_id": G-1574046712857,
          "group_name": "London",
          "new_message": "Hello",
          "new_message_time": 1572936399285,
          "new_message_user_id": "5d8c173740d04323d0b4b832"
        }
      }
    },
    "message": {
      "G-1574046712857": {
        "-LuphIWhBLLNt7groful": {
          "content": "Who are you? Tan?",
          "create_t": 1575006582872,
          "length": 17,
          "sender_user_id": "5d8c173740d04323d0b4b832",
          "type": "text"
        },
        "-Luq6pgncPl2SWWu_VkN": {
          "content": "[Audio]",
          "create_t": 1575013538610,
          "duration": 5000,
          "length": 34,
          "res_uri": "http:///www.xxx.com/xxx",
          "sender_user_id": "5d64d30c045d1701f869b631",
          "size": 11899,
          "type": "audio"
        },
        "-Luq7FNMoMzdR0oUXBe3": {
          "content": "[Image]",
          "create_t": 1575013647895,
          "height": 1334,
          "length": 34,
          "res_uri": "http:///www.xxx.com/xxx",
          "sender_user_id": "5d8c173740d04323d0b4b832",
          "size": 552108,
          "type": "image",
          "width": 750
        }
      }
    }
  }
}
```
## 4. 代码地址
https://github.com/smiling1990/ChatByDatabase