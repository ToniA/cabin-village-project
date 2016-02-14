-- These are the configuration variables, set them according to your system
textDev = 'IR data'   -- Idx of the 'IR data' MySensors device
irSendDev = 'IR send' -- Name of the 'IR send' MySensors device


commandArray = {}

for key, value in pairs(devicechanged) do
  if (key == 'Ilmalämpöpumpun tila') then

    if (value == 'Normaali') then
      print("Lämpöpumpun normaalitila")
      powerModeCmd = '12'   -- ON + HEAT
      fanSpeedCmd = 0       -- AUTO
      temperatureCmd = 22
    else
      print("Lämpöpumpun ylläpitotila")
      powerModeCmd = '16'   -- ON + MAINTENANCE
      fanSpeedCmd = 5       -- FAN_5 
      temperatureCmd = 10   -- 10 degrees
    end

    modelCmd = uservariables['pumppumalli']

    modeCmd = '00' .. modelCmd .. powerModeCmd .. fanSpeedCmd .. string.format("%02x", temperatureCmd)

    commandArray['UpdateDevice'] = otherdevices_idx[textDev] .. '|0|' .. modeCmd 
    commandArray[irSendDev] = 'On'

  end
end

return commandArray
