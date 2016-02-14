-- These are the configuration variables, set them according to your system
heatingDevice = 'Lämmityksen tila'

commandArray = {}

for key, value in pairs(devicechanged) do
  if (key == 'Lämmityksen tila') then
    if (value == 'Normaali') then
      print("Lämmitys: Normaali")
      commandArray['Alakerta huone rele'] = 'On'
      commandArray['Yläkerta huone 1 rele'] = 'On'
      commandArray['Yläkerta huone 2 rele'] = 'On'
    end
    if (value == 'Normaali viivästetty') then
      print("Lämmitys: Päälle viiveen jälkeen")

      heatingDelay = uservariables['lämmitysviive']

      commandArray['Alakerta huone rele'] = 'On AFTER ' .. heatingDelay
      commandArray['Yläkerta huone 1 rele'] = 'On AFTER ' .. heatingDelay
      commandArray['Yläkerta huone 2 rele'] = 'On AFTER ' .. heatingDelay
    end
    if (value == 'Ylläpito') then
      print("Lämmitys: Ylläpito")
      commandArray['Alakerta huone rele'] = 'Off'
      commandArray['Yläkerta huone 1 rele'] = 'Off'
      commandArray['Yläkerta huone 2 rele'] = 'Off'
    end
  end

  if (key == 'Alakerta huone rele' and value == 'On' and  otherdevices[heatingDevice] == 'Normaali viivästetty') then
    commandArray['UpdateDevice'] = otherdevices_idx[heatingDevice] .. '|0|10'
  end

end

return commandArray
