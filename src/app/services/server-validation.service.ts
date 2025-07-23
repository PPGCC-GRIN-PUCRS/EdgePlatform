import { Injectable } from '@angular/core';
import { ValidatorFn, Validators } from '@angular/forms';
@Injectable({
  providedIn: 'root',
})
export class ServerValidationService {

  static ipRegex: string =
    '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.' +
    '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.' +
    '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.' +
    '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' +
    '(\\/.*)?$';

  static dnsRegex: string = 
    '^(?!-)([a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}(\\/.*)?$';
  
  constructor() {}
  
  static ipValidatorPattern(): ValidatorFn {
    return Validators.pattern(`^${this.ipRegex}$`)
  }
  
  static ipOrDNSValidatorPattern(): ValidatorFn {
    return Validators.pattern(`(?:${this.ipRegex}|${this.dnsRegex})`);
  }
}
