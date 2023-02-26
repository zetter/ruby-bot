require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require './environment'

post '/push' do
  GetNotificationsWorker.perform_async
  status 200
  body ''
end
