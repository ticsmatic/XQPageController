XQPageController
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/YYKit/master/LICENSE)&nbsp;
[![Build Status](https://travis-ci.org/ibireme/YYKit.svg?branch=master)](https://travis-ci.org/ibireme/YYKit)


XQPageController is userd for page style change, used in news app, a controler whitch another  page, magbe UITableView in UITableView, and have the style of sticky. welcome to your star, ✨✨✨✨✨✨ thanks   


Demo Project
==============
See `XQPageControllerDemo.xcworkspace`

![image](https://github.com/west-east/ReadMeImage/blob/master/XQPageController%20Reource/1.gif) ![image](https://github.com/west-east/ReadMeImage/blob/master/XQPageController%20Reource/2.gif) 
![image](https://github.com/west-east/ReadMeImage/blob/master/XQPageController%20Reource/3.gif) ![image](https://github.com/west-east/ReadMeImage/blob/master/XQPageController%20Reource/4.gif) 
![image](https://github.com/west-east/ReadMeImage/blob/master/XQPageController%20Reource/5.gif) ![image](https://github.com/west-east/ReadMeImage/blob/master/XQPageController%20Reource/6.gif) 
![image](https://github.com/west-east/ReadMeImage/blob/master/XQPageController%20Reource/7.gif) ![image](https://github.com/west-east/ReadMeImage/blob/master/XQPageController%20Reource/8.gif) 



usage
==============

Drag XQPageController into your project 

1. It need Masory and YYCategories to support.
2. if you want, you don't need  Masory and YYCategories, its not difficult, its a syntactic sugar
3. run.


Requirements
==============
This library requires `iOS 8.0+` and `Xcode 8.0+`.

Notice
==============
in XQPageController, i mainly used subclass to implement, but for easy use and i don't want to much code, i walked the shortcut 

License
==============
XQPageController is provided under the MIT license. See LICENSE file for details.


<br/><br/>
---
中文介绍
==============
1.本组件主要是用于文章浏览类page方式的浏览、频道订阅、也可以用于tableView且套tableView，其中的悬停效果

2.主要使用了继承的方式实现，但是为了简化代码，以及方便使用者阅读和修改，我并没有严格遵守继承的常规使用方式，使用详情见Demo

3.依赖了Masory、YYCategories两个组件，其中Masory在tableView嵌套tableView中使用（主要是为了修改控制器的大小，使用frame方式也是可以的，但是此时要比约束的方式略微啰嗦一点），其它地方没有使用。YYCategories主要使用了它的语法糖，不喜欢的话，你也可以很方便的把它替换掉

最后
==============
如果对您有帮助，请不要吝啬您的star，感谢！
有什么好的意见或者建议请提出来

