# encoding: utf-8

require "rubyexts/attribute"

module Rango
  module Settings
    ConfigurationError = Class.new(StandardError)

    class Settings
      def initialize(params = Hash.new)
        params.each do |key, value|
          self.send("#{key}=", value)
        end
      end

      # @since 0.0.1
      # @example
      #   Project.settings.merge(MyPlugin.settings)
      # @param [Rango::Settings] another Settings which will be merged into self. It doesn't change self.
      # @return [Hash] Hash of settings attributes.
      # TODO: maybe it should returns Rango::Settings?
      def merge(another)
        self.hattributes.merge(another.hattributes)
      end

      # @since 0.0.1
      # @example
      #   Project.settings.merge!(MyPlugin.settings)
      # @param [Rango::Settings] another Settings which will be merged into self. It change self.
      # @return [Hash] Hash of settings attributes.
      # TODO: maybe it should returns Rango::Settings?
      def merge!(another)
        self.hattributes.merge!(another.hattributes)
      end

      # @since 0.0.1
      # @example
      # @return [String] All settings attributes in inspect format.
      def inspect
        self.hattributes.inspect
      end

      # @since 0.0.1
      def to_hash
        self.hattributes.reject { |key, value| value.nil? }
      end

      # @since 0.0.2
      def settings_module(name)
        if self.hattributes[name]
          return self.hattributes[name]
        else
          require "rango/settings/#{name}"
          const_name = name.to_s.camel_case
          constant = Rango::Settings.const_get(const_name)
          instance = constant.new
          self.hattributes[name] = instance
        end
      end

      # @since 0.0.1
      # @example
      #   Project.configure do
      #     self.foobar = "something"
      #   end
      #   # => Logger will warn you that property foobar doesn't exist.
      # @param [type] name explanation
      def method_missing(name, *args, &block)
        if name.to_s.match(/^([\w\d]+)=$/) && args.length.eql?(1)# && not block_given?
          raise ConfigurationError, "Unknown #{self.class} item: #$1"
        else
          super(name, *args, &block)
        end
      end
    end

    class Anonymous < Settings
      # @since 0.0.2
      # @example
      #   Project.configure do
      #     self.foobar = "something"
      #   end
      #   # => Set the property without warning
      # @param [type] name explanation
      def method_missing(name, *args, &block)
        if name.to_s.match(/^([\w\d]+)=$/) && args.length.eql?(1)# && not block_given?
          self.class.hattribute $1.to_sym
          self.send(name, *args, &block)
        else
          super(name, *args, &block)
        end
      end
    end
  end
end

require "rango/settings/framework"
