def exists(cmd)
  system "which #{cmd} > /dev/null 2>&1"
end

def check(requirements)
  requirements.all? { |r| exists r }
end

def spawn(cmd)
  io = ::IO.popen(cmd)
  Process.detach(io.pid)
  io.pid
end

def kill(*pids)
  pids.each{ |pid| Process.kill(:KILL, pid)}
end

def insert_template(name, nvim)
  path = File.expand_path("../template/#{name}", File.dirname(__FILE__))
  lines = File.readlines(path).map{ |l| l.chomp }

  buffer = nvim.current.buffer
  index = buffer.line_number

  buffer.set_lines(index-1, index-1, false, lines)
end
