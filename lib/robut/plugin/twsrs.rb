# This is a silly litte rubot plugin to respond to "that's what she said".
# Based on / derived from:
# http://geekfeminism.org/2012/03/19/what-she-really-said-fighting-sexist-jokes-the-geeky-way/
# @jessamynsmith
#
# Written by Jan Schaumann <jschauma@netmeister.org> in March 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'uri'
require 'net/http'
require 'net/https'

class Robut::Plugin::Twsrs
  include Robut::Plugin

  def handle(time, sender_nick, message)

    if words(message).join(' ') =~ /^\?/
      return
    end

    url = "https://raw.github.com/jessamynsmith/talkbackbot/master/quotes.txt"

    input = words(message).join(' ')

    if input =~ /^(that's what )she said$/i
      if is_throttled("tnwss", nil)
        return
      end

      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      res = http.request(request)
      if res.code != "200"
        reply res.message
      else
        tnwss =res.body.collect()
        reply "No, actually, *this* is what she really said:"
        reply tnwss[rand(tnwss.length())].strip()
      end
    end
  end
end
