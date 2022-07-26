Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "departments#index"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout" ,to: "sessions#destroy"
    resources :users
    resources :departments do
      resources :reports, only: %i(new index show edit update destroy)
    end
    resources :reports do
      member do
        put :approve
      end
    end
    resources :relationships, only: %i(new create destroy update)
    resources :comments
    resources :notifies, only: :show
  end
end
