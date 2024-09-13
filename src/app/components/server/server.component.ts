import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-server',
  standalone: true,
  imports: [],
  templateUrl: './server.component.html',
  styleUrl: './server.component.scss',
})
export class ServerComponent {
  @Input() lat!: number;
  @Input() lng!: number;
  @Input() ip!: HTMLElement;
}
