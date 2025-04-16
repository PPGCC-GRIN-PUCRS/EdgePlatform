import { Component } from '@angular/core';
import { AppComponent } from '@app/app.component';

@Component({
  selector: 'fog-view',
  templateUrl: './fog.component.html',
  styleUrl: './fog.component.scss',
})
export class FogComponent {

  constructor(private app: AppComponent) {
    this.app.enableSidebar()
  }
  
}