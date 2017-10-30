Rails.application.routes.draw do
  post 'character/update'
  get 'character/show'
  post 'user/new'
  post 'user/update'
  post 'user/login'
  post 'user/delete'
  post 'arena/find'
  post 'arena/attack'
  post 'arena/escape'
  post 'arena/last'
  root 'home#index'
end
