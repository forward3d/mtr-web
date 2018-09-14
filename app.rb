require 'sinatra'
require 'sinatra-websocket'
require 'pty'
require 'shellwords'

set :bind, '0.0.0.0'
set :port, '8000'
set :server, 'thin'

get '/' do
  if !request.websocket?
    erb :index
  else
    request.websocket do |ws|

      ws.onmessage do |msg|
        request = JSON.parse(msg)
        args = ['mtr', '-p', '-c', '10']
        if request['no_dns']
          args << '--no-dns'
        elsif request['protocol'] == 'TCP'
          args << '-T'
        else request['protocol'] == 'UDP'
          args << '-u'
        end

        if request['version'] == '4'
          args << '-4'
        elsif request['version'] == '6'
          args << '-6'
        end

        args << Shellwords.escape(request['hostname'])
        EM.defer { run(ws, args) }
      end

    end
  end
end

def run(ws, args)
  begin
    PTY.spawn(args.join(' ')) do |r, w, pid|
      begin
        r.each do |line|
          parts = line.split(' ')
          parts[2] = sprintf('%.2f%%', parts[2].to_f / 1000.0)
          ws.send(parts.to_json)
        end
      rescue Errno::EIO
      end
    end
  rescue PTY::ChildExited => e
    puts "The child process exited!"
  end
end
