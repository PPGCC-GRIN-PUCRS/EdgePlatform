import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ServerDeployStepSBCConfig } from './steps/sbc-configuration/server.deploy.step.sbc.config';

@Component({
  selector: 'server-deploy-component',
  styleUrl: './server.deploy.component.scss',
  templateUrl: './server.deploy.component.html',
})
export class ServerDeployComponent {
  sbcConfigGroup: FormGroup;
  secondFormGroup: FormGroup;

  constructor(_formBuilder: FormBuilder) {
    this.sbcConfigGroup = _formBuilder.group({secondCtrl: ['']});
    this.secondFormGroup = _formBuilder.group({secondCtrl: ['']});
  }

}
