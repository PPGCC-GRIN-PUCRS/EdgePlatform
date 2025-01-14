import { Component } from '@angular/core';
import { MatIconModule, MatIcon } from '@angular/material/icon';
import { Router } from '@angular/router';

@Component({
  selector: 'add-sidebar-button',
  standalone: true,
  imports: [MatIcon, MatIconModule],
  styleUrl: '../extra.button.component.scss',
  template: `
    <button class="extra-button plus-button" (click)="redirect()">
      <mat-icon>add</mat-icon>
    </button>
  `,
})
export class AddComponent {
  constructor(private router: Router) {}

  redirect() {
    this.router.navigate([`server/new`]);
  }
}
