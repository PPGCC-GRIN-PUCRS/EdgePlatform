import { RouterModule, Routes } from '@angular/router';
import { MapComponent } from './views/map/map.component';
import { CloudComponent } from './views/cloud/cloud.component';
import { FogComponent } from './views/fog/fog.component';
import { EdgeComponent } from './views/edge/edge.component';
import { DevicesComponent } from './views/devices/devices.component';
import { NgModule } from '@angular/core';

const routes: Routes = [
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
