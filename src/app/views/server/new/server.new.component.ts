import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'server-new-component',
  templateUrl: './server.new.component.html',
  styleUrl: './server.new.component.scss',
})
export class ServerNewComponent {
  serverForm: FormGroup;
  authenticationMethod: string = 'password';

  serverFunctions = [
    { label: 'NAS', value: 'nas', disabled: true },
    { label: 'K3s Master', value: 'k3s-master', disabled: false },
    { label: 'K3s Node', value: 'k3s-node', disabled: false },
    { label: 'Image Registry', value: 'image-registry', disabled: true },
  ].sort((x, y) => {
    return x === y ? 0 : x ? -1 : 1;
  });

  countryCodes = ['GB', 'IE', 'IL', 'US', 'BR', 'IN', 'AU', 'CA'];
  timezones = [
    'America/Sao_Paulo',
    'America/Scoresbysund',
    'Europe/London',
    'Asia/Tokyo',
    'Africa/Johannesburg',
  ];
  keyboardLayouts = ['pt', 'us', 'uz', 'vn', 'de', 'fr', 'es'];

  constructor(private fb: FormBuilder) {
    this.serverForm = this.fb.group({
      hostname: ['', [Validators.required]],
      staticIp: [
        '',
        [
          Validators.required,
          Validators.pattern(
            /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
          ),
        ],
      ],
      platformIp: [
        '',
        [
          Validators.required,
          Validators.pattern(
            /^(?:(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$|^[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,})$/
          ),
        ],
      ],
      serverFunction: [{ value: '', disabled: false }, [Validators.required]],
      authenticationMethod: ['password'],
      username: ['', [Validators.required]],
      password: ['', [Validators.required]],
      publicKey: [''],
      ssid: ['', [Validators.required]],
      wifiPassword: ['', [Validators.required]],
      wifiCountry: ['GB', [Validators.required]], // Default value: GB
      timezone: ['America/Sao_Paulo', [Validators.required]], // Default value: America/Sao_Paulo
      keyboardLayout: ['pt', [Validators.required]], // Default value: pt
    });
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

  onSubmit(): void {
    if (this.serverForm.valid) {
      console.log(this.serverForm.value);
    } else {
      console.error('Form is invalid');
    }
  }
}
