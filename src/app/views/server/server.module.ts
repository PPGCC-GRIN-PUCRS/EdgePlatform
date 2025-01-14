import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ComponentsModule } from 'src/app/components/components.module';

const views: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [];

@NgModule({
  declarations: [views],
  imports: [CommonModule, ComponentsModule],
  exports: [views],
})
export class ServerModule {}
