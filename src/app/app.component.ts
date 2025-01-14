import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent {
  sidebarEnabled: boolean = true;
  title = 'EdgePlatform';

  constructor() {
    this.sidebarEnabled = true;
  }

  enableSidebar() {
    this.sidebarEnabled = true;
  }

  disableSidebar() {
    this.sidebarEnabled = false;
  }
}
