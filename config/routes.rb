Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "phase_estimate#input_url"
  get "/input_url" => "phase_estimate#input_url"
  post "/check_url" => "phase_estimate#check_url"
  post "/send_aimitumori" => "phase_estimate#send_aimitumori"
  get "/result" => "phase_estimate#result"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
