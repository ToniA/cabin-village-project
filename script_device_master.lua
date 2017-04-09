local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

for i, apartment_config in ipairs(apartment_configs) do
  apartment = apartment_config["apartment"]
  for key, value in pairs(devicechanged) do
    if (key == apartment .. ': ' .. masterStateDev) then
      if (value == 'Off') then
        print(apartment .. ": " .. offStateMsg)
        commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatpumpDev] .. '&svalue=0'}
        commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatingDev] .. '&svalue=0'}
      elseif (value == normalState) then
        print(apartment .. ": " .. normalStateMsg)
        print(apartment .. ': ' .. heatpumpDev)
        commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatpumpDev] .. '&svalue=10'}

        if (otherdevices[apartment .. ': ' .. heatingDev] ~= normalState) then
          print(apartment .. ": " .. delayedNormalStateMsg)
          commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatingDev] .. '&svalue=20'}
        else
          commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatingDev] .. '&svalue=10'}
        end
      elseif (value == powerfulState) then
        print(apartment .. ": " .. powerfulStateMsg)
        commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatpumpDev] .. '&svalue=30'}
        commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatingDev] .. '&svalue=40'}
      else
        print(apartment .. ": " .. maintenanceStateMsg)
        commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatpumpDev] .. '&svalue=20'}
        commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[apartment .. ': ' .. heatingDev] .. '&svalue=30'}
      end
    end
  end
end

return commandArray