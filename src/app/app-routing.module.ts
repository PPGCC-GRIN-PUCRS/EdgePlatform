import { DevicesComponent } from './views/devices/devices.component';
import { CloudComponent } from './views/cloud/cloud.component';
import { HomeComponent } from './views/home/home.component';
import { EdgeComponent } from './views/edge/edge.component';
import { MapComponent } from './views/map/map.component';
import { FogComponent } from './views/fog/fog.component';
import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';

const routes: Routes = [
  {
    path: '/',
    component: HomeComponent,
  },
  {
    path: 'map',
    component: MapComponent,
  },
  {
    path: 'cloud',
    component: CloudComponent,
  },
  {
    path: 'fog',
    component: FogComponent,
  },
  {
    path: 'edge',
    component: EdgeComponent,
  },
  {
    path: 'devices',
    component: DevicesComponent,
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
