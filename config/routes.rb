Rails.application.routes.draw do
  devise_for :users, skip: [:registrations], controllers: {
    sessions: 'auth/sessions'
  }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  root 'patients#index'
  resources :certificates, only: [] do
    get :download, on: :collection
  end

  namespace :admin do
    resources :users
  end

  resources :diseases, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :medicines, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :patients, only: [:index, :new, :create, :edit, :update] do
    resources :anamneses, only: [:new, :create, :edit, :update]
    resources :consultations, only: [:index, :new, :create, :edit, :update] do
      get :prescription, to: 'prescriptions#download'

      resources :documents, only: [:index, :new, :create, :edit, :update, :destroy]
    end
    get :export, on: :collection
    get :special, to: 'special_patients#index', on: :collection
    delete :remove_special, to: 'special_patients#remove', on: :member
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
