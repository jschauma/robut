# This is a silly litte rubot plugin to get a given user's twitter
# message.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'json'
require 'uri'
require 'net/http'

class Robut::Plugin::Twitter
  include Robut::Plugin

  # Returns a description of how to use this plugin
  def usage
    "!twitter <user> (-N) - responds with user's last(-N) twitter message"
  end

  def handle(time, sender_nick, message)

    url = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name="

    if words(message).join(' ') =~ /^!twitter\s+(\S+)(\s+-(\d+))?$/
      twitterer = $1
      num = $3
      if not num
        num = 0
      else
        num = num.to_i()
        if num > 18
          reply "Sorry, I can only get the last 20 messages."
          return
        end
      end

      url += twitterer

      res = Net::HTTP.get_response(URI(url))
      if res.code != "200"
        reply res.message
      else
        messages = JSON.parse(res.body.strip())
        begin
          msg = messages[num]
          reply msg["text"]
          reply "http://twitter.com/" + twitterer + "  " + msg["created_at"]
        rescue
          reply "Uhoh, something went bump there. Sorry, y'all."
        end
      end
    end
  end
end
