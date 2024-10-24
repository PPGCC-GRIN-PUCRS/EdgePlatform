import { Component, Inject, NgModule } from '@angular/core';
import {
  MAT_DIALOG_DATA,
  MatDialog,
  MatDialogModule,
} from '@angular/material/dialog';
import { MatIcon } from '@angular/material/icon';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';

export interface DialogData {
  animal: 'panda' | 'unicorn' | 'lion';
}

@Component({
  standalone: true,
  imports: [MatDialogModule, MatIcon],
  selector: 'conf-sidebar-button',
  template: `
    <button
      class="extra-button gear-button"
      mat-icon-button
      (click)="openDialog()"
    >
      <mat-icon>settings</mat-icon>
    </button>
  `,
  styleUrl: '../extra.button.component.scss',
})
export class ConfigurationComponent {
  constructor(private dialog: MatDialog) {}

  openDialog() {
    this.dialog.open(DialogDataExampleDialog, {
      data: {
        panda: 'true',
      },
    });
  }
}

@Component({
  standalone: true,
  imports: [
    FormsModule,
    MatDialogModule,
    MatFormFieldModule,
    MatSelectModule,
    MatInputModule,
    MatDialogModule,
    MatButtonModule,
  ],
  selector: 'dialog-data-example-dialog',
  templateUrl: 'configuration.modal.component.html',
})
export class DialogDataExampleDialog {
  constructor(@Inject(MAT_DIALOG_DATA) public data: DialogData) {}

  settings = {
    setting1: '',
    setting2: 'option1',
  };

  onClose() {
    console.log('close');
  }

  onSave() {
    console.log('save');
  }
}
