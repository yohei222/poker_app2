Rails.application.routes.draw do
  root 'poker#index'
  get 'poker' => 'poker#index'
  post 'poker' => 'poker#judge'
end
