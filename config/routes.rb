Rails.application.routes.draw do
  root 'patients#index'
  resources :medicines, only: [:index, :new, :create, :edit, :update]
  resources :patients, only: [:index, :new, :create, :edit, :update] do
    resources :anamneses, only: [:new, :create, :edit, :update]
    resources :consultations, only: [:new, :create, :edit, :update]
    get :special, on: :collection
  end

  namespace :api, defaults: { format: 'json' } do
    resources :patients, only: [] do
      resources :consultations, only: [:index] do
        collection do
          post 'previous'
          post 'next'
          post 'last'
        end
      end
    end

    resources :diseases, only: [:index]
    resources :medicines, only: [:index]
  end
end
