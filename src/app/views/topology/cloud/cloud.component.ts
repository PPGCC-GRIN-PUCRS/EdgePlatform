import { Component } from '@angular/core';
import { AppComponent } from '@app/app.component';

@Component({
  selector: 'cloud-view',
  templateUrl: './cloud.component.html',
  styleUrl: './cloud.component.scss',
})
export class CloudComponent {

  constructor(private app: AppComponent) {
    this.app.enableSidebar()
  }
  
}
