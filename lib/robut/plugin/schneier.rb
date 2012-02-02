# This is a silly litte rubot plugin to get a Bruce Schneier qoute.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'uri'
require 'net/http'

# Responds with a little bit of trivia
class Robut::Plugin::Schneier
  include Robut::Plugin

  def handle(time, sender_nick, message)

    if words(message).join(' ') =~ /^\?/
      return
    end

    url = "http://www.schneierfacts.com/"

    input = words(message).join(' ')

    if input =~ /(bruce schneier|password|crypt|blowfish)/
      if is_throttled("schneier", nil)
        return
      end

      res = Net::HTTP.get_response(URI(url))
      if res.code != "200"
        reply res.message
      else
        res.body.each() do |line|
          if line =~ /.*<p class="fact">(.*)<\/p>/
            reply $1
            return
          end
        end
#        reply "I really would have liked to give you a fact about Bruce Schneier, but that didn't work out."
      end
    end
  end
end
