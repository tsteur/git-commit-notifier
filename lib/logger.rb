require 'tmpdir'

class Logger
  DEFAULT_LOG_DIRECTORY = Dir.tmpdir.freeze
  LOG_NAME = 'git-commit-notifier.log'.freeze

  attr_reader :log_directory

  def initialize(config)
    @enabled = !!(config['debug'] && config['debug']['enabled'])
    @log_directory = debug? ? (config['debug']['log_directory'] || DEFAULT_LOG_DIRECTORY) : nil
  end

  def debug?
    @enabled
  end

  def log_path
    return nil unless debug?
    File.join(log_directory, LOG_NAME)
  end

end

__END__

 vim: tabstop=2 expandtab shiftwidth=2

