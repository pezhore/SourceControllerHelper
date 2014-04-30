# Name        : sinatra_svc.rb
# Description : This will run sinatra as a service, use in conjunction with regServiceSinatra.rb
# Author      : Brian Marsh

LOG_FILE = 'C:\\temp\\daemon.log'

require "rubygems"
require 'sinatra/base'

# Create Sinatra Application
class MySinatraApp < Sinatra::Base
  
  # Set default get/404 error pages	
  get '/' do
		"Nothing to see here..."
	end

	not_found do
		"File not found."
	end

	# Sync Git repository to local box
	post '/General-Automation' do

		# Set variables - Manifest/environment, git directory, git repo
		# Change these when appropriate
		@gitpath  = "c:/scripts/powershell/General-Automation"
		@gitrepo  = "git@server:bmarsh/general-automation.git"

		# Check to see if the folder exists
		if File.exist?(@gitpath)
				# If it does, just fetch/reset
				%x[cd #{@gitpath} && "c:\\Program Files (x86)\\Git\\bin\\git.exe" fetch --all && "c:\\Program Files (x86)\\Git\\bin\\git.exe" reset --hard origin/master]
		else
				# If it doesn't, git clone
				%x["c:\\Program Files (x86)\\Git\\bin\\git.exe" clone #{@gitrepo} #{@gitpath}]
		end
	end

end

# Service configuration details
begin
  require 'win32/daemon'
  include Win32
  $stdout.reopen("thin-server.log", "w")
  $stdout.sync = true
  $stderr.reopen($stdout)

  class Daemon
    def service_main

      MySinatraApp.run! :bind => '0.0.0.0', :port => 80

      while running?
        sleep 10
        File.open(LOG_FILE, "a"){ |f| f.puts "Service is running #{Time.now}" }
      end
    end

    def service_stop
      File.open(LOG_FILE, "a"){ |f| f.puts "***Service stopped #{Time.now}" }
      exit!
    end
  end

  Daemon.mainloop
rescue Exception => err
  File.open(LOG_FILE,'a+'){ |f| f.puts " ***Daemon failure #{Time.now} err=#{err} " }
  raise
end
