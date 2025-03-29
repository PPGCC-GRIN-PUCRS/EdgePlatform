import { MatIconModule } from '@angular/material/icon';
import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'button-component',
  styleUrl: './button.component.scss',
  standalone: true,
  imports: [MatIconModule, CommonModule],
  template: `<button
    class="menu-item"
    [ngClass]="{ 'selected': true === this.selected }"
    [disabled]="disabled"
    (click)="onAction()"
  >
    <i class="fas {{ icon }}"></i>
    <span>{{ title }}</span>
  </button> `,
})
export class ButtonComponent {
  @Input() action: ((router: Router) => void) | null = null;
  @Input() title!: string;
  @Input() icon!: string;
  @Input() disabled!: boolean;
  @Input() selected!: boolean;
  
  constructor(private router: Router) {}
  onAction() {
    if (this.action && !this.disabled) {
      // this.selected = true;
      this.action(this.router);
    }
  }
}
