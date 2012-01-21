require 'google-search'

# Responds with the first google image search result matching a query.
class Robut::Plugin::GoogleImages
  include Robut::Plugin

  # Returns a description of how to use this plugin
  def usage
    "!image <query> - responds with a random image from a Google Images search for <query>"
  end

  def handle(time, sender_nick, message)
    query = ""
    cmd = false
    if words(message).join(' ') =~ /^!image (.*)/
      query = $1
      cmd = true
    end

    if words(message).join(' ') =~ /(facepalm|zombie)/
      query = $1
    end

    if query != ""
      images = Google::Search::Image.new(:query => query)

      n = 0
      if images
        images.each() do |image|
          if n == rand(10) || n == 10
            reply image.uri
            return
          end
          n += 1
        end
      elsif cmd
        reply "I'm sorry, I couldn't find a suitable image."
      end
    end
  end
end
