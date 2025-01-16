import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ServerDeployComponent } from './server.deploy.component';

describe('ServerComponent', () => {
  let component: ServerDeployComponent;
  let fixture: ComponentFixture<ServerDeployComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ServerDeployComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(ServerDeployComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
