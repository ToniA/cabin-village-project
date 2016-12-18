local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

-- Simple thermostat control for the maintenance heating mode
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
      end
    else
      commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
    end
  end
end

return commandArray