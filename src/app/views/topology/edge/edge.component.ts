import { Component } from '@angular/core';
import { AppComponent } from '@app/app.component';

@Component({
  selector: 'edge-view',
  templateUrl: './edge.component.html',
  styleUrl: './edge.component.scss',
})
export class EdgeComponent {

  constructor(private app: AppComponent) {
    this.app.disableSidebar()
  }
  
}
