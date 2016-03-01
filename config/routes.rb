Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get '/lists', to: 'lists#index'
    end
  end
end
