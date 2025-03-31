import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { burnerErrorsMessageList } from '../server.deploy.step.lists';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'server-deploy-step-sbc-burner',
  templateUrl: './server.deploy.step.sbc.burner.html',
  styleUrl: './server.deploy.step.sbc.burner.scss'
})
export class ServerDeployStepSBCBurner {
  @Input() burnerForm: FormGroup;

  errorsMessage: Map<string,string> = burnerErrorsMessageList;    

  constructor(private fb: FormBuilder) {
    this.burnerForm = this.fb.group({
      hostname: [
        'Grin-Cluster#2',
        [Validators.required]
      ]
    });
  }


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
