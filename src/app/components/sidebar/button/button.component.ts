import { MatIconModule } from '@angular/material/icon';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'button-component',
  styleUrl: './button.component.scss',
  standalone: true,
  imports: [MatIconModule],
  template: `<button
    class="menu-item"
    [disabled]="disabled"
    (click)="onAction()"
  >
    <i class="fas {{ icon }}"></i>
    <span>{{ title }}</span>
  </button> `,
})
export class ButtonComponent {
  @Input() action: (() => void) | null = null;
  @Input() title: string = '';
  @Input() icon: string = '';
  @Input() disabled = false;
  @Input() selected = false;

  onAction() {
    if (this.action) this.action();
  }
}
