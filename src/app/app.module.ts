import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { ComponentsModule } from './components/components.module';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { NgModule } from '@angular/core';
import { ViewsModule } from './views/views.module';
import { RouterModule } from '@angular/router';
import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations: [AppComponent],
  bootstrap: [AppComponent],
  imports: [
    RouterModule,
    ComponentsModule,
    ViewsModule,
    BrowserModule,
    AppRoutingModule,
  ],
  providers: [provideAnimationsAsync()],
})
export class AppModule {}
