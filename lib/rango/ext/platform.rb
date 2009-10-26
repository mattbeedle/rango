# encoding: utf-8

module Rango
  class Platform
    class << self
      def match?(platform)
        !! RUBY_PLATFORM.match(/#{platform}/i)
      end

      def windows?
        self.match?("mswin|mingw")
      end

      def linux?
        self.match?("linux")
      end

      def osx?
        self.match?("-darwin")
      end

      def unix?
        self.linux? or self.osx?
      end
    end
  end
end