module helper

import rand

pub fn random_nickname() string {
	base_names := [
		'byte', 'pixel', 'logic', 'cache',
		'code', 'binary', 'kernel', 'matrix',
		'query', 'port', 'chip', 'circuit',
		'proxy', 'stack', 'node', 'terminal'
	]
	first_index := rand.intn(base_names.len) or { 0 }
	second_index := rand.intn(base_names.len) or { 1 }
	name := '${base_names[first_index]}${base_names[second_index]}'
	suffix := rand.u8().str()

	return '${name}_${suffix}'
}
