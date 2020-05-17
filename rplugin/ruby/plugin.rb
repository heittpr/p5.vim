require 'neovim'
require 'fileutils'

require_relative '../../src/utils'

requirements = ['browser-sync', 'chromium']
serverPid, browserPid = nil
port = get_random_port

Neovim.plugin do |plug|
  # check dependencies
  plug.autocmd(:VimEnter) do |nvim|
    if !check requirements
      raise "missing p5.vim dependencies"
    end
  end

  # preview
  plug.command(:P5Preview) do |nvim|
    cwd = nvim.command_output(:pwd)

    if serverPid == nil
      serverPid = spawn("browser-sync start --no-open --no-ui --no-notify --port #{port} -w -f --server #{cwd}")
    end

    if browserPid == nil
      browserPid = spawn("chromium --app=http://localhost:#{port}")
    end

    nvim.command("echo 'server running on port #{port}'")
  end
  
  plug.command(:P5PreviewStop) do |nvim|
    if serverPid != nil
      kill(serverPid, browserPid)
      serverPid, browserPid = nil
    
      nvim.command("echo 'server terminated'")
    else
      nvim.command("echo 'the server is not running'")
    end
  end

  plug.command(:P5ServerStatus) do |nvim|
    nvim.command("echo 'pid: #{serverPid} | port: #{port}'")
  end

  # template files
  plug.command(:P5Template) do |nvim|
    e = nvim.command_output(":echo expand('%:e')")

    case e
    when 'js'
      insert_template('sketch.js', nvim)
    when 'html'
      insert_template('index.html', nvim)
    end
  end
end
