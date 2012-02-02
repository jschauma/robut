# This is a silly litte rubot plugin to get a twitter user's klout score.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'uri'
require 'net/http'

class Robut::Plugin::Klout
  include Robut::Plugin


  # Returns a description of how to use this plugin
  def usage
    "?klout <user> - retrieve user's klout score and 'areas of expertise'"
  end

  def handle(time, sender_nick, message)

    url = "http://klout.com/"

    input = words(message).join(' ')

    if input =~ /^\?klout (\S+)$/
      user = $1
      url += user
      res = Net::HTTP.get_response(URI(url))
      if res.code != "200"
        reply url + ": " + res.message
      else
        score = "unknown"
        topics = []
        res.body.each() do |line|
          if score == "unknown" and line =~ /.*<span class="value">(.*)<\/span>/
            score = $1
          end
          if line =~ /.*<a class="topic-link".*>(.*)<\/a>/
            topics.push($1)
          end
        end
        if score == "unknown"
          reply user + " has no klout."
        else
          infl = " nothing at all."
          if topics.length() > 0
            infl = ": " + topics.join(', ')
          end
          reply user + " has a klout score of " + score + " and is influential about" + infl
        end
      end
    end
  end
end
