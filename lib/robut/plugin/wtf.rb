# This is a silly litte rubot plugin to perform a wtf(1) lookup.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in February 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

class Robut::Plugin::Wtf
	include Robut::Plugin

	def usage
		"?wtf <acronym> - translates acronyms for you"
	end

	def handle(time, sender_nick, message)
		if words(message).join(' ') =~ /^\?wtf\s+([a-z0-9\/]+)/i
			word = $1
			result = `wtf '#{word}' 2>&1`
			reply result
		end
	end
end
