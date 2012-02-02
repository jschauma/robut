# This is a silly litte rubot plugin to get a Shakespearean insult.
#
# Written by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

require 'uri'
require 'net/http'

# Responds with a little bit of trivia
class Robut::Plugin::Shakespear
  include Robut::Plugin

  def handle(time, sender_nick, message)

    url = "http://www.pangloss.com/seidel/Shaker/index.html"

    input = words(message).join(' ')

    if input =~ /(shakespear|hamlet|Coriolanus|macbeth|romeo and juliet|merchant of venice|midsummer nicht's dream|henry V|as you like it|All's Well That Ends Well|Comedy of Errors|Cymbeline|Love's Labours Lost|Measure for Measure|Merry Wives of Windsor|Much Ado About Nothing|Pericles|Prince of Tyre|Taming of the Shrew|Tempest|Troilus|Cressida|Twelfth Night|two gentleman of verona|Winter's tale|henry IV|king john|richard II|antony and cleopatra|coriolanus|julius caesar|kind lear|othello|timon of athens|titus|andronicus)/i
      if is_throttled("shakespear", nil)
        return
      end

      res = Net::HTTP.get_response(URI(url))
      if res.code != "200"
        reply res.message
      else
        res.body.each() do |line|
          if line =~ /(.*)<\/font>/
            reply $1
            return
          end
        end
      end
    end
  end
end
