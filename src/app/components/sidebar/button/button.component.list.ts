import { Router } from '@angular/router';

export const buttonList: any[] = [
  {
    title: 'Map',
    icon: 'fa-map-marker-alt',
    action: (router: Router) => {
      router.navigate([`map`]);
    },
    disabled: false,
    selected: true,
  },
  {
    title: 'Cloud',
    icon: 'fa-globe',
    action: (router: Router) => {
      router.navigate([`cloud`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Fog',
    icon: 'fa-water',
    action: (router: Router) => {
      router.navigate([`fog`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Edge',
    icon: 'fa-server',
    action: (router: Router) => {
      router.navigate([`edge`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Devices',
    icon: 'fa-tools',
    action: (router: Router) => {
      router.navigate([`devices`]);
    },
    disabled: false,
    selected: false,
  },
];
