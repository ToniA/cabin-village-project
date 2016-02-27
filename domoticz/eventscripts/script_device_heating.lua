local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'
require('settings')


commandArray = {}

for key, value in pairs(devicechanged) do
  if (key == heatingDev) then
    if (value == normalState) then
      print(radiatorNormalStateMsg)
      commandArray[relay1Dev] = 'On'
      commandArray[relay2Dev] = 'On'
      commandArray[relay3Dev] = 'On'
      commandArray[delayDummySwitchDev] = 'On'
    end
    if (value == normalStateDelayed) then
      print(radiatorNormalStateDelayedMsg)

      heatingDelay = uservariables[heatingDelayVar]

      commandArray[delayDummySwitchDev] = 'On AFTER ' .. heatingDelay
    end
    if (value == maintenanceState) then
      print(radiatorMaintenanceStateMsg)
      commandArray[relay1Dev] = 'Off'
      commandArray[relay2Dev] = 'Off'
      commandArray[relay3Dev] = 'Off'
      commandArray[delayDummySwitchDev] = 'Off'
    end
  end

  -- Turn heating on when the dummy delay switch turns on
  if (key == delayDummySwitchDev and value == 'On' and otherdevices[heatingDev] == normalStateDelayed) then
    print(radiatorNormalStateMsg)
    commandArray['UpdateDevice'] = otherdevices_idx[heatingDev] .. '|0|10'
    commandArray[relay1Dev] = 'On'
    commandArray[relay2Dev] = 'On'
    commandArray[relay3Dev] = 'On'
  end
end

return commandArray
