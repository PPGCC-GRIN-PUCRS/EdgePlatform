import { Component, HostBinding } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { Router } from '@angular/router';
import { ButtonComponent } from './button/button.component';
import { ConfigurationComponent } from '../configuration/configuration.component';
import { NgFor } from '@angular/common';

@Component({
  selector: 'sidebar-component',
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.scss',
  standalone: true,
  imports: [MatIconModule, ButtonComponent, ConfigurationComponent, NgFor],
})
export class SidebarComponent {
  activeMenu: string;
  disabledMenus: string[] = ['Devices', 'Edge'];

  menuItens: any[] = [
    {
      title: 'Map',
      icon: 'fa-map-marker-alt',
      action: this.test,
      disabled: false,
      selected: false,
    },
    {
      title: 'Cloud',
      icon: 'fa-globe',
      action: this.test,
      disabled: false,
      selected: false,
    },
    {
      title: 'Fog',
      icon: 'fa-water',
      action: this.test,
      disabled: false,
      selected: false,
    },
    {
      title: 'Edge',
      icon: 'fa-server',
      action: this.test,
      disabled: false,
      selected: false,
    },
    {
      title: 'Devices',
      icon: 'fa-tools',
      action: this.test,
      disabled: false,
      selected: false,
    },
  ];

  constructor(private router: Router) {
    this.activeMenu = 'Map';
    this.setActive(this.activeMenu);
  }

  setActive(menu: string) {
    if (!this.disabledMenus.includes(menu)) {
      this.activeMenu = menu;
      this.router.navigate([`${menu}`]);
    }
  }

  test() {
    console.log('olha o clique!');
  }
}
