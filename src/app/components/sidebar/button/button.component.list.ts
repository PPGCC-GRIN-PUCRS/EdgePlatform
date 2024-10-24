import { Router } from '@angular/router';

export const buttonList: any[] = [
  {
    title: 'Map',
    icon: 'fa-map-marker-alt',
    action: (router: Router) => {
      router.navigate([`Map`]);
    },
    disabled: false,
    selected: true,
  },
  {
    title: 'Cloud',
    icon: 'fa-globe',
    action: (router: Router) => {
      router.navigate([`Cloud`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Fog',
    icon: 'fa-water',
    action: (router: Router) => {
      router.navigate([`Fog`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Edge',
    icon: 'fa-server',
    action: (router: Router) => {
      router.navigate([`Edge`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Devices',
    icon: 'fa-tools',
    action: (router: Router) => {
      router.navigate([`Devices`]);
    },
    disabled: false,
    selected: false,
  },
];
