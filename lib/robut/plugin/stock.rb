# This is a silly litte rubot plugin to get a stock quote and chart.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'uri'
require 'net/http'

# Responds with the latest quote for the given symbol (if any)
class Robut::Plugin::Stock
  include Robut::Plugin


  # Returns a description of how to use this plugin
  def usage
    "?stock <symbol> - responds with the last quote <symbol> is trading at"
  end

  def handle(time, sender_nick, message)

    # See also: http://www.gummy-stuff.org/Yahoo-data.htm
    url = "http://download.finance.yahoo.com/d/quotes.csv?f=l1&s="
    chart = "http://chart.finance.yahoo.com/z?t=1d&s="

    if words(message).join(' ') =~ /^\?stock (\S+)$/
      sym = $1.upcase()
      url += sym
      chart += sym + "&ign=.gif"

      res = Net::HTTP.get_response(URI(url))
      if res.code != "200"
        reply res.message
      else
        num = res.body.strip()
        if num == "0.00"
          reply "That does not look like a valid stock symbol to me."
        else
          response = sym + " last traded at: $" + res.body.strip() + "  " + chart
          reply response
        end
      end
    end
  end
end
