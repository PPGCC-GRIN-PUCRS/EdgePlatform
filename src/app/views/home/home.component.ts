import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AppComponent } from 'src/app/app.component';

@Component({
  selector: 'home-component',
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss',
})
export class HomeComponent {

  constructor(private app: AppComponent, private router: Router) {
    this.app.disableSidebar()
  }

  redirect() {
    this.router.navigate([`topology/map`]);
  }

}
