require 'neovim'
require 'fileutils'

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

  # preview
  plug.command(:SketchPreview) do |nvim|
    cwd = nvim.command_output(:pwd)
  
    if serverPid == nil
      serverPid = spawn("browser-sync start --no-open --no-ui --no-notify --port #{port} -w -f --server #{cwd}")
    end

    if browserPid == nil
      browserPid = spawn("chromium --app=http://localhost:#{port}")
    end
  end
  
  plug.command(:SketchPreviewStop) do
    kill(serverPid, browserPid)
    serverPid, browserPid = nil
  end

  # template file
  plug.command(:P5Template) do |nvim|
    path = File.expand_path('../../template/index.html', File.dirname(__FILE__))
    
    lines = File.readlines(path).map{ |l| l.chomp }
    index = nvim.current.buffer.line_number
    nvim.current.buffer.set_lines(index-1, index-1, false, lines)
  end
end
