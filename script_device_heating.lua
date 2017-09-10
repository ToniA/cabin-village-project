local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

for i, apartment_config in pairs(apartment_configs) do
  apartment = apartment_config["apartment"]
  -- Heating master state switch (normal, delayed, maintenance, powerful)
  for key, value in pairs(devicechanged) do
    if (key == apartment .. ': ' .. heatingDev) then
      if (value == 'Off') then
        print(apartment .. ": " .. radiatorOffStateMsg)
        for j, room_config in ipairs(apartment_config["rooms"]) do
          commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'Off'
        end
        commandArray[apartment .. ': ' .. delayDummySwitchDev] = 'Off'
      elseif (value == normalState) then
        print(apartment .. ": " .. radiatorNormalStateMsg)
        for j, room_config in ipairs(apartment_config["rooms"]) do
          if (room_config["delayed"] == 1) then
            commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'Off'
          else
            commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
          end
        end
        commandArray[apartment .. ': ' .. delayDummySwitchDev] = 'On'
      elseif (value == normalStateDelayed) then
        print(apartment .. ": " .. radiatorNormalStateDelayedMsg)
        for j, room_config in ipairs(apartment_config["rooms"]) do
          if (room_config["delayed"] == 0) then
            commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
          end
        end 
        heatingDelay = uservariables[apartment .. ": " .. heatingDelayVar]
        commandArray[apartment .. ': ' .. delayDummySwitchDev] = 'On AFTER ' .. heatingDelay
      elseif (value == maintenanceState) then
        print(apartment .. ": " .. radiatorMaintenanceStateMsg)
        for j, room_config in ipairs(apartment_config["rooms"]) do 
          commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'Off'
        end
        commandArray[apartment .. ': ' .. delayDummySwitchDev] = 'Off'
      elseif (value == powerfulState) then
        print(apartment .. ": " .. radiatorPowerfulStateMsg)
        for j, room_config in ipairs(apartment_config["rooms"]) do
          commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
        end
        commandArray[apartment .. ': ' .. delayDummySwitchDev] = 'On'
      end
    end
  
    -- Turn heating on when the dummy delay switch turns on
    if (key == apartment .. ': ' ..delayDummySwitchDev and value == 'On' and otherdevices[apartment .. ': ' ..heatingDev] == normalStateDelayed) then
      print(apartment .. ": " .. radiatorNormalStateMsg)
      commandArray['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatingDev] .. '&svalue=10'
      for j, room_config in ipairs(apartment_config["rooms"]) do
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
      end
    end
  end
end

return commandArray