# This is a silly litte rubot plugin to respond with an eightball answer.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in February 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

class Robut::Plugin::Eightball
	include Robut::Plugin

	RESPONSES = [
		"It is certain.",
		"It is decidedly so.",
		"Without a doubt.",
		"Yes, definitely.",
		"You may rely on it.",
		"As I see it, yes.",
		"Most likely.",
		"Outlook good.",
		"Signs point to yes.",
		"Yes.",
		"Reply hazy, try again.",
		"Ask again later.",
		"Better not tell you now.",
		"Cannot predict now.",
		"Concentrate and ask again.",
		"Don't count on it.",
		"My reply is no.",
		"My sources say no.",
		"Outlook not so good.",
		"Very doubtful."
	]

	def usage
		"?8ball <question> - answer your question"
	end

	def handle(time, sender_nick, message)
		if words(message).join(' ') =~ /^\?8ball\s/
			reply RESPONSES[rand(RESPONSES.length())]
		end
	end
end
