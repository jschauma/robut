# This is a silly litte rubot plugin to get some trivia.
#
# Wwritten by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'uri'
require 'net/http'

# Responds with a little bit of trivia
class Robut::Plugin::Trivia
  include Robut::Plugin


  # Returns a description of how to use this plugin
  def usage
    "?trivia - responds with a little bit of trivia"
  end

  def handle(time, sender_nick, message)

    cmd = false
    url = "http://www.nicefacts.com/quickfacts/index.php"

    input = words(message).join(' ')

    if input =~ /^\?trivia\s*$/
      cmd = true
    end

    if input =~ /(trivia|fact)/ or cmd
      if is_throttled("trivia", nil)
        return
      end

      res = Net::HTTP.get_response(URI(url))
      if res.code != "200"
        reply res.message
      else
        res.body.each() do |line|
          if line =~ /<div class='factText'>(.*)<\/div>/
            reply $1
            return
          end
        end
        if cmd
          reply "I'm sorry, I was unable to get you a snippet of trivia. Sorry!"
        end
      end
    end
  end
end
