local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
domoticz_functions = require('domoticz_functions')
require('settings')


commandArray = {}


-- Heatpumps don't have any return channel
-- Just to be on the safe side, resend the IR command once per minute for the first 5 minutes after change
for i, apartment_config in pairs(apartment_configs) do
  apartment = apartment_config["apartment"]

  heatpumpCmdDev = apartment .. ': ' .. textDev

  heatpumpCmdDevLastupdated = otherdevices_lastupdate[heatpumpCmdDev]
  irCmd = otherdevices[heatpumpCmdDev]

  heatpumpTimeDiff = domoticz_functions.timedifference(heatpumpCmdDevLastupdated)

  if (heatpumpTimeDiff > 15 and heatpumpTimeDiff < 255) then
    print(apartment .. ': ' .. heatpumpResendMsg)
    os.execute('mosquitto_pub -t domoticz/out -m \'{"idx": ' .. otherdevices_idx[heatpumpCmdDev] .. ', "svalue1": ' .. irCmd .. '}\'')
  end

end

return commandArray
