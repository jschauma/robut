# This is a silly litte rubot plugin to insult other people.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'uri'
require 'net/http'

# Responds with an insult.
class Robut::Plugin::Insult
  include Robut::Plugin


  # Returns a description of how to use this plugin
  def usage
    "?insult <somebody> - generate an insult"
  end

  def handle(time, sender_nick, message)

    url = "http://www.randominsults.net/"

    input = words(message).join(' ')

    if input =~ /^\?insult (.*)$/
      loser = $1
      if loser =~ /#{at_nick}/
        loser = sender_nick
      end
      res = Net::HTTP.get_response(URI(url))
      if res.code != "200"
        reply res.message
      else
        res.body.each() do |line|
          if line =~ /.*<font face="Verdana" size="4"><strong><i>(.*)<\/i>/
            reply "@" + loser + ": " + $1
            return
          end
        end
        reply "I'm sorry, I was unable to come up with an insult for " + loser + "."
      end
    end
  end
end
