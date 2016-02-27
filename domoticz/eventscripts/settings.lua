-- Device names

masterStateDev = 'Mökin tila'                    -- Name of the cabin master state virtual device
heatingDev = 'Lämmityksen tila'                  -- Name of the radiator master state virtual device
heatpumpDev = 'Ilmalämpöpumpun tila'             -- Name of the heatpump state virtual device
delayDummySwitchDev = 'Viive apukytkin'          -- Name of the dummy switch for the heating delay
textDev = 'IR data'                              -- Name of the 'IR data' MySensors device
irSendDev = 'IR send'                            -- Name of the 'IR send' MySensors device

relay1Dev = 'Alakerta huone rele'                -- Name of the relay downstairs
relay2Dev = 'Yläkerta huone 1 rele'              -- Name of the relay upstairs, room #1
relay3Dev = 'Yläkerta huone 2 rele'              -- Name of the relay upstairs, room #2

temperature1Dev = 'Alakerta lämpötila'           -- Name of the temperature device downstairs
temperature2Dev = 'Yläkerta huone 1 lämpötila'   -- Name of the temperature device upstairs


-- State names

normalState = 'Normaali'                         -- Name of the 'normal' heating state (heatpump on, radiators on)
normalStateDelayed = 'Normaali viivästetty'      -- Name of the 'delayed normal' heating state (heatpump on, radiators on maintenance)
maintenanceState = 'Ylläpito'                    -- Name of the 'maintenance' heating state(heatpump & radiators on maintenance)


-- Variable names

heatpumpModelVar = 'ilp malli'                   -- Name of the heatpump model variable
heatpumpNormalTempVar = 'ilp pyynti'             -- Name of the heatpump normal state temperature variable
heatpumpNormalFanSpeedVar = 'ilp puhallus'       -- Name of the heatpump normal state fan speed variable
heatingDelayVar = 'lämmitysviive'                -- Name of the heating delay variable
maintenanceTemperatureVar = 'ylläpitolämpö'      -- Name of the maintenance heating (radiators) temperature variable
maintenanceHysteresisVar = 'ylläpitoraja'        -- Name of the maintenance heating hysteresis variable

-- Messages

normalStateMsg = 'Mökki: Normaali lämmitys'
delayedNormalStateMsg = 'Mökki: Viivästetty lämmitys'
maintenanceStateMsg = 'Mökki: Ylläpitolämmitys'

heatpumpNormalStateMsg = 'Lämpöpumppu: Normaalitila'
heatpumpMaintenanceStateMsg = 'Lämpöpumppu: Ylläpitotila'

radiatorNormalStateMsg = 'Lämpöpatterit: Normaalitila'
radiatorNormalStateDelayedMsg = 'Lämpöpatterit: Normaalitilaan viiveellä'
radiatorMaintenanceStateMsg = 'Lämpöpatterit: Ylläpitotila'



