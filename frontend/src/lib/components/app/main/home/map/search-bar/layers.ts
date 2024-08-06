import {
	PUBLIC_MAPTILER_OUTDOOR_URI,
	PUBLIC_MAPTILER_STREET_URI,
	PUBLIC_MAPTILER_SATELLITE_URI,
	PUBLIC_MAPTILER_LIGHT_URI,
	PUBLIC_MAPTILER_DARK_URI
} from '$env/static/public';

const layers = [
	{
		value: 'outdoor',
		label: 'Outdoor',
		URI: PUBLIC_MAPTILER_OUTDOOR_URI
	},
	{
		value: 'street',
		label: 'Street',
		URI: PUBLIC_MAPTILER_STREET_URI
	},
	{
		value: 'satellite',
		label: 'Satellite',
		URI: PUBLIC_MAPTILER_SATELLITE_URI
	},
	{
		value: 'light',
		label: 'Light',
		URI: PUBLIC_MAPTILER_LIGHT_URI
	},
	{
		value: 'dark',
		label: 'Dark',
		URI: PUBLIC_MAPTILER_DARK_URI
	}
];

export default layers;
