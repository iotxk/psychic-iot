--- 模块功能：MQTT客户端处理框架
-- @author openLuat
-- @module mqtt.mqttTask
-- @license MIT
-- @copyright openLuat
-- @release 2018.03.28

module(...,package.seeall)

require"misc"
require"mqtt"
require"sim"
require"mqttOutMsg"
require"mqttInMsg"
--加载setApn功能测试模块
require "setApn"
local ready = false

--- MQTT连接是否处于激活状态
-- @return 激活状态返回true，非激活状态返回false
-- @usage mqttTask.isReady()
function isReady()
    return ready
end


sys.timerStart(sys.restart, 1000*60*60*1, 'deviceRestart')
-- sys.timerStart(sys.restart('设备定时重启'), 1000*60*60*2)
--启动MQTT客户端任务
sys.taskInit(
    function()
        local retryConnectCnt = 0
        while true do
            if not socket.isReady() then
                retryConnectCnt = 0
                --等待网络环境准备就绪，超时时间是5分钟
                sys.waitUntil("IP_READY_IND",300000)
            end
            
            if socket.isReady() then
                local imei = misc.getImei()
                local iccid = sim.getIccid()
                --创建一个MQTT客户端
                local mqttClient = mqtt.client(imei.."_"..iccid, 1200, "test", "test")
                --阻塞执行MQTT CONNECT动作，直至成功
                if mqttClient:connect("lbsmqtt.airm2m.com", 1883, "tcp") then
                    retryConnectCnt = 0
                    ready = true
                    --订阅主题
                    if mqttClient:subscribe({
                        [string.format("/command/%s/task", iccid)]=0,
                        [string.format("/command/%s/status", iccid)] = 1}) then

                        mqttOutMsg.init()
                        --循环处理接收和发送的数据
                        while true do
                            if not mqttInMsg.proc(mqttClient) then log.error("mqttTask.mqttInMsg.proc error") break end
                            if not mqttOutMsg.proc(mqttClient) then log.error("mqttTask.mqttOutMsg proc error") break end
                        end
                        -- mqttOutMsg.unInit()
                    end
                    ready = false
                else
                    retryConnectCnt = retryConnectCnt+1
                end
                --断开MQTT连接
                mqttClient:disconnect()
                if retryConnectCnt>=5 then link.shut() retryConnectCnt=0 end
                sys.wait(5000)
            else
                --进入飞行模式，20秒之后，退出飞行模式
                net.switchFly(true)
                sys.wait(20000)
                net.switchFly(false)
            end
        end
    end
)
