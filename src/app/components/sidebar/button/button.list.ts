export const buttonList = [
  {
    title: 'Map',
    icon: 'fa-map-marker-alt',
    action: map,
    disabled: false,
    selected: false,
  },
  {
    title: 'Cloud',
    icon: 'fa-globe',
    action: cloud,
    disabled: false,
    selected: false,
  },
  {
    title: 'Fog',
    icon: 'fa-water',
    action: fog,
    disabled: false,
    selected: false,
  },
  {
    title: 'Edge',
    icon: 'fa-server',
    action: edge,
    disabled: false,
    selected: false,
  },
  {
    title: 'Devices',
    icon: 'fa-tools',
    action: devices,
    disabled: false,
    selected: false,
  },
];

function map() {
  console.log('hellou');
}

function cloud() {
  console.log('hellou');
}

function fog() {}

function edge() {}

function devices() {}
