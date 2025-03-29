import { ServerDeployComponent } from './deploy/server.deploy.component';
import { ComponentsModule } from 'src/app/components/components.module';
import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatIcon, MatIconModule } from '@angular/material/icon';
import { MatStepperModule } from '@angular/material/stepper';
import { MatFormField, MatFormFieldModule } from '@angular/material/form-field';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { ServerDeployStepSBCConfig } from './deploy/steps/sbc-configuration/server.deploy.step.sbc.config';

const views: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  ServerDeployComponent, ServerDeployStepSBCConfig
];

@NgModule({
  declarations: [views],
  imports: [
    ReactiveFormsModule,
    ComponentsModule,
    CommonModule,

    MatFormFieldModule,
    MatStepperModule,
    MatButtonModule,
    MatInputModule,
    MatIconModule,
    MatFormField,
    FormsModule,
    MatIcon,
  ],
  exports: [views],
})
export class ServerModule {}
