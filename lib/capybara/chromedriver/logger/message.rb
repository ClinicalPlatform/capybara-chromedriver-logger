require 'colorize'

module Capybara
  module Chromedriver
    module Logger
      class Message
        attr_reader :level, :message, :file, :location, :timestamp

        def initialize(log)
          @message = log.message.strip.gsub(/%c/, '')
          @level = log.level
          @file = nil
          @location = nil

          extract_file_and_location!
        end

        def to_s
          [
            "\u{1F4DC} ",
            log_level,
            file_and_location,
            message
          ].compact.join(' ')
        end

        def error?
          level == 'SEVERE'
        end

        private

        COLORS = {
          'SEVERE' => :light_red,
          'INFO' => :light_green,
          'DEBUG' => :light_blue
        }.freeze

        def level_color
          COLORS[level] || :light_blue
        end

        def log_level
          " #{level.downcase} ".colorize(color: :white, background: level_color).bold
        end

        def file_and_location
          return unless file && location

          "#{file} #{location}".colorize(color: :white, background: :light_magenta)
        end

        def extract_file_and_location!
          match = message.match(/^(.+)\s+?(\d+:\d+)\s+?(.+)$/)

          return unless match

          _, @file, @location, message = match.to_a
          @message = message.gsub(/^"(.+?)"$/, '\1')
        end
      end
    end
  end
end
