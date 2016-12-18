local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

for i, apartment_config in pairs(apartment_configs) do
  apartment = apartment_config["apartment"]
  -- Heating master state switch (normal, delayed, maintenance)
  for key, value in pairs(devicechanged) do
    if (key == apartment .. ': ' .. heatingDev) then
      if (value == normalState) then
        print(radiatorNormalStateMsg)
        for j, room_config in ipairs(apartment_config["rooms"]) do
          commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
        end
        commandArray[apartment .. ': ' .. delayDummySwitchDev] = 'On'
      end
      if (value == normalStateDelayed) then
        print(apartment .. ": " .. radiatorNormalStateDelayedMsg)
        for j, room_config in ipairs(apartment_config["rooms"]) do
          if (room_config["delayed"] == 0) then
            commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
          end
        end 
        heatingDelay = uservariables[apartment .. ": " .. heatingDelayVar]
        commandArray[apartment .. ': ' .. delayDummySwitchDev] = 'On AFTER ' .. heatingDelay
      end
      if (value == maintenanceState) then
        print(apartment .. ": " .. radiatorMaintenanceStateMsg)
        for j, room_config in ipairs(apartment_config["rooms"]) do 
          commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'Off'
        end
        commandArray[apartment .. ': ' .. delayDummySwitchDev] = 'Off'
      end
    end
  
    -- Turn heating on when the dummy delay switch turns on
    if (key == apartment .. ': ' ..delayDummySwitchDev and value == 'On' and otherdevices[apartment .. ': ' ..heatingDev] == normalStateDelayed) then
      print(apartment .. ": " .. radiatorNormalStateMsg)
      commandArray['UpdateDevice'] = otherdevices_idx[apartment .. ': ' ..heatingDev] .. '|0|10'
      for j, room_config in ipairs(apartment_config["rooms"]) do
        commandArray[apartment .. ': ' .. relayDev .. room_config["name"]] = 'On'
      end
    end
  end
end

return commandArray