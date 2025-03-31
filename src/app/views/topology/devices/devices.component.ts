import { Component } from '@angular/core';
import { AppComponent } from '@app/app.component';

@Component({
  selector: 'devices-view',
  templateUrl: './devices.component.html',
  styleUrl: './devices.component.scss',
})
export class DevicesComponent {

  constructor(private app: AppComponent) {
    this.app.disableSidebar()
  }
  
}
