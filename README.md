# psychic-sms
# 项目介绍

通过2G/4G通信模块，接收、发送手机SIM短信，转发到 微信、Telegram
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
通信模块设备，使用MQTT 订阅 发布 与服务端通信，有任务上报给服务端，服务端 接收到任务后，转发到 微信、Telegram 等应用。

# 已实现功能
短信转发

# todo
自动接听语音电话播放留言
语音电话录音
....
