#!/usr/bin/python

import SimpleHTTPServer
import SocketServer

PORT = 5103

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()
