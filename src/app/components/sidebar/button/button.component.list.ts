import { Router } from '@angular/router';


export const buttonList: any[] = [
  {
    title: 'Map',
    icon: 'fa-map-marker-alt',
    action: (router: Router) => {
      router.navigate([`topology/map`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Cloud',
    icon: 'fa-globe',
    action: (router: Router) => {
      router.navigate([`topology/cloud`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Fog',
    icon: 'fa-water',
    action: (router: Router) => {
      router.navigate([`topology/fog`]);
    },
    disabled: false,
    selected: false,
  },
  {
    title: 'Edge',
    icon: 'fa-server',
    action: (router: Router) => {
      router.navigate([`topology/edge`]);
    },
    disabled: true,
    selected: false,
  },
  {
    title: 'Devices',
    icon: 'fa-tools',
    action: (router: Router) => {
      router.navigate([`topology/devices`]);
    },
    disabled: true,
    selected: false,
  },
];
