import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SidebarComponent } from './sidebar/sidebar.component';
import { ServerComponent } from './marker/server/server.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatDialogModule } from '@angular/material/dialog';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';

const moduleComponents: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  SidebarComponent,
  ServerComponent,
];

@NgModule({
  declarations: [],
  imports: [
    BrowserAnimationsModule,
    moduleComponents,
    CommonModule,
    BrowserModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatButtonModule,
    MatDialogModule,
  ],
  exports: [moduleComponents],
})
export class ComponentsModule {}
