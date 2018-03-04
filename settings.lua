local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
package.path = package.path .. ';' .. scriptPath .. '?.lua'

-- House configuration

houseNameVar = 'talon nimi'

housename = uservariables[houseNameVar]
require('config_' .. housename)

apartments = {}
for i, apartment_config in pairs(apartment_configs) do
  table.insert(apartments, apartment_config["apartment"])
end

-- Device names

masterStateDev = 'Asunnon tila'                  		-- Name of the cabin master state virtual device
heatingDev = 'Lämmityksen tila'                  		-- Name of the radiator master state virtual device
heatpumpDev = 'Ilmalämpöpumpun tila'             		-- Name of the heatpump state virtual device
delayDummySwitchDev = 'Viive apukytkin'          		-- Name of the dummy switch for the heating delay
textDev = 'IR-komento'                           		-- Name of the 'IR data' MySensors device

relayDev = 'Rele '                               		-- Name of the relay device (like 'A: Rele alakerta')
temperatureDev = 'Lämpötila '                    		-- Name of the temperature device (like 'A: Lämpötila alakerta')


-- State names

normalState = 'Normaali'                         		-- Name of the 'normal' heating state (heatpump on, radiators on with thermostat control)
normalStateDelayed = 'Normaali viivästetty'      		-- Name of the 'delayed normal' heating state (heatpump on, radiators on maintenance)
maintenanceState = 'Ylläpito'                    		-- Name of the 'maintenance' heating state(heatpump & radiators on maintenance)
powerfulState = 'Tehostettu'                     		-- Name of the 'powerful' heating state(heatpump on max & radiators on)


-- Variable names

heatpumpModelVar = 'ilp malli'                   		-- Name of the heatpump model variable
heatpumpNormalTempVar = 'ilp pyynti'             		-- Name of the heatpump normal state temperature variable
heatpumpNormalFanSpeedVar = 'ilp puhallus'       		-- Name of the heatpump normal state fan speed variable
heatingDelayVar = 'lämmitysviive'                		-- Name of the heating delay variable
maintenanceTemperatureVar = 'ylläpitolämpö'      		-- Name of the maintenance heating (radiators) temperature variable
maintenanceHysteresisVar = 'ylläpitoraja'        		-- Name of the maintenance heating hysteresis variable
normalTemperatureVar='normaalilämpötila'         		-- Name of the normal temperature variable
delayedTemperatureLowLimitVar='viivästetty alaraja'		-- Name of the lower temperature limit of delayed radiators in 'normal' state
delayedTemperatureHighLimitVar='viivästetty yläraja'	-- Name of the upper temperature limit of delayed radiators in 'normal' state

-- Messages

offStateMsg = 'Asunto: Lämmitys pois päältä'
normalStateMsg = 'Asunto: Normaali lämmitys'
delayedNormalStateMsg = 'Asunto: Viivästetty lämmitys'
maintenanceStateMsg = 'Asunto: Ylläpitolämmitys'
powerfulStateMsg = 'Asunto: Tehostettu lämmitys'

heatpumpOffStateMsg = 'Lämpöpumppu: Pois päältä'
heatpumpNormalStateMsg = 'Lämpöpumppu: Normaalitila'
heatpumpMaintenanceStateMsg = 'Lämpöpumppu: Ylläpitotila'
heatpumpPowerfulStateMsg = 'Lämpöpumppu: Tehostettu tila'
heatpumpResendMsg = 'Lämpöpumppu: Komennon uudelleenlähetys'

radiatorOffStateMsg = 'Lämpöpatterit: Pois päältä'
radiatorNormalStateMsg = 'Lämpöpatterit: Normaalitila'
radiatorNormalStateDelayedMsg = 'Lämpöpatterit: Normaalitilaan viiveellä'
radiatorMaintenanceStateMsg = 'Lämpöpatterit: Ylläpitotila'
radiatorPowerfulStateMsg = 'Lämpöpatterit: Tehostettu tila'
