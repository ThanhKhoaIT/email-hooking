# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'pages#home'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'sidekiq' && password == 'monitor'
  end
  mount Sidekiq::Web => '/sidekiq'
end
