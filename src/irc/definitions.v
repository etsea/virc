module irc

import net

pub struct Server {
pub:
	address string
	port string
}

pub struct Interface {
pub mut:
	conn net.TcpConn
	nick string
	pass string
	host Server
}
