import { ConfigurationComponent } from './configuration/configuration.component';
import { ButtonComponent } from './button/button.component';
import { MatIconModule } from '@angular/material/icon';
import { buttonList } from './button/button.component.list';
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { NgFor } from '@angular/common';
import { AddComponent } from './add/add.component';

@Component({
  selector: 'sidebar-component',
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.scss',
  standalone: true,
  imports: [
    ConfigurationComponent,
    ButtonComponent,
    AddComponent,
    MatIconModule,
    NgFor,
  ],
})
export class SidebarComponent {
  disabledMenus: string[] = ['Devices', 'Edge'];

  menuItens: ButtonComponent[] = buttonList;

  constructor(private router: Router) {
    const selectedMenu = this.menuItens.find((m) => m.title == 'Map');
    if (selectedMenu) selectedMenu.selected = true;
    this.disabledMenus.forEach((menu) => {
      const disableMenu = this.menuItens.find((m) => m.title == menu);
      if (disableMenu) disableMenu.disabled = true;
    });

    if (selectedMenu?.action) selectedMenu.action(this.router);
  }

  test() {
    console.log('hup');
  }
}
