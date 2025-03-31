import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ServerDeployStepSBCBurner } from './server.deploy.step.sbc.burner';

describe('ServerDeployStepSBCBurner', () => {
  let component: ServerDeployStepSBCBurner;
  let fixture: ComponentFixture<ServerDeployStepSBCBurner>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ServerDeployStepSBCBurner]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ServerDeployStepSBCBurner);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
