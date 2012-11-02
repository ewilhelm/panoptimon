# adapted from http://pastebin.com/C4hvAyKM
# and https://gist.github.com/1333428

# feed stderr into connection's receive_stderr()

module EventMachine
  class StderrHandler < EventMachine::Connection
    def initialize(connection); @connection = connection; end
    def receive_data(data); @connection.receive_stderr(data); end
    def unbind; detach; end
  end

  def self.popen3b(cmd, handler=nil, *args)
    klass = klass_from_handler(Connection, handler, *args)
    raise "no command?" unless cmd.first
    cmd.unshift(cmd.first) # -> execvp

    original_stderr = $stderr.dup

    begin
      rd, wr     = IO.pipe

      $stderr.reopen wr
      s = invoke_popen(cmd)
      $stderr.reopen original_stderr

      connection = klass.new(s, *args)
      EM.attach(rd, StderrHandler, connection)
      @conns[s] = connection
      yield(connection) if block_given?
      connection
    rescue
      $stderr.reopen(original_stderr)
      raise $!
    end
  end

end
