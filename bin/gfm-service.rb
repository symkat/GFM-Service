#!/usr/bin/ruby

require 'GFMService'

h = Mongrel::HttpServer.new('0.0.0.0', 5000)
h.register('/', GFMService::MarkdownHandler.new)
h.run.join
