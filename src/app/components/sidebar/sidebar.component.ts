import { ConfigurationComponent } from '../configuration/configuration.component';
import { ButtonComponent } from './button/button.component';
import { MatIconModule } from '@angular/material/icon';
import { buttonList } from './button/button.list';
import { Component } from '@angular/core';
import { Router } from '@angular/router';
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

  menuItens: any[] = buttonList;

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
    console.log('hup');
  }
}
