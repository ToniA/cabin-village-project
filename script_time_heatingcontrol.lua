local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
domoticz_functions = require('domoticz_functions')
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
         ((room_config["delayed"] == 1) and
           otherdevices[apartment .. ': ' .. heatingDev] == normalStateDelayed)) then
      -- 'Maintenance' state, thermostat control around 'maintenanceTemperatureVar'
      -- * or delayed radiator in delayed state

      maintenanceTemperature = uservariables[maintenanceTemperatureVar]
      hysteresis = uservariables[maintenanceHysteresisVar] / 2

      currentState = otherdevices[apartment .. ': ' .. relayDev .. room_config["name"]]

      if (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] > maintenanceTemperature + hysteresis) then
        newState = 'Off'
      elseif (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] < maintenanceTemperature - hysteresis) then
        newState = 'On'
      else
        newState = currentState
      end

      currentStateId = currentState == 'On' and 1 or 0

      -- Domoticz switch log does not work if it's updated too frequently
      if (newState == currentState) then
        os.execute('mosquitto_pub -t domoticz/out -m \'{"idx": ' .. otherdevices_idx[apartment .. ': ' .. relayDev .. room_config["name"]] .. ', "nvalue": ' .. currentStateId .. '}\'')
      else
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = newState
      end
    elseif (otherdevices[apartment .. ': ' .. heatingDev] == normalState and
            room_config["delayed"] == 0) then
      -- 'Normal' state for delayed radiator
      -- If 'Off', thermostat control around 'maintenanceTemperatureVar'
      -- If 'On', thermostat control around 'normalTemperatureVar'
      -- State in Domoticz is not updated, as the radiator On/Off is controlled manually

      maintenanceTemperature = uservariables[maintenanceTemperatureVar]
      normalTemperature = uservariables[apartment .. ': ' .. normalTemperatureVar]
      hysteresis = uservariables[maintenanceHysteresisVar] / 2

      currentState = otherdevices[apartment .. ': ' .. relayDev .. room_config["name"]]

      if (currentState == 'Off') then
        if (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] > maintenanceTemperature + hysteresis) then
          newState = 'Off'
        elseif (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] < maintenanceTemperature - hysteresis) then
          newState = 'On'
        else
          newState = currentState
        end
      else
        if (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] > normalTemperature + 0.5) then
          newState = 'Off'
        elseif (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] < normalTemperature - 0.5) then
          newState = 'On'
        else
          newState = currentState
        end
      end

      newStateId = newState == 'On' and 1 or 0
      os.execute('mosquitto_pub -t domoticz/out -m \'{"idx": ' .. otherdevices_idx[apartment .. ': ' .. relayDev .. room_config["name"]] .. ', "nvalue": ' .. newStateId .. '}\'')
    elseif (otherdevices[apartment .. ': ' .. heatingDev] == normalState or
             ((room_config["delayed"] == 0) and
               otherdevices[apartment .. ': ' .. heatingDev] == normalStateDelayed)) then
      -- 'Normal' state, thermostat control around 'normalTemperatureVar'
      -- * or non-delayed radiator in delayed state

      normalTemperature = uservariables[apartment .. ': ' .. normalTemperatureVar]

      currentState = otherdevices[apartment .. ': ' .. relayDev .. room_config["name"]]

      if (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] > normalTemperature + 0.5) then
        newState = 'Off'
      elseif (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] < normalTemperature - 0.5) then
        newState = 'On'
      else
        newState = currentState
      end

      currentStateId = currentState == 'On' and 1 or 0

      if (newState == currentState) then
        os.execute('mosquitto_pub -t domoticz/out -m \'{"idx": ' .. otherdevices_idx[apartment .. ': ' .. relayDev .. room_config["name"]] .. ', "nvalue": ' .. currentStateId .. '}\'')
      else
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = newState
      end

      -- Time condition? After 13:00, and has not reached normalTemperature -> Powerful state

      --if (domoticz_functions.timedifference(otherdevices_lastupdate[apartment .. ': ' .. masterStateDev]) < 86400) then
      --  commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. masterStateDev] .. '&svalue=30'}
      --end

    elseif (otherdevices[apartment .. ': ' .. heatingDev] == powerfulState) then
      -- 'Powerful' state, all radiators on all the time, only limited by their own thermostat control
      -- * Turn apartment to 'normal' state once temperature has reached the 'normal' temperature on any room

      normalTemperature = uservariables[apartment .. ': ' .. normalTemperatureVar]

      currentState = otherdevices[apartment .. ': ' .. relayDev .. room_config["name"]]
      if (currentState == 'On') then
        os.execute('mosquitto_pub -t domoticz/out -m \'{"idx": ' .. otherdevices_idx[apartment .. ': ' .. relayDev .. room_config["name"]] .. ', "nvalue": 1}\'')
      else
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
      end

      if (otherdevices_temperature[apartment .. ': ' .. temperatureDev .. room_config["name"]] > normalTemperature) then
        commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatingDev] .. '&svalue=10'}
        commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. masterStateDev] .. '&svalue=10'}
      end
    elseif (otherdevices[apartment .. ': ' .. heatingDev] == 'Off') then
      currentState = otherdevices[apartment .. ': ' .. relayDev .. room_config["name"]]
      if (currentState == 'Off') then
        os.execute('mosquitto_pub -t domoticz/out -m \'{"idx": ' .. otherdevices_idx[apartment .. ': ' .. relayDev .. room_config["name"]] .. ', "nvalue": 0}\'')
      else
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'Off'
      end
    end
  end
end

return commandArray
