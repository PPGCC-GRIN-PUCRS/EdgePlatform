import { Component, HostBinding } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { Router } from '@angular/router';

@Component({
  selector: 'sidebar-component',
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.scss',
  standalone: true,
  imports: [MatIconModule],
})
export class SidebarComponent {
  activeMenu: string;
  disabledMenus: string[] = ['Devices', 'Edge'];

  constructor(private router: Router) {
    this.activeMenu = 'Map';
    this.setActive(this.activeMenu);
  }

  setActive(menu: string) {
    if (!this.disabledMenus.includes(menu)) {
      this.activeMenu = menu;
      console.log(menu);
      this.router.navigate([`${menu}`]);
    }
  }
}
