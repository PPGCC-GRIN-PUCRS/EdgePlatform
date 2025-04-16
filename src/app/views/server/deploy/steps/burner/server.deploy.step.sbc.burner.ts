import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { burnerErrorsMessageList } from '../server.deploy.step.lists';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'server-deploy-step-sbc-burner',
  templateUrl: './server.deploy.step.sbc.burner.html',
  styleUrl: './server.deploy.step.sbc.burner.scss',
})
export class ServerDeployStepSBCBurner {
  @Input() burnerForm: FormGroup;

  devices: Devices[] = [];
  usb: USB;

  errorsMessage: Map<string, string> = burnerErrorsMessageList;

  constructor(private fb: FormBuilder) {
    this.burnerForm = this.fb.group({
      name: ['', [Validators.required]],
    });

    this.usb = navigator.usb;
  }

  testUsb() {
    this.fetchUsb();
  }

  async fetchUsb() {
    // let devices = await navigator.usb.getDevices();
    try {
      const devices: USBDevice[] = await navigator.usb.getDevices();
      console.log(devices);
      this.devices = devices.map((device) => ({
        name: device.productName || 'Unknown device',
        type:
          this.getDeviceType(device.deviceClass) || String(device.deviceClass),
        space: 'N/A',
        serial: device.serialNumber || 'undefined',
      }));
    } catch (err) {
      console.log(err);
    }
  }

  getDeviceType(classCode: number): string | undefined {
    switch (classCode) {
      case 8:
        return 'Mass Storage'; // Storage device
      case 3:
        return 'Human Interface Device (HID)';
      case 0:
        return 'Control Device';
      case 9:
        return 'Printer';
      case 2:
        return 'Communication Device';
      default:
        return undefined; // For cases where class code is unrecognized
    }
  }

  selectDevice() {
    if (navigator.usb) {
      this.handleUSB();
    } else {
      console.error('WebUSB not enabled (chrome://flags/#new-usb-backend)');
    }
  }

  async handleUSB() {
    const device = await this.usb.requestDevice({
      filters: [
        {
          // vendorId: 0x045E, // Microsoft
          // productId: 0x028E // XBox 360 Controller
        },
      ],
    });

    // const devices = await usb.getDevices(); Only show devices that the page is allowed to use [requestDevice(...)]

    console.log(device);
    await device.open();
    await device.selectConfiguration(1);

    await device.claimInterface(1);

    await device.releaseInterface(1);
    await device.close();
  }

  // const result = await device.transferIn(1, 20);
  // console.log(result)
  // const intData = new Int8Array(result.data.buffer);
  // console.log(intData)

  findInvalidFields() {
    const invalidFields = [];
    const controls = this.burnerForm.controls;
    for (const name in controls) {
      if (controls[name].invalid) {
        invalidFields.push(name);
      }
    }
    return invalidFields;
  }
}
