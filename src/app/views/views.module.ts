import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ServerNewComponent } from './server/new/server.new.component';
import { ComponentsModule } from '../components/components.module';
import { TopologyModule } from './topology/topology.module';
import { HomeComponent } from './home/home.component';
import { ReactiveFormsModule } from '@angular/forms';

const views: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  HomeComponent,
  ServerNewComponent,
];

const modules: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  TopologyModule,
];

@NgModule({
  declarations: [views],
  imports: [CommonModule, ComponentsModule, ReactiveFormsModule],
  exports: [views, modules],
})
export class ViewsModule {}
