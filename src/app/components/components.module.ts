import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SidebarComponent } from './sidebar/sidebar.component';
import { ServerComponent } from './server/server.component';

const moduleComponents: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  SidebarComponent,
  ServerComponent,
];

@NgModule({
  declarations: [],
  imports: [moduleComponents, CommonModule],
  exports: [moduleComponents],
})
export class ComponentsModule {}
