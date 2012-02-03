# This is a silly litte rubot plugin to get the first paragraph from a
# Wikipedia entry.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in February 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'htmlentities'
require 'uri'
require 'open-uri'

class Robut::Plugin::Wikipedia
	include Robut::Plugin

	def usage
		"?wiki <something> - look up something on wikipedia"
	end

	def handle(time, sender_nick, message)

		url = "http://en.wikipedia.org/wiki/"

		input = words(message).join(' ')

		if input =~ /^\?wiki (.*)/
			url = url + URI.escape($1)
			begin
				res = open(url, "User-Agent" => "jbot")
			rescue
				reply "Couldn't get a definition from " + url
				return
			end
			found = item = thisline = false
			res.each() do |line|
				if line =~ /<\/table>/
					found = true
					next
				end

				if found
					if line =~ /<div class="dablink">/
						txt = url + "_%28disambiguation%29"
						reply txt
						return
					end

					if line =~ /may refer to:/
						item = true
						next
					end

					if (item and line =~ /^<li>(.*)/) or (not item and line =~ /^<p>(.*)/)
						thisline = true
						if line =~ /^<p><br \/>/
							next
						end
					end

					if thisline
						txt = HTMLEntities.new.decode(line).gsub(/<\/?[^>]*>/, "")
						if txt.length() < 140
							reply txt
						else
							reply txt[0,140] + "..."
						end
						reply url
						return
					end
				end
			end
		end
	end
end
