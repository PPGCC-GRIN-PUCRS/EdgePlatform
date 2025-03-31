import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Location } from '@angular/common';
import { Component, Input } from '@angular/core';
import { ServerValidationService } from '@services/server-validation.service';
import {
  configurationErrorsMessageList,
  serverFunctionsList,
  countryCodeISOList,
  keyboardLayoutList,
  timezoneList,
} from '../server.deploy.step.lists';

@Component({
  selector: 'server-deploy-step-sbc-config',
  styleUrl: './server.deploy.step.sbc.config.scss',
  templateUrl: './server.deploy.step.sbc.config.html',
})
export class ServerDeployStepSBCConfig {
  authenticationMethod: string = 'password';
  useCableNetwork: boolean = false;
  publicKey: string | null = null;
  showPassword = false;
  isGenerated = false;
  isEditing = false;
  
  @Input() serverForm: FormGroup;
  
  serverFunctions = serverFunctionsList.sort((x, y) => {
    return x === y ? 0 : x ? -1 : 1;
  });
  
  keyboardLayouts = keyboardLayoutList;
  countryCodes = countryCodeISOList;
  errorsMessage: Map<string,string> = configurationErrorsMessageList;
  timezones = timezoneList;

  constructor(private fb: FormBuilder, private location: Location) {
    this.serverForm = this.fb.group({
      // SERVER INFORMATION
      hostname: [
        'Grin-Cluster#2',
        [Validators.required]
      ],
      serverIp: [
        '192.168.0.1',
        [Validators.required, ServerValidationService.ipValidatorPattern()],
      ],
      platformIp: [
        'www.grin.logiclabsoftwares.com/ingress',
        [
          Validators.required,
          ServerValidationService.ipOrDNSValidatorPattern(),
        ],
      ],

      // SERVER AUTHENTICATION
      // serverFunction: [{ value: '', disabled: false }, [Validators.required]],
      authenticationMethod: ['password'],
      username: ['', [Validators.required]],
      password: ['', [Validators.required]],
      publicKey: [''],
      
      // LAN CONFIGURATION
      ssid: ['', [Validators.required]],
      wifiPassword: ['', [Validators.required]],
      wifiCountry: ['GB', [Validators.required]], // Default value: GB
      
      // LOCATION
      timezone: ['America/Sao_Paulo', [Validators.required]], // Default value: America/Sao_Paulo
      keyboardLayout: ['pt', [Validators.required]], // Default value: pt
    });
  }

  onAuthenticationMethodChange(method: string): void {
    this.authenticationMethod = method;
    if (method === 'password') {
      this.serverForm.get('password')?.setValidators([Validators.required]);
      this.serverForm.get('publicKey')?.clearValidators();
    } else if (method === 'publicKey') {
      this.serverForm.get('publicKey')?.setValidators([Validators.required]);
      this.serverForm.get('password')?.clearValidators();
    }
    this.serverForm.get('password')?.updateValueAndValidity();
    this.serverForm.get('publicKey')?.updateValueAndValidity();
  }

  toggleCableNetwork(): void {
    this.useCableNetwork = !this.useCableNetwork;

    const wifiControls = ['ssid', 'wifiPassword', 'wifiCountry'];
    if (this.useCableNetwork) {
      wifiControls.forEach((control) =>
        this.serverForm.get(control)?.disable()
      );
    } else {
      wifiControls.forEach((control) => this.serverForm.get(control)?.enable());
    }
  }

  goBack(): void {
    this.location.back();
  }

  generatePublicKey(): void {
    this.serverForm.get('publicKey')?.setErrors(null);
    this.serverForm.get('publicKey')?.clearValidators;
    this.publicKey = 'GeneratedPublicKeyData'; // Replace with actual generated key
    this.isGenerated = true;
    this.isEditing = false;
  }

  onPublicKeyChange(event: any): void {
    this.publicKey = event.target.value;
    this.isGenerated = false;
    this.isEditing = true;
  }

  editPublicKey(): void {
    this.isEditing = true;
    // this.publicKey = null; // Clear the existing key to show the text area again
    this.serverForm.get('publicKey')?.clearValidators;
    this.serverForm.get('publicKey')?.setValue(this.publicKey);
  }

  downloadPublicKey(): void {
    const blob = new Blob([this.publicKey ? this.publicKey : ''], {
      type: 'text/plain',
    });
    const link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    link.download = 'public.key';
    link.click();
  }

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  
  findInvalidFields() {
    const invalidFields = [];
    const controls = this.serverForm.controls;
    for (const name in controls) {
        if (controls[name].invalid) {
          invalidFields.push(name);
        }
    }
    return invalidFields;
  }
}