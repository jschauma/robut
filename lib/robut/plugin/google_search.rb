require 'google-search'

# Responds with the first google search result matching a query.
class Robut::Plugin::GoogleSearch
  include Robut::Plugin

  # Returns a description of how to use this plugin
  def usage
    "?search <query> - responds with the first result from a Google search for <query>"
  end

  def handle(time, sender_nick, message)
    if words(message).join(' ') =~ /^\?search (.*)/
      search = Google::Search::Web.new(:query => $1)

      if search
        search.each() do |result|
          reply result.uri
          return
        end
      else
        reply "I'm sorry, I couldn't find anything."
      end
    end
  end
end
