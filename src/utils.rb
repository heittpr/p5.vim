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
