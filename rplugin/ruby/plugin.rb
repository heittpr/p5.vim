require 'neovim'

serverPid, browserPid = nil
port = 8080

Neovim.plugin do |plug|
  plug.command(:Preview) do |nvim|
    dir = nvim.command_output(:pwd)
  
    if serverPid == nil
      server = ::IO.popen("browser-sync start --no-open --no-ui --no-notify --port #{port} -w -f --server #{dir}")
      serverPid = server.pid
      Process.detach(serverPid)
    end

    if browserPid == nil
      browser = ::IO.popen("chromium --app=http://localhost:#{port}")
      browserPid = browser.pid
      Process.detach(browserPid)
    end
  end
end
