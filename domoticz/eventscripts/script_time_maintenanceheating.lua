local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

-- Simple thermostat control for the maintenance heating mode
if (otherdevices[heatingDev] == maintenanceState or
    otherdevices[heatingDev] == normalStateDelayed) then

  maintenanceTemperature = uservariables[maintenanceTemperatureVar]
  hysteresis = uservariables[maintenanceHysteresisVar] / 2

  if (otherdevices_temperature[temperature1Dev] > maintenanceTemperature + hysteresis) then
    commandArray[relay1Dev] = 'Off'
  elseif (otherdevices_temperature[temperature1Dev] < maintenanceTemperature - hysteresis) then
    commandArray[relay1Dev] = 'On'
  end

  if (otherdevices_temperature[temperature2Dev] > maintenanceTemperature + hysteresis) then
    commandArray[relay2Dev] = 'Off'
    commandArray[relay3Dev] = 'Off'
  elseif (otherdevices_temperature[temperature2Dev] < maintenanceTemperature - hysteresis) then
    commandArray[relay2Dev] = 'On'
    commandArray[relay3Dev] = 'On'
  end
end

return commandArray