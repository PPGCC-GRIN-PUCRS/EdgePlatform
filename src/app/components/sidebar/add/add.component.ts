import { Component } from '@angular/core';
import { MatIcon } from '@angular/material/icon';

@Component({
  selector: 'add-sidebar-button',
  standalone: true,
  imports: [MatIcon],
  styleUrl: '../extra.button.component.scss',
  template: `
    <button class="extra-button plus-button" mat-icon-button (click)="test()">
      <mat-icon>add</mat-icon>
    </button>
  `,
})
export class AddComponent {
  test() {}
}
