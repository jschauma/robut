# This is a silly litte rubot plugin to provide a way to throttle a given
# response.
#
# Wwritten by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

# XXX: This is a global throttle at the moment, not per channel, as it
# should be.
class Robut::Plugin::Throttle
	include Robut::Plugin

	def usage
		"?throttle <command> (num) - throttle the command for num seconds"
	end

	def print_throttle(throttle, now)
		limit = connection.config.throttles[throttle]["limit"]
		if limit != connection.config.default_throttle
			diff = connection.config.throttles[throttle]["time"] - now
		else
			diff = limit - (now - connection.config.throttles[throttle]["time"])
		end
		val = diff.to_s()
		if diff <= 0
			val = "unthrottled"
		end
		reply throttle + " => " + val
	end

	def handle(time, sender_nick, message)
		if words(message).join(' ') =~ /^\?throttle(\s+\S+)?(\s+\d+)?$/
			now = Time.now().to_i()
			value = $2

			if $1.nil?
				if connection.config.throttles.size() > 0
					connection.config.throttles.keys.each() do |cmd|
						print_throttle(cmd, now)
					end
				else
					reply "I'm completely unthrottled."
				end
				return
			end

			command = throttle = $1.strip()
			if command =~  /(bruce schneier|password|crypt|blowfish)/
				throttle = "schneier"
			end

			if value
				value = value.to_i()
				if value > 86400
					reply "Let's try to be reasonable, ok?"
				else
					if not connection.config.throttles.has_key?(throttle)
						connection.config.throttles[throttle] = {
							"time" => now + value,
							"limit" => value
						}
					else
						connection.config.throttles[throttle]["time"] = now + value
						connection.config.throttles[throttle]["limit"] = value
					end
					reply "New throttle for " + command + ": " + value.to_s()
				end
			else
				if connection.config.throttles.has_key?(throttle)
					print_throttle(throttle, now)
				else
					reply command + ": unknown throttle"
				end
			end
		end
	end
end
