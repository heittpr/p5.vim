require 'neovim'

$serverPid, $browserPid = nil
port = 8080

Neovim.plugin do |plug|
  plug.command(:P5start) do |nvim|
    dir = nvim.command_output(:pwd)
    $serverPid = Process.spawn("browser-sync start --no-open --no-ui --no-notify --port #{port} -w -f --server #{dir}")
    $browserPid = Process.spawn("chromium --app=http://localhost:#{port}")
  end
end
