Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get '/todo_lists/:code', to: 'todo_lists#show'
      post '/todo_items', to: 'todo_items#create'
      delete '/todo_items', to: 'todo_items#destroy'
    end
  end
end
