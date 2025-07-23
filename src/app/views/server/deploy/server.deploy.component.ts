import { FormBuilder, FormGroup } from '@angular/forms';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'server-deploy-component',
  styleUrl: './server.deploy.component.scss',
  templateUrl: './server.deploy.component.html',
})
export class ServerDeployComponent implements OnInit {
  sbcConfigGroup: FormGroup;
  sbcBurnerGroup: FormGroup;

  constructor(_formBuilder: FormBuilder) {
    this.sbcConfigGroup = _formBuilder.group({ ctrl: [''] });
    this.sbcBurnerGroup = _formBuilder.group({ ctrl: [''] });
  }

  ngOnInit(): void {
    if (!('usb' in navigator)) {
      alert(
        'USB is not supported by your browser.' +
          'You will not be able to burn it directly to your sbc sdcard,' +
          'but you can still download the image and use an external burner.'
      );
    }
  }
}
