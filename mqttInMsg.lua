--- 模块功能：MQTT客户端数据接收处理
-- @author openLuat
-- @module mqtt.mqttInMsg
-- @license MIT
-- @copyright openLuat
-- @release 2018.03.28

module(...,package.seeall)

require"sms"
require"common"
require"sim"

--短信数据发送的消息队列
local msgQueue = {}

local function insertSms(data)
    table.insert(msgQueue, data)
end

local function sendtest(result,mobile,message)
    if result then
        log.info("testSms.sendtest success",result,mobile,common.gb2312ToUtf8(message))
    else
        log.info("testSms.sendtest failure",result,mobile,common.gb2312ToUtf8(message))
        --TODO：失败重新发送逻辑
    end    
end

--- MQTT客户端数据接收处理
-- @param mqttClient，MQTT客户端对象
-- @return 处理成功返回true，处理出错返回false
-- @usage mqttInMsg.proc(mqttClient)
function proc(mqttClient)
    local result,data
    while true do
        result, data = mqttClient:receive(2000)
        --接收到数据
        if result then
            log.info("mqttInMsg.proc", data.topic, data.payload)

            local smsdata,result,errinfo = json.decode(data.payload)
            smsdata.message = common.utf8ToGb2312(smsdata.message)
            local iccid = sim.getIccid()
            if smsdata.task == "sendsms" then
                log.info("sms.send.mobile", smsdata.mobile)
                log.info("sms.send.mobile", smsdata.message)
                sms.send(smsdata.mobile, smsdata.message, sendtest)
            end
            -- if data.topic == string.format("/command/%s/task", iccid) then
               
            -- end
            -- if data.topic == string.format("/command/%s/status", iccid) then
            -- end
            --TODO：根据需求自行处理data.payload

            --如果mqttOutMsg中有等待发送的数据，则立即退出本循环
            if mqttOutMsg.waitForSend() then return true end
        else
            break
        end
    end
    
    return result or data=="timeout"
end
