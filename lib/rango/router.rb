# encoding: utf-8

require "rango" # for helpers

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      raise "Your router or your router adapter doesn't support this method"
    end
  end

  Helpers.send(:include, UrlHelper)

  class Router
    @@routers ||= Hash.new

    def self.router
      @@router
    rescue
      raise "You have to run Rango::Router.use(router_name) first!"
    end

    def self.router=(router)
      @@router = router
    end

    def self.implement(router, &block)
      @@routers[router] = block
    end

    def self.use(router)
      require_relative "router/adapters/#{router}"
      Rango.logger.debug("Using router #{router}")
      @@router = router
    end

    def self.set_rack_env(env)
      unless env["rango.router.params"]
        @@routers[self.router].call(env)
      end
    end
  end
end
