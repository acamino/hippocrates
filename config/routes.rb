Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  root 'patients#index'
  resources :certificates, only: [] do
    get :download, on: :collection
  end

  resources :diseases, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :medicines, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :patients, only: [:index, :new, :create, :edit, :update] do
    resources :anamneses, only: [:new, :create, :edit, :update]
    resources :consultations, only: [:index, :new, :create, :edit, :update] do
      get :prescription, to: 'prescriptions#download'
    end
    get :special, on: :collection
    delete :remove_special, on: :member
  end
  resources :settings, only: [:index]

  namespace :api, defaults: { format: 'json' } do
    resources :patients, only: [] do
      resources :consultations, only: [:index] do
        collection do
          post   'previous'
          post   'next'
          post   'last'
          delete 'destroy'
        end
      end
    end

    resources :diseases, only: [:index]
    resources :medicines, only: [:index]
    resources :settings, only: [:index, :update]
  end
end
