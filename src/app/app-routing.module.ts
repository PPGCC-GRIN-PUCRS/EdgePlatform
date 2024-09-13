import { RouterModule, Routes } from '@angular/router';
import { MapComponent } from './views/map/map.component';
import { CloudComponent } from './views/cloud/cloud.component';
import { FogComponent } from './views/fog/fog.component';
import { EdgeComponent } from './views/edge/edge.component';
import { DevicesComponent } from './views/devices/devices.component';
import { NgModule } from '@angular/core';

const routes: Routes = [
  // {
  //   path: '',
  //   component: MapComponent,
  // },
  {
    path: 'Map',
    component: MapComponent,
  },
  {
    path: 'Cloud',
    component: CloudComponent,
  },
  {
    path: 'Fog',
    component: FogComponent,
  },
  {
    path: 'Edge',
    component: EdgeComponent,
  },
  {
    path: 'Devices',
    component: DevicesComponent,
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
