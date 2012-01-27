# When asked for help, responds with a list of commands supported by
# all loaded plugins
class Robut::Plugin::Help
  include Robut::Plugin

  # Responds with a list of commands supported by all loaded plugins.
  def handle(time, sender_nick, message)
    words = words(message)
    if words.first == '?help'
      reply("Supported commands:")
      Robut::Plugin.plugins.each do |plugin|
        plugin_instance = plugin.new(reply_to, private_sender)
        Array(plugin_instance.usage).each do |command_usage|
          reply(command_usage)
        end
      end
    end
  end

  # Returns a description of how to use this plugin
  def usage
    "?help - displays this message"
  end
end
