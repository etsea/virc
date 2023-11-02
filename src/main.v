module main

import irc
import helper

import os
import cli

fn main() {
	mut app := cli.Command{
		name: 'virc'
		description: 'A simple IRC client written in V'
		version: '0.0.1'
		disable_man: true
	}
	mut start := cli.Command{
		name: 'start'
		description: 'Start an IRC connection'
		execute: irc_connect
	}
	mut nick := cli.Flag{
		flag: .string
		name: 'nick'
		abbrev: 'n'
		description: 'Set an IRC nickname.'
		default_value: [helper.random_nickname()]
		global: true
	}
	mut host := cli.Flag{
		flag: .string
		name: 'host'
		abbrev: 'h'
		description: 'Set an IRC server'
		default_value: ['irc.libera.chat']
		global: true
	}
	mut port := cli.Flag{
		flag: .string
		name: 'port'
		abbrev: 'p'
		description: 'Set an IRC port number'
		default_value: ['6667']
		global: true
	}
	mut password := cli.Flag{
		flag: .string
		name: 'password'
		abbrev: 'pass'
		description: 'Set an IRC password'
		default_value: ['']
		global: true
	}

	app.add_command(start)
	app.add_flags([nick, host, port, password])
	app.setup()
	app.parse(os.args)
}

fn irc_connect(cmd cli.Command) ! {
	host := cmd.flags.get_string('host')!
	port := cmd.flags.get_string('port')!
	nick := cmd.flags.get_string('nick')!
	password := cmd.flags.get_string('password')!


	mut instance := irc.Interface{}
	instance.init(host, port, password, nick) or {
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
