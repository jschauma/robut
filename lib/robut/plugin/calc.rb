require 'calc'

# A simple calculator. This delegates all calculations to the 'calc'
# gem.
class Robut::Plugin::Calc
  include Robut::Plugin

  # Returns a description of how to use this plugin
  def usage
    "?calc <calculation> - replies with the result of <calculation>"
  end
  
  # Perform the calculation specified in +message+, and send the
  # result back.
  def handle(time, sender_nick, message)
    words = words(message)
    if words.first() == '?calc'
      words.shift()
      calculation = words.join(' ')
      # a-z    => functions, like sqrt
      # 0-9.   => numbers
      # ^+-%*/ => operators
      # ()     => grouping
      # <>=;     => allow declarations etc.
      if calculation =~ /^[a-zA-Z0-9;<>={}\.\*%\/\+\-\(\)\^ ]+$/
        if calculation == "sqrt(-1)"
          reply("i")
        else
          result = `echo '#{calculation}' | bc -l 2>&1`
          reply(result)
        end
      else
        reply("@#{sender_nick}: You're being naughty!")
      end
    end
  end

end
