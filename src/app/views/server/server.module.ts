import { ServerDeployComponent } from './deploy/server.deploy.component';
import { ComponentsModule } from 'src/app/components/components.module';
import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { MatIcon, MatIconModule } from '@angular/material/icon';

const views: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  ServerDeployComponent,
];

@NgModule({
  declarations: [views],
  imports: [
    ReactiveFormsModule,
    ComponentsModule,
    CommonModule,

    MatIconModule,
    MatIcon,
  ],
  exports: [views],
})
export class ServerModule {}
