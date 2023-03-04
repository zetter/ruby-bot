require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'
require './environment'

post '/push' do
  GetNotificationsWorker.perform_async
  status 200
  body ''
end

get '/ruby' do
  data = JSON.generate({program: params[:program]})
  erb :ruby, locals: {data: }
end