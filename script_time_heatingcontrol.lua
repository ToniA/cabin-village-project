local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

-- Simple thermostat control
-- * 'Maintenance' mode thermostat control
-- * 'Normal' mode thermostat control
-- * 'Powerful' mode, on all the time

for i, apartment_config in pairs(apartment_configs) do
  apartment = apartment_config["apartment"]
  for j, room_config in ipairs(apartment_config["rooms"]) do
    if (otherdevices[apartment .. ': ' .. heatingDev] == maintenanceState or
        otherdevices[apartment .. ': ' .. heatingDev] == normalStateDelayed) then

      maintenanceTemperature = uservariables[maintenanceTemperatureVar]
      hysteresis = uservariables[maintenanceHysteresisVar] / 2
     
      if (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] > maintenanceTemperature + hysteresis) then
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'Off'
      elseif (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] < maintenanceTemperature - hysteresis) then
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
      else
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = otherdevices[apartment .. ': ' .. relayDev .. room_config["name"]]
      end
    elseif (otherdevices[apartment .. ': ' .. heatingDev] == normalState) then
      -- 'Normal' state, thermostat control around 'normalTemperatureVar'

      normalTemperature = uservariables[normalTemperatureVar]
    
      if (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] > normalTemperature + 0.5) then
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'Off'
      elseif (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] < normalTemperature - 0.5) then
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
      else
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = otherdevices[apartment .. ': ' .. relayDev .. room_config["name"]]
      end
    else 
      -- 'Powerful' state, radiators on all the time, only limited by their own thermostat control
      -- * Turn to 'normal' state once temperature has reached 21 degrees
      commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
      commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. masterStateDev] .. '&svalue=10'}
    end
  end
end

return commandArray