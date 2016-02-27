local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

for key, value in pairs(devicechanged) do
  if (key == masterStateDev) then

    if (value == normalState) then
      print(normalStateMsg)
      commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatpumpDev] .. '&svalue=10'}

      if (otherdevices[heatingDev] ~= normalState) then
        print(delayedNormalStateMsg)
        commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatingDev] .. '&svalue=20'}
      else
        commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatingDev] .. '&svalue=10'}
      end
    else
      print(maintenanceStateMsg)

      commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatpumpDev] .. '&svalue=20'}
      commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatingDev] .. '&svalue=30'}
    end
  end
end

return commandArray
