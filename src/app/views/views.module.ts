import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ComponentsModule } from '../components/components.module';
import { TopologyModule } from './topology/topology.module';
import { HomeComponent } from './home/home.component';
import { ReactiveFormsModule } from '@angular/forms';
import { ServerModule } from './server/server.module';

const views: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  HomeComponent,
];

const modules: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  TopologyModule,
  ServerModule,
];

@NgModule({
  declarations: [views],
  imports: [CommonModule, ComponentsModule],
  exports: [views, modules],
})
export class ViewsModule {}
