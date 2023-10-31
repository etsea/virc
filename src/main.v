module main

import irc
import helper

fn main() {
	mut host := 'irc.libera.chat'
	mut port := '6667'
	mut nickname := ''
	mut password := ''

	if nickname == '' { nickname = helper.random_nickname() }

	mut instance := irc.Interface{}
	instance.init(host, port, password, nickname) or {
		eprintln('Error initializing server connection: ${err}')
	}

	instance.identify() or {
		eprintln('Error sending user identity: ${err}')
	}

	instance.set_timeouts(5, 5)

	for {
		line := instance.read_line()

		if line.len == 0 {
			break
		}

		print(line)
	}

	instance.conn.close() or { panic(err) }
}
