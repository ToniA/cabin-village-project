local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

for key, value in pairs(devicechanged) do
  if (key == heatpumpDev) then
    if (value == normalState) then
      print(heatpumpNormalStateMsg)
      powerModeCmd = '12'   -- ON + HEAT
      fanSpeedCmd = uservariables[heatpumpNormalFanSpeedVar]
      temperatureCmd = uservariables[heatpumpNormalTempVar]
    else
      print(heatpumpMaintenanceStateMsg)
      powerModeCmd = '16'   -- ON + MAINTENANCE
      fanSpeedCmd = 5       -- FAN_5
      temperatureCmd = 10   -- 10 degrees
    end

    modelCmd = uservariables[heatpumpModelVar]
    modeCmd = '00' .. modelCmd .. powerModeCmd .. fanSpeedCmd .. string.format("%02X", temperatureCmd)

    commandArray['UpdateDevice'] = otherdevices_idx[textDev] .. '|0|' .. modeCmd
    commandArray[irSendDev] = 'On'
  end
end

return commandArray
