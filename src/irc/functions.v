module irc

import net
import time

fn (server Server) connect() !&net.TcpConn {
	addresses := net.resolve_addrs_fuzzy(server.address, .tcp) or {
		return error('Failed to resolve address: ${server.address}')
	}

	for address in addresses {
		full_address := '${address}:${server.port}'
		conn := net.dial_tcp(full_address) or {
			continue
		}
		return conn
	}

	return error('Failed to connect to any address: ${server.address}:${server.port}')
}

pub fn (mut instance Interface) init(host string, port string, password string, nickname string) ! {
	server := Server{
		address: host
		port: port
	}

	instance.conn = server.connect() or { return err }

	instance.nick = nickname
	instance.pass = password
	instance.host = &server
}

pub fn (mut instance Interface) identify() ! {
	instance.send_message('NICK ${instance.nick}\r\n')!
	instance.send_message('USER ${instance.nick} localhost ${instance.host.address} :${instance.nick}\r\n')!
}

pub fn (mut instance Interface) set_timeouts(read_timeout int, write_timeout int) {
	instance.conn.set_read_timeout(read_timeout * time.second)
	instance.conn.set_write_timeout(write_timeout * time.second)
}

pub fn (mut instance Interface) send_message(message string) ! {
	instance.conn.write_string(message) or {
		return err
	}
}

pub fn (mut instance Interface) read_line() string {
	return instance.conn.read_line()
}
