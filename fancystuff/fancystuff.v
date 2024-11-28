module fancystuff

import time

interface Any {}

pub struct Map {
pub mut:
	map_string_string map[string]string = {}
}

pub fn timestamp_milliseconds_to_date(timestamp i64) string {
	// Example millisecond timestamp
	millis := i64(timestamp) // Milliseconds since epoch

	// Convert milliseconds to seconds
	seconds := millis / 1000

	// Create a Time object from seconds since epoch
	// Come on.. this crazy hard for just convert a standard timestamp
	date := time.unix(seconds)

	// Format the time to a human-readable string
	formatted_date := date.format_ss()

	return formatted_date
}

fn init() {
	// now_seconds := time.now().unix()
	// now_millis := time.now().unix_milli()
	//
	// println('Human-readable date: ${timestamp_milliseconds_to_date(now_millis)}')
	// m := Map{
	// 	map_string_string: {
	// 		'one':   'One   (string_key) in a map[string]string'
	// 		'two':   'Two   (string_key) in a map[string]string'
	// 		'three': 'Three (string_key) in a map[string]string'
	// 	}
	// }
	// m.short_by_key_ascending()
	// // exit(0)
}

pub fn sort_map_string_string(m map[string]string) !map[string]string {
	mut keys := m.keys()
	keys.sort_ignore_case() // println('\nARRAY_KEYS: ${keys}\n')
	mut m_sorted := map[string]string{} // println('\nSORTED_ARRAY_KEYS: ${keys}\n')
	for key in keys {
		value := m[key] // println('key:${key}: value:${value}')
		m_sorted[key] = value
	}
	return m.clone() // println('MAP_PARAMS_SORTED: ${map_params_sorted}')
}

pub fn (ms Map) short_by_key_ascending() {
	print(ms)
}
