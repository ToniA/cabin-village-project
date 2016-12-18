local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

for i, apartment_config in ipairs(apartment_configs) do
  apartment = apartment_config["apartment"]
  for key, value in pairs(devicechanged) do
    if (key == apartment .. ': ' .. heatpumpDev) then
      if (value == normalState) then
        print(heatpumpNormalStateMsg)
        powerModeCmd = '1,2'  -- ON + HEAT
        fanSpeedCmd = uservariables[heatpumpNormalFanSpeedVar]
        temperatureCmd = uservariables[heatpumpNormalTempVar]
      elseif (value == powerfulState) then
        print(heatpumpNormalStateMsg)
        powerModeCmd = '1,2'  -- ON + HEAT
        fanSpeedCmd = 5
        temperatureCmd = 26
      else
        print(heatpumpMaintenanceStateMsg)
        powerModeCmd = '1,6'  -- ON + MAINTENANCE
        fanSpeedCmd = 5       -- FAN_5
        temperatureCmd = 10   -- 10 degrees
      end

      modeCmd = uservariables[apartment .. ': ' .. heatpumpModelVar] .. ',' .. powerModeCmd .. ',' .. fanSpeedCmd .. ',' .. temperatureCmd .. ',0,0'

      commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. textDev] .. '&svalue=' .. modeCmd}
    end
  end
end

return commandArray