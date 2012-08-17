# from http://pastebin.com/C4hvAyKM

# feed stderr into connection's receive_stderr()

module EventMachine
  class StderrHandler < EventMachine::Connection
    def initialize(connection)
      @connection = connection
    end
   
    def receive_data(data)
      @connection.receive_stderr(data)
    end
  end
 
  def self.popen3(*args)
    original_stderr = $stderr.dup
    begin
      read, write = IO.pipe
      $stderr.reopen(write)
      connection = EM.popen(*args)
      $stderr.reopen(original_stderr)
      EM.attach(read, StderrHandler, connection)
      yield(connection) if block_given?
      connection
    rescue
      $stderr.reopen(original_stderr)
      raise $!
    end

  end
end
