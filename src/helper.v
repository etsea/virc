module helper

import rand

pub fn random_nickname() string {
	base_names := [
		'byte', 'pixel', 'logic', 'cache',
		'code', 'binary', 'kernel', 'matrix',
		'query', 'port', 'chip', 'circuit',
		'proxy', 'stack', 'node', 'terminal'
	]
	index := rand.intn(base_names.len) or { 0 }
	base_name := base_names[index]

	number_suffix := rand.u16().str()

	return '${base_name}_${number_suffix}'
}
