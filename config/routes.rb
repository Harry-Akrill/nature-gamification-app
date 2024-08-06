# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    get 'reported_reviews/index'
    get 'reported_reviews/show'
    get 'reported_reviews/destroy'
  end
  resources :pois
  devise_for :users, path: "api/auth", path_names: {
                                         sign_in:      "login",
                                         sign_out:     "logout",
                                         registration: "signup"
                                       },
                     controllers: {
                       sessions:      "users/sessions",
                       registrations: "users/registrations"
                     }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  scope "api" do
    get "/auth/status", to: "users/authentication_status#index"

    get "/utils/geolocation", to: "utils#geolocation"
    post "/utils/geolocation-with-ip-param", to: "utils#geolocation_with_ip_param"

    get "/stats/landing/register-new-page-visit", to: "stats/landing_page#register_new_page_visit"
    post "/stats/landing/register-new-page-visit-with-ip-param", to: "stats/landing_page#register_new_page_visit_with_ip_param"
    post "/stats/landing/update-page-visit", to: "stats/landing_page#update_page_visit"
    post "/stats/landing/path-to-registration-append", to: "stats/landing_page#path_to_registration_append"
    post "/stats/landing/registration-completed", to: "stats/landing_page#registration_completed"

    get "/stats/admin/register-new-page-visit", to: "stats/admin_page#register_new_page_visit"
    post "/stats/admin/register-new-page-visit", to: "stats/admin_page#register_new_page_visit"
    post "/stats/admin/register-new-page-visit-with-ip-param", to: "stats/admin_page#register_new_page_visit_with_ip_param"
    post "/stats/admin/update-page-visit", to: "stats/admin_page#update_page_visit"

    get "/stats/reporter/register-new-page-visit", to: "stats/reporter_page#register_new_page_visit"
    post "/stats/reporter/register-new-page-visit-with-ip-param", to: "stats/reporter_page#register_new_page_visit_with_ip_param"
    post "/stats/reporter/update-page-visit", to: "stats/reporter_page#update_page_visit"

    get "/stats/app/register-new-page-visit", to: "stats/app#register_new_page_visit"
    post "/stats/app/register-new-page-visit-with-ip-param", to: "stats/app#register_new_page_visit_with_ip_param"
    post "/stats/app/update-page-visit", to: "stats/app#update_page_visit"
    post "/stats/app/register-new-poi-click", to: "stats/app#register_new_poi_click"

    get "/admin/users", to: "admin/users#all_users"
    post "/admin/users", to: "admin/users#update_user"
    delete "/admin/users", to: "admin/users#delete_user"
    post "/admin/users/deactivate", to: "admin/users#deactivate_user"
    post "/admin/users/activate", to: "admin/users#activate_user"
    get "/admin/reviews", to: "admin/reviews#all_reviews"
    delete "/admin/reviews", to: "admin/reviews#delete_review"
    get "/admin/questions", to: "admin/questions#all_questions"
    post "/admin/questions", to: "admin/questions#answer_edit_create_question"
    delete "/admin/questions", to: "admin/questions#delete_question"
    get "/admin/mailinglist", to: "admin/mailing_list#all_emails"
    get "/admin/report-response", to: "admin/mailing_list#all_emails"
    get "/admin/comments", to: "admin/comments#all_comments"
    patch "/admin/comments/:id/toggle_report_status", to: "admin/comments#toggle_report_status"
    delete "/admin/comments/:id", to: "admin/comments#delete_comment"
    post '/admin/comments/:id/send_email_notification', to: 'admin/comments#create_email'
    
    get "/admin/pois", to: "admin/pois#all_pois"
    post "/admin/pois", to: "admin/pois#create_poi"
    delete "/admin/pois", to: "admin/pois#delete_poi"
    post "/admin/pois/edit", to: "admin/pois#edit_poi"
    get "/admin/pois/features", to: "admin/pois#all_poi_feature_options"

    get "/admin/stats/globe", to: "admin/stats#globe"
    get "/admin/stats/all-visits", to: "admin/stats#all_visits"
    get "/admin/stats/route-visits", to: "admin/stats#route_visits"
    get "/admin/stats/overall-details", to: "admin/stats#overall_details"

    scope "admin/stats" do
      get "logins", to: "admin/stats/logins#all"
      get "pois", to: "admin/stats/pois#all"
      get "points-badges", to: "admin/stats/points_badges#all"
    end

    get "/reporter/stats/globe", to: "reporter/stats#globe"
    get "/reporter/stats/all-visits", to: "reporter/stats#all_visits"
    get "/reporter/stats/route-visits", to: "reporter/stats#route_visits"
    get "/reporter/stats/overall-details", to: "reporter/stats#overall_details"

    get "/questions", to: "questions#all_questions"
    post "/questions", to: "questions#submit_question"
    post "/questions/upvote", to: "questions#upvote_question"
    post "/questions/downvote", to: "questions#downvote_question"
    delete "/questions/upvote", to: "questions#cancel_upvote_question"
    delete "/questions/downvote", to: "questions#cancel_downvote_question"

    get "/reviews", to: "reviews#all_reviews"
    post "/reviews", to: "reviews#submit_review"
    post "/reviews/upvote", to: "reviews#upvote_review"
    post "/reviews/downvote", to: "reviews#downvote_review"
    delete "/reviews/upvote", to: "reviews#cancel_upvote_review"
    delete "/reviews/downvote", to: "reviews#cancel_downvote_review"

    post "/mailinglist", to: "mailing_list#submit_email"

    # /app url (customer) api routes

    scope "settings" do
      get "/profile", to: "customer/profile#show"
      put "/profile", to: "customer/profile#update_user_profile"
      post "/profile/update-picture", to: "customer/profile#update_profile_picture"
    end

    scope "poi" do
      get "/", to: "customer/pois#all"
      get "/get-by-id", to: "customer/pois#single_poi_by_id"
      get "/features", to: "customer/pois#all_poi_features"
      get "/search", to: "customer/pois#search_by_name"
      post "/poi-image/upload", to: "customer/pois#upload_poi_picture"
    end

    scope "favourites" do
      get "/", to: "customer/favourite_pois#all"
      get "/single", to: "customer/favourite_pois#single_poi_favourite_status"
      post "/", to: "customer/favourite_pois#add"
      delete "/", to: "customer/favourite_pois#remove"
    end
    
    scope "comments" do
      get "/", to: "customer/poi_comments#all"
      post "/", to: "customer/poi_comments#create"
      post "/:id/report", to: "customer/poi_comments#report"

    end

    scope "check-in" do
      get "/candidates", to: "customer/check_in#check_in_candidates"
      get "/", to: "customer/check_in#all"
      get "/single", to: "customer/check_in#single_poi_check_in_status"
      post "/", to: "customer/check_in#register_check_in"
    end

    scope "points-badges" do
      get "/", to: "customer/points_badges#all"
      get "/avatar", to: "customer/points_badges#avatar_dropdown_current_total_points"
      get "/in-progress", to: "customer/points_badges#all_in_progress"
    end

    namespace :customer, path: '' do
      namespace :social, path: 'social' do
        resources :posts, only: [:index, :create, :update, :destroy] do
          post 'like', on: :member
        
          resources :comments, only: [:index, :create, :update, :destroy]
        end

        resources :friend_requests, only: [:create, :index, :update, :destroy, :show] do
          member do
            put :accept
          end
        end

        get "/users/search-by-nickname", to: "users#search_by_nickname"
        resources :users, only: [:create, :index, :update, :destroy, :show]
        post 'users/block/:id', to: 'blocks#block', as: 'block_user'
        delete 'users/unblock/:id', to: 'blocks#unblock', as: 'unblock_user'
        resources :blocks, only: [:create, :index, :update, :destroy]
        resources :friends, only: [:index, :destroy]
      end
    end
  end
end
