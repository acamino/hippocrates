Rails.application.routes.draw do
  root 'patients#index'
  resources :medicines, only: [:index, :new, :create, :edit, :update]
  resources :patients, only: [:index, :new, :create, :edit, :update] do
    resources :anamneses, only: [:new, :create, :edit, :update]
    resources :consultations, only: [:new, :create]
  end

  namespace :api, defaults: { format: 'json' } do
    resources :diseases, only: [:index]
    resources :medicines, only: [:index]
  end
end
