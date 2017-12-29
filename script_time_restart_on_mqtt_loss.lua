local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
domoticz_functions = require('domoticz_functions')
require('settings')


commandArray = {}

restart = 1


n = os.tmpname()
os.execute ("var=$(ps -eo pid,args |grep 'domoticz -daemon' | grep -v grep |awk '{print $1}') && echo $(($(cut -d '.' -f1 /proc/uptime) - $(($(cut -d ' ' -f22 /proc/$var/stat)/100)))) > " .. n)
for line in io.lines(n) do
  UptimeInSeconds = line
end
os.remove(n)

UptimeInSeconds = tonumber(UptimeInSeconds);
-- print('Domoticz has been running for ' .. UptimeInSeconds .. ' seconds')
if UptimeInSeconds < 900 then
  restart = 0
end


for i, apartment_config in pairs(apartment_configs) do
  apartment = apartment_config["apartment"]
  for j, room_config in ipairs(apartment_config["rooms"]) do
    lastUpdate = otherdevices_lastupdate[apartment .. ': ' .. temperatureDev .. room_config["name"]]
    lastUpdateSeconds = domoticz_functions.timedifference(lastUpdate)

    -- print('device: ' .. apartment .. ': ' .. temperatureDev .. room_config["name"])
    -- print('last updated: ' .. lastUpdateSeconds)
    
    if lastUpdateSeconds < 600 then
      restart = 0
    end
  end
end

if restart == 1 then
  print('Domoticz needs to be restarted, MQTT might be down')
  os.execute("/sbin/shutdown -r now")
end

return commandArray
