/**
 * The MySensors Arduino library handles the wireless radio link and protocol
 * between your home built sensors/actuators and HA controller of choice.
 * The sensors forms a self healing radio network with optional repeaters. Each
 * repeater and gateway builds a routing tables in EEPROM which keeps track of the
 * network topology allowing messages to be routed to nodes.
 *
 * Created by Henrik Ekblad <henrik.ekblad@mysensors.org>
 * Copyright (C) 2013-2015 Sensnology AB
 * Full contributor list: https://github.com/mysensors/Arduino/graphs/contributors
 *
 * Documentation: http://www.mysensors.org
 * Support Forum: http://forum.mysensors.org
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 *******************************
 *
 * REVISION HISTORY
 * Version 1.0 - Henrik Ekblad
 *
 * DESCRIPTION
 * Example sketch showing how to control physical relays.
 * This example will remember relay state after power failure.
 * http://www.mysensors.org/build/relay
 */

 /*
  * This sketch is for the cabin project, to control a relay on ITEAD Studio Mini RBoard
  * http://wiki.iteadstudio.com/Mini_Rboard
  * 
  * The sketch is based on the 'RelayActuator' example of the MySensors project
  * 
  * The 433MHz RX module's header is used for 1-wire sensors (1x DS18B20 temperature sensor)
  */

// Enable debug prints to serial monitor
#define MY_DEBUG

// Enable and select radio type attached
#define MY_RADIO_NRF24

// Channel 1
#define MY_RF24_CHANNEL  1

// Safe baud rate for a 3.3V device
#define MY_BAUD_RATE 9600

// Enable repeater functionality for this node
#define MY_REPEATER_FEATURE

#include <SPI.h>
#include <MySensor.h>
#include <DallasTemperature.h>
#include <OneWire.h>
#include <Timer.h>                   // Timer library, https://github.com/JChristensen/Timer


#define RELAY     4                  // Arduino Digital I/O pin number for first relay (second on pin+1 etc)
#define RELAY_ON  1                  // GPIO value to write to turn on attached relay
#define RELAY_OFF 0                  // GPIO value to write to turn off attached relay


#define ONE_WIRE_BUS 3               // Pin where the Dallas sensor is connected, RX module 'DATA' pin
OneWire oneWire(ONE_WIRE_BUS);       // Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
DallasTemperature sensors(&oneWire); // Pass the oneWire reference to Dallas Temperature.


// Timer for the temperature measurements
Timer timer;

// Initialize temperature message
MyMessage temperatureMsg(0,V_TEMP);


void setup()
{
  pinMode(RELAY, OUTPUT);
  // Set the relay to the last known state (using EEPROM storage)
  digitalWrite(RELAY, loadState(RELAY)?RELAY_ON:RELAY_OFF);

  // Startup up the OneWire library
  sensors.begin();
  // requestTemperatures() will not block current thread
  sensors.setWaitForConversion(false);

  Serial.print("Found ");
  Serial.print(sensors.getDeviceCount(), DEC);
  Serial.println(" devices.");

  // Measure temperature once per minute
  timer.every(60000, requestTemperatureMeasurements);
}


void presentation()
{
  // Send the sketch version information to the gateway and Controller
  sendSketchInfo("Relay & Temperature", "1.0");

  // Present the sensors
  present(0, S_LIGHT);
  present(1, S_TEMP);
}


void loop()
{
  timer.update();
}


//
// Relay switch command from the controller
//
void receive(const MyMessage &message) {
  // We only expect one type of message from controller. But we better check anyway.
  if (message.type==V_LIGHT) {
     // Change the relay state
     digitalWrite(RELAY, message.getBool()?RELAY_ON:RELAY_OFF);
     // Store the relay state in EEPROM
     saveState(RELAY, message.getBool());

     // Write some debug info
     Serial.print("Incoming change for sensor:");
     Serial.print(message.sensor);
     Serial.print(", New status: ");
     Serial.println(message.getBool());
   }
}


//
// Request temperature from the DS18B20 sensor
//
void requestTemperatureMeasurements()
{
  Serial.println("Requesting temperature...");
  sensors.requestTemperatures(); // Send the command to get temperatures

  timer.after(1500, sendTemperatureMeasurements);
}


//
// Read temperature from the DS18B20 sensor, and send the temperature message
//
void sendTemperatureMeasurements()
{
  float temperature = sensors.getTempCByIndex(0);
  Serial.print("Temperature for the device 1 (index 0) is: ");
  Serial.println(temperature);

  // Do not send erratic measurements
  if ((int)temperature != 85 && (int)temperature != DEVICE_DISCONNECTED_C) {
    send(temperatureMsg.set(temperature,1));
  }
}
