# encoding: utf-8

module Kernel
  # @since 0.0.2
  def metaclass
    class << self
      self
    end
  end

  # @since 0.0.1
  # @example
  #   try_require_gem "term/ansicolor", "term-ansicolor"
  # @param [String] library Library to require.
  # @param [String, @optional] gemname Name of gem which contains required library. Will be used for displaying message.
  # @return [Boolean] True if require was successful, false otherwise.
  def try_require_gem(library, gemname = library)
    begin
      require library
    rescue LoadError
      message = "Gem #{gemname} isn't installed. Run sudo gem install #{gemname}."
      if defined?(Rango.logger)
        Rango.logger.warn(message)
        return false
      else
        puts(message)
        return false
      end
    end
  end

  # @since 0.0.3
  def try_require(library)
    require "library"
  rescue
    return false
  end

  # @since 0.0.3
  def acquire(glob)
    Dir[glob].all? { |file| require(file) }
  end

  def command(command)
    puts command
    puts %x[#{command}]
  end
  alias_method :sh, :command

  def quiet(&block)
    old_stdout = STDOUT.dup
    STDOUT.reopen("/dev/null")
    returned = block.call
    STDOUT.reopen(old_stdout)
    return returned
  end

  def quiet!(&block)
    old_stderr = STDERR.dup
    STDERR.reopen("/dev/null", "a")
    returned = quiet(&block)
    STDERR.reopen(old_stderr)
    return returned
  end

  # for quick inspection
  # @since 0.0.2
  def puts_and_return(*args)
    puts(*args)
    return *args
  end

  # @since 0.0.2
  def p_and_return(*args)
    p(*args)
    return *args
  end
end
