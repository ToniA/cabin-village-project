# cabin-village-project
Software to control heatpumps and heating in a vacation home village

The Domoticz events are in Finnish, as Domoticz is configured to show the Finnish user interface

The purpose is to control both the heating and the heat pumps at the same time.

## Hardware

* Raspberry Pi, running Domoticz (V2.4577) on Debian Wheezy. Ethernet connection to the 3G router
* MySensors Serial Gateway, built on Sensebender + nRF24, running CabinGatewaySerial.ino
* 3x ITEAD Studios mini RBoards (relay board) + 3x nRF24, running CabinRelayActuator.ino
   * Two of these have DS18B20 connected to the 'DATA' pin of the 433 MHz receiver header, to measure temperatures
   * These control the heating, switching between maintenance (~ +10 degrees C) and normal heating
* MySensors IR controller, built on Sensebender + nRF24, running CabinHeatpumpIRController.ino
   * 940 nm IR led + ~1kOhm resistor connected between D3 and GND
   * This controls the heatpump through infrared

## Remote access

Raspberry is configured to run Weaved for remote access (http to local port 8080 & ssh). See https://www.weaved.com/installing-weaved-raspberry-pi-raspbian-os/

http://weaved.com -> 'sign in' is the remote access portal 

## Domoticz configuration

In addition to the MySensors devices (Domoticz creates these automatically, these just need to be added as active devices, also a name must be given), the 'dummy' hardware is added to add three dummy multiselector devices:
* 'master' control called 'Mökin tila', with states 'Normaali' (normal heating mode) and 'Ylläpito' (heating set +10 degrees maintenance heating)
   * Background event script 'script_device_master.lua' controls the heatpump and electric heating based on state changes of this device
* Heatpump control called 'Ilmalämpöpumpun tila', with states 'Normaali' and 'Ylläpito'
   * Background event script 'script_device_hp.lua' translates the state to a command to the MySensors IR controller node
* Electric heating control called 'Lämmityksen tila', with states 'Normaali', 'Normaali viivästetty' (switching to 'normal' after a delay) and 'Ylläpito'
   * Background event script 'script_device_heating.lua' translates the state to commands to the MySensors relay controller node. It also implements the heating delay, i.e. when switching from maintenance heating, the heatpump starts first, and the electric heaters will follow later
* MySensors device names
   * 'Alakerta huone rele', relay downstairs
   * 'Yläkerta huone 1 rele', relay #1 upstairs
   * 'Yläkerta huone 2 rele', relay #2 upstairs
   * 'IR data', IR node text sensor
   * 'IR send', IR node 'switch' sensor
   * 'Alakerta lämpötila', temperature from the relay downstairs
   * 'Yläkerta huone 1 lämpötila', temperature from the relay #1 upstairs

The Domoticz dashboard only shows the 'Mökin tila' and the temperature measurements. This is for simplicity of the UI.

Domoticz user variables
* 'pumppumalli' (string) is the model of the heatpump. It's just an index (in HEX) to the list of models in CabinHeatpumpIRController.ino. Note that only some of the heatpump models actually support maintenance heating
* 'lämmitysviive' (string) is the number of seconds to wait before switching electric heating to 'normal' state. For example 7200, i.e. two hours
   
