import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Location } from '@angular/common';
import { Component } from '@angular/core';
import { ServerValidationService } from '../../../services/server-validation.service';
import {
  countryCodeISOList,
  keyboardLayoutList,
  serverFunctionsList,
  timezoneList,
} from './server.deploy.lists';

@Component({
  selector: 'server-deploy-component',
  styleUrl: './server.deploy.component.scss',
  templateUrl: './server.deploy.component.html',
})
export class ServerDeployComponent {
  authenticationMethod: string = 'password';
  useCableNetwork: boolean = false;
  publicKey: string | null = null;
  serverForm: FormGroup;
  showPassword = false;
  isGenerated = false;
  isEditing = false;

  serverFunctions = serverFunctionsList.sort((x, y) => {
    return x === y ? 0 : x ? -1 : 1;
  });

  keyboardLayouts = keyboardLayoutList;
  countryCodes = countryCodeISOList;
  timezones = timezoneList;

  constructor(private fb: FormBuilder, private location: Location) {
    this.serverForm = this.fb.group({
      // SERVER INFORMATION
      hostname: [
        'Grin-Cluster#2',
        [Validators.required]
      ],
      staticIp: [
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
      serverFunction: [{ value: '', disabled: false }, [Validators.required]],
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
    this.toggleCableNetwork()
  }

  ngOnInit(): void {}

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

  onSubmit(): void {
    if (this.serverForm.valid) {
      console.log(this.serverForm.value);
    } else {
      console.error('Form is invalid');
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
}
