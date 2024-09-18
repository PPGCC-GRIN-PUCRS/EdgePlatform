import { MatIconModule } from '@angular/material/icon';
import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'button-component',
  styleUrl: './button.component.scss',
  standalone: true,
  imports: [MatIconModule],
  template: `<button
    class="menu-item"
    [disabled]="disabled"
    (click)="onAction()"
    (select)="(selected)"
  >
    <i class="fas {{ icon }}"></i>
    <span>{{ title }}</span>
  </button> `,
})
export class ButtonComponent {
  @Input() action: ((router: Router) => void) | null = null;
  @Input() title: string = '';
  @Input() icon: string = '';
  @Input() disabled = false;
  @Input() selected = false;
  constructor(private router: Router) {}
  onAction() {
    if (this.action && !this.disabled) {
      this.selected = true;
      this.action(this.router);
    }
  }
}
