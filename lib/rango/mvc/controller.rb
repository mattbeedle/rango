# coding=utf-8

Rango.import("templates/template")

class Rango
  class Controller
    include Rango::HttpExceptions
    include Rango::Helpers
    class << self
      attribute :before_filters, Hash.new
      attribute :after_filters,  Hash.new

      # before :login
      # before :login, :actions => [:send]
      def before(action, options = Hash.new)
        self.before_filters[action] = options
      end

      def after(action, options = Hash.new)
        self.after_filters[action] = options
      end

      def run(request, params, method, *args)
        controller = self.new
        controller.request = request
        controller.params  = params
        controller.run_filters(:before, method)
        value = controller.method(method).call(*args)
        controller.run_filters(:after, method)
        return value
      end

      def get_filters(type)
        self.send("#{type}_filters")
      end
    end

    # @since 0.0.1
    # @return [Rango::Request]
    # @see Rango::Request
    attr_accessor :request

    # @since 0.0.1
    # @return [Hash] Hash with params from request. For example <code>{:messages => {:success => "You're logged in"}, :post => {:id => 2}}</code>
    attr_accessor :params

    # @since 0.0.1
    # @return [Rango::Logger] Logger for logging project related stuff.
    # @see Rango::Logger
    attribute :logger, Project.logger

    # TODO: default option for template
    def render(template)
      Rango::Templates::Template.new(template, self).render
    end

    # TODO: default option for template
    def display(object, template)
      render(template)
    rescue Error406
      # TODO: provides API
      format = Project.settings.mime_formats.find do |format|
        object.respond_to?("to_#{format}")
      end
      format ? object.send("to_#{format}") : raise(Error406.new(self.params))
    end

    # TODO
    def messages
      self.params[:messages]
    end

    # TODO
    def redirect(url)
    end

    # TODO
    def cookies
    end

    # TODO
    def session
    end

    def run_filters(name, method)
      Rango.logger.debug(self.class.instance_variables)
      self.class.get_filters(name).each do |filter_method, options|
        begin
          unless options[:except] && options[:except].include?(method)
            if self.respond_to?(filter_method)
              Rango.logger.debug("Calling filter #{filter_method} for controller #{self}")
              self.send(filter_method)
            else
              Rango.logger.error("Filter #{filter_method} doesn't exists!")
            end
          end
        rescue SkipFilter
          Rango.logger.debug("Skipping #{name} filter")
          next
        end
      end
    end
  end
end