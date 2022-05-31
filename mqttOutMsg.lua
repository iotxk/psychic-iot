--- 模块功能：MQTT客户端数据发送处理
-- @author openLuat
-- @module mqtt.mqttOutMsg
-- @license MIT
-- @copyright openLuat
-- @release 2018.03.28


module(...,package.seeall)
require "pm"
require"sms"
require"utils"
require"common"
require"misc"
require"sim"


--数据发送的消息队列
local msgQueue = {}

local function insertMsg(topic,payload,qos,user)
    table.insert(msgQueue,{t=topic,p=payload,q=qos,user=user})
end

-----------------------------------------短信接收功能测试[开始]-----------------------------------------
local function procnewsms(from,message,datetime)
    log.info("testSms.procnewsms",from,message,datetime)
    local imei = misc.getImei()
    local iccid = sim.getIccid()
    insertMsg("/receivesms",json.encode({from=from,imei=imei,iccid=iccid,datetime=datetime, message=common.gb2312ToUtf8(message)}),0 ,{cb=pubQos0TestCb})
end

sms.setNewSmsCb(procnewsms)

function pubQos0Test()
    local imei = misc.getImei()
    local iccid = sim.getIccid()
    insertMsg("/receivesms",json.encode({from=iccid,imei=imei,iccid=iccid, message=iccid}),0 ,{cb=pubQos0TestCb})
end
--- 初始化“MQTT客户端数据发送”
-- @return 无
-- @usage mqttOutMsg.init()
function init()
    pubQos0Test()
end


--- 去初始化“MQTT客户端数据发送”
-- @return 无
-- @usage mqttOutMsg.unInit()
function unInit()
    sys.timerStop(pubQos0Test)
    while #msgQueue>0 do
        local outMsg = table.remove(msgQueue,1)
        if outMsg.user and outMsg.user.cb then outMsg.user.cb(false,outMsg.user.para) end
    end
end

--- MQTT客户端是否有数据等待发送
-- @return 有数据等待发送返回true，否则返回false
-- @usage mqttOutMsg.waitForSend()
function waitForSend()
    return #msgQueue > 0
end

--- MQTT客户端数据发送处理
-- @param mqttClient，MQTT客户端对象
-- @return 处理成功返回true，处理出错返回false
-- @usage mqttOutMsg.proc(mqttClient)
function proc(mqttClient)
    while #msgQueue>0 do
        local outMsg = table.remove(msgQueue,1)
        local result = mqttClient:publish(outMsg.t,outMsg.p,outMsg.q)
        if outMsg.user and outMsg.user.cb then outMsg.user.cb(result,outMsg.user.para) end
        if not result then return end
    end
    return true
end
