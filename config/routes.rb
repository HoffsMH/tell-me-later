Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get '/todo_lists/:code', to: 'todo_lists#show'
      resources :todo_items, except: [:index, :new, :edit, :show]
    end
  end
end
