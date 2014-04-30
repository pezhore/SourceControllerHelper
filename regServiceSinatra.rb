# Name        : regServiceSinatra.rb
# Description : This will register sinatra_svc.rb as a service
# Author      : Brian Marsh

require 'rubygems'
require 'win32/service'

include Win32

# Specify Service name as seen in services.msc
SERVICE_NAME = 'Ruby_Sinatra'

# Create a new service
Service.create({
  :service_name       => SERVICE_NAME,
  :service_type       => Service::WIN32_OWN_PROCESS,
  :description        => 'Ruby webservice to auto sync Git repositories',
  :start_type         => Service::AUTO_START,
  :error_control      => Service::ERROR_NORMAL,
  :binary_path_name   => 'c:\Ruby200\bin\ruby.exe -C c:\scripts\Ruby\SourceControlSync\ sinatra_svc.rb',
  :display_name       => SERVICE_NAME
})

# delete the service
# NOTE: if the services applet is up during this operation, the service won't be removed from that ui
# unitil you close and reopen it (it gets marked for deletion)
#Service.delete(SERVICE_NAME)