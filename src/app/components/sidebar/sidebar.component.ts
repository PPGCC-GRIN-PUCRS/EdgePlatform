import { ConfigurationComponent } from './configuration/configuration.component';
import { ButtonComponent } from './button/button.component';
import { MatIconModule } from '@angular/material/icon';
import { buttonList } from './button/button.component.list';
import { Component, Input } from '@angular/core';
import { NgFor, NgIf } from '@angular/common';
import { AddComponent } from './add/add.component';
import { Router } from '@angular/router';

@Component({
  selector: 'sidebar-component',
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.scss',
  standalone: true,
  imports: [
    ConfigurationComponent,
    ButtonComponent,
    MatIconModule,
    MatIconModule,
    AddComponent,
    NgFor,
    NgIf,
  ],
})
export class SidebarComponent {
  menuItens: ButtonComponent[] = buttonList;
  currentMenu: ButtonComponent | null;
  disabledMenus: string[];

  @Input() enabled: boolean = true;

  constructor() {
    this.currentMenu = null;
    const selectedMenu = this.menuItens.find((m) => m.title == 'Map');
    if (selectedMenu) {
      selectedMenu.selected = true;
      this.currentMenu = selectedMenu;
    }
    
    this.disabledMenus = ['Devices', 'Edge'];
    this.disabledMenus.forEach((menu) => {
      const disableMenu = this.menuItens.find((m) => m.title == menu);
      if (disableMenu) disableMenu.disabled = true;
    });
  }

  change(item: ButtonComponent) {
    if(this.currentMenu)
      this.currentMenu.selected = false

    this.currentMenu = item
    this.currentMenu.selected = true
      console.log('ITEM: ', item);
  }
}
