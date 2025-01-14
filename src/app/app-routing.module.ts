import { DevicesComponent } from './views/topology/devices/devices.component';
import { CloudComponent } from './views/topology/cloud/cloud.component';
import { HomeComponent } from './views/home/home.component';
import { EdgeComponent } from './views/topology/edge/edge.component';
import { MapComponent } from './views/topology/map/map.component';
import { FogComponent } from './views/topology/fog/fog.component';
import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';
import { ServerNewComponent } from './views/server/new/server.new.component';

const routes: Routes = [
  {
    path: '',
    component: HomeComponent,
  },
  {
    path: 'server',
    children: [
      {
        path: 'new',
        component: ServerNewComponent,
      },
    ],
  },
  {
    path: 'topology',
    children: [
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
    ],
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
