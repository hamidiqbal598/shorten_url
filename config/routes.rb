Rails.application.routes.draw do


  get '/', to: 'urls#create_shorten'
  root to: 'home#create_shorten'

  resources :urls do
    collection do
      get :create_shorten
      get :send_to_original
    end
  end

  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get '/:shorten_url', to: 'urls#send_to_original', as: :short

end
