import { Component, Inject, inject } from '@angular/core';
import {
  MAT_DIALOG_DATA,
  MatDialog,
  MatDialogModule,
} from '@angular/material/dialog';

// import {MAT_DIALOG_DATA} from '@angular/material';

export interface DialogData {
  animal: 'panda' | 'unicorn' | 'lion';
}

@Component({
  standalone: true,
  imports: [MatDialogModule],
  selector: 'configuration-component',
  templateUrl: './configuration.component.html',
  styleUrl: './configuration.component.scss',
})
export class ConfigurationComponent {
  constructor(private dialog: MatDialog) {}

  openDialog() {
    this.dialog.open(DialogDataExampleDialog, {
      data: {
        animal: 'panda',
      },
    });
  }
}

@Component({
  standalone: true,
  imports: [MatDialogModule],
  selector: 'dialog-data-example-dialog',
  templateUrl: 'configuration.modal.component.html',
})
export class DialogDataExampleDialog {
  constructor(@Inject(MAT_DIALOG_DATA) public data: DialogData) {}
}
