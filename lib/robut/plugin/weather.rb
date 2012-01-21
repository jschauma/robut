require 'open-uri'
require 'nokogiri'

# What's the current weather forecast?
class Robut::Plugin::Weather
  include Robut::Plugin

  class << self
    attr_accessor :default_location
  end

  # Returns a description of how to use this plugin
  def usage
    [
      "!weather - returns the weather in the default location for today",
      "!weather tomorrow - returns the weather in the default location for tomorrow",
      "!weather <location> - returns the weather for <location> today",
      "!weather <location> Tuesday - returns the weather for <location> Tuesday"
    ]
  end
  
  def handle(time, sender_nick, message)

    words = words(message)

    return if words.shift() != '!weather'

    if words.length() > 0
      day_of_week = nil
      day_string = words.last().downcase
      day_of_week = parse_day(day_string)
      if day_of_week
        words.pop()
      end
    end

    if words.length() > 0
      location = words.join(" ")
    else
      location = "10010"
    end

    if location.nil?
      reply "I don't have a default location!"
      return
    end

    if bad_location?(location)
      reply "I don't recognize the location: \"#{location}\""
      return
    end

    if day_of_week
      reply forecast(location, day_of_week)
    else
      reply current_conditions(location)
    end
  end

  def parse_day(day)
    day_map = {
      "monday"    =>  "Mon",
      "mon"       =>  "Mon",
      "tuesday"   =>  "Tue",
      "tue"       =>  "Tue",
      "tues"      =>  "Tue",
      "wed"       =>  "Wed",
      "wednesday" =>  "Wed",
      "thurs"     =>  "Thu",
      "thu"       =>  "Thu",
      "thursday"  =>  "Thu",
      "friday"    =>  "Fri",
      "fri"       =>  "Fri",
      "saturday"  =>  "Sat",
      "sat"       =>  "Sat",
      "sunday"    =>  "Sun",
      "sun"       =>  "Sun",
    }
    if day_map.has_key?(day)
      return day_map[day]
    end

    if day == "tomorrow"
      return (Time.now + 60*60*24).strftime("%a")
    end

    if day == "today"
      return Time.now.strftime("%a")
    end
  end

  def current_conditions(location)
    doc = weather_data(location)
    condition = doc.search("current_conditions condition").first["data"]
    temperature = doc.search("current_conditions temp_f").first["data"]
    normalized_location = doc.search("forecast_information city").first["data"]
    "Weather for #{normalized_location}: #{condition}, #{temperature}F"
  end

  def forecast(location, day_of_week)
    doc = weather_data(location)
    forecast = doc.search("forecast_conditions").detect{|el| c = el.children.detect{|c| c.name == "day_of_week"}; c && c["data"] == day_of_week}
    return "Can't find a forecast for #{day_of_week}" if forecast.nil?

    condition = forecast.children.detect{|c| c.name == "condition"}["data"]
    high = forecast.children.detect{|c| c.name == "high"}["data"]
    low = forecast.children.detect{|c| c.name == "low"}["data"]
    normalized_location = doc.search("forecast_information city").first["data"]
    "Forecast for #{normalized_location} on #{day_of_week}: #{condition}, High: #{high}F, Low: #{low}F"
  end

  def weather_data(location = "")
    @weather_data ||= {}
    @weather_data[location] ||= begin
      url = "http://www.google.com/ig/api?weather=#{URI.escape(location)}"
      Nokogiri::XML(open(url))
    end
    @weather_data[location]
  end

  def bad_location?(location = "")
    weather_data(location).search("forecast_information").empty?
  end

end
