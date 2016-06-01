Rails.application.routes.draw do
  root 'patients#index'
  resources :medicines, only: [:index, :new, :create, :edit, :update]
  resources :patients, only: [:index, :new, :create, :edit, :update] do
    resources :anamneses, only: [:new, :create, :edit, :update]
    resources :consultations, only: [:new, :create]
  end

  namespace :api, defaults: { format: 'json' } do
    resources :patients, only: [] do
      resources :consultations, only: [:index] do
        post 'previous', on: :collection
        post 'next', on: :collection
        post 'last', on: :collection
      end
    end

    resources :diseases, only: [:index]
    resources :medicines, only: [:index]
  end
end
