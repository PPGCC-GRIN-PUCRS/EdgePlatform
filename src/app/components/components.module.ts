import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SidebarComponent } from './sidebar/sidebar.component';
import { ServerComponent } from './server/server.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatDialogModule } from '@angular/material/dialog';

const moduleComponents: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  SidebarComponent,
  ServerComponent,
];

@NgModule({
  declarations: [],
  imports: [BrowserAnimationsModule, moduleComponents, CommonModule],
  exports: [moduleComponents],
})
export class ComponentsModule {}
