import { ServerDeployStepSBCConfig } from './deploy/steps/configuration/server.deploy.step.sbc.config';
import { ServerDeployStepSBCBurner } from './deploy/steps/burner/server.deploy.step.sbc.burner';
import { MatFormField, MatFormFieldModule } from '@angular/material/form-field';
import { ServerDeployComponent } from './deploy/server.deploy.component';
import { ComponentsModule } from 'src/app/components/components.module';
import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatIcon, MatIconModule } from '@angular/material/icon';
import { MatStepperModule } from '@angular/material/stepper';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { CommonModule } from '@angular/common';
import { BrowserModule } from '@angular/platform-browser';

const views: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  ServerDeployComponent, ServerDeployStepSBCConfig, ServerDeployStepSBCBurner
];

@NgModule({
  declarations: [views],
  imports: [
    ReactiveFormsModule,
    ComponentsModule,
    BrowserModule,
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
