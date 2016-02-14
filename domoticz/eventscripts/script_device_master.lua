-- These are the configuration variables, set them according to your system
heatingDevice = 'Lämmityksen tila'
heatpumpDevice = 'Ilmalämpöpumpun tila'

commandArray = {}


for key, value in pairs(devicechanged) do
  if (key == 'Mökin tila') then

    if (value == 'Normaali') then
      print("Mökin normaalitila")

      commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatpumpDevice] .. '&svalue=10'}
      if (otherdevices[heatingDevice] ~= 'Normaali') then
        print("Viivästetty lämmitys")
        commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatingDevice] .. '&svalue=20'}
      else
        commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatingDevice] .. '&svalue=10'}
      end
    else
      print("Mökin ylläpitotila")

      commandArray[1] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatpumpDevice] .. '&svalue=20'}
      commandArray[2] = {['OpenURL'] = 'http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=' .. otherdevices_idx[heatingDevice] .. '&svalue=30'}
    end
  end
end

return commandArray
