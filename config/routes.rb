Rails.application.routes.draw do
  root 'patients#index'
  resources :patients, only: [:index, :new, :create, :edit, :update] do
    resources :anamneses, only: [:new, :create]
  end
end
