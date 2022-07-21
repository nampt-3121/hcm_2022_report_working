Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "sessions#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout" ,to: "sessions#destroy"
    resources :users
    resources :departments do
      resources :report
    end

    resources :relationships, only: %i(new create destroy update)
    #http://localhost:3000/en/department/6/report/new
  end
end
