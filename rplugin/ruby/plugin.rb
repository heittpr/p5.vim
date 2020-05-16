require 'neovim'

require_relative '../../src/utils'

requirements = ['browser-sync', 'chromium']
serverPid, browserPid = nil
port = 8080

Neovim.plugin do |plug|
  # check dependencies
  plug.autocmd(:VimEnter) do |nvim|
    if !check requirements
      raise "missing p5.vim dependencies"
    end
  end

  plug.command(:SketchPreview) do |nvim|
    dir = nvim.command_output(:pwd)
  
    if serverPid == nil
      serverPid = spawn("browser-sync start --no-open --no-ui --no-notify --port #{port} -w -f --server #{dir}")
    end

    if browserPid == nil
      browserPid = spawn("chromium --app=http://localhost:#{port}")
    end
  end
  
  plug.command(:SketchPreviewStop) do
    kill(serverPid, browserPid)
    serverPid, browserPid = nil
  end
end
