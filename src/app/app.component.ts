import { Component, OnInit } from '@angular/core';
import { ChildrenOutletContexts } from '@angular/router';
import { slideInAnimation } from './animations';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
  animations: [
    slideInAnimation
  ]
})
export class AppComponent {
  sidebarEnabled: boolean = true;
  title = 'EdgePlatform';

  constructor(private contexts: ChildrenOutletContexts) {
    this.sidebarEnabled = true;
  }

  enableSidebar() {
    this.sidebarEnabled = true;
  }

  disableSidebar() {
    this.sidebarEnabled = false;
  }

  getRouteAnimationData() {
    return this.contexts.getContext('primary')?.route?.snapshot?.data?.['animation'];
  }

}
