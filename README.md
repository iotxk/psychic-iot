# psychic-sms
# 项目介绍
此仓库为通信模块 合宙 Air600c 烧录固件。
通过2G/4G通信模块，接收、发送手机SIM短信，转发到 微信、Telegram。


# 使用说明
扫码关注微信公众号，扫一扫 添加绑定您的设备。

![微信公众号](https://github.com/iotxk/psychic-iot/raw/main/mpqrcode.png)

下载我们编译好的固件，通过观看视频教程，烧录固件。

烧录成功后，通电开机有微信通知，如正常收到提示，则配置成功！

可以愉快的收发短信了。

# 硬件设备选型
合宙 Air600c 4G通信模块，目前官方搞活动 19.9元

官方购买地址：
【淘宝】https://m.tb.cn/h.fGHdNpS?tk=cxUA2Ocxshg「合宙4G Cat.1通信模块全网通小开发板Air600C完全兼容移远EC600N」
点击链接直接打开

产品介绍：
https://zhuanlan.zhihu.com/p/477840337

文档地址：
https://doc.openluat.com/wiki/21?wiki_page_id=2987#_16

视频教程：
https://www.bilibili.com/video/BV1aY4y1W7fx/

# 技术实现
通信模块设备，使用MQTT 订阅 发布 与服务端通信，有任务上报给服务端，服务端 接收到任务后，转发到 微信、Telegram、Email 等应用。

# 已实现功能
短信转发
- [x] 在线检测新版本、升级
- [x] 转发到微信公众号
- [x] 转发到其他手机短信【注意：非免费的，转发短信运营商有收费的】
- [ ] 语音电话录音
- [ ] 自动接听语音电话播放留言
- [ ] 转发到邮箱（支持：SMTP）
- [ ] 转发到钉钉机器人
- [ ] 转发到webhook（支持：单个web页面（[向设置的url发送POST/GET请求](doc/POST_WEB.md)））
- [ ] 转发到企业微信群机器人
- [ ] 转发到企业微信应用消息
- [ ] 转发到Telegram机器人
- [ ] 转发未接来电提醒
- [ ] 转发到飞书机器人
- [ ] 转发到PushPlus


## License

psychic-sms is available under the
[MIT license](https://opensource.org/licenses/MIT)
