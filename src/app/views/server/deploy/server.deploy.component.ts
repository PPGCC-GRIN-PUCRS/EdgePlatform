import { FormBuilder, FormGroup } from '@angular/forms';
import { Component } from '@angular/core';

@Component({
  selector: 'server-deploy-component',
  styleUrl: './server.deploy.component.scss',
  templateUrl: './server.deploy.component.html',
})
export class ServerDeployComponent {
  sbcConfigGroup: FormGroup;
  sbcBurnerGroup: FormGroup;

  constructor(_formBuilder: FormBuilder) {
    this.sbcConfigGroup = _formBuilder.group({ctrl: ['']});
    this.sbcBurnerGroup = _formBuilder.group({ctrl: ['']});
  }

}
