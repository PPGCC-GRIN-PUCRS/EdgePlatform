import { Component, Input } from '@angular/core';

@Component({
  selector: 'server-component',
  standalone: true,
  imports: [],
  styleUrl: './server.component.scss',
  template: `<button class="menu-item" [disabled]="disabled">
    <i class="fas fa-server"></i>
    <span>{{ ip }}</span>
  </button> `,
})
export class ServerComponent {
  @Input() disabled!: boolean;
  @Input() lat!: number;
  @Input() lng!: number;
  @Input() ip!: HTMLElement;
}
