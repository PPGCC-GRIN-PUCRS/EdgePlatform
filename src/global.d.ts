/// <reference types="w3c-web-usb" />

interface Navigator {
  usb?: USB;
}

interface Devices {
  name: string;
  type: string;
  space: string;
  serial: string;
}

interface SBCConfiguration {
  hostname: string;
  serverIp: string;
  platformHost: string;
  authenticationMethod: string;
  username: string;
  password: string;
  publicKey: string;
  ssid: string;
  wifiPassword: string;
  wifiCountry: string;
  timezone: string;
  keyboardLayout: string;
}
