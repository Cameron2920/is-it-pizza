Rails.application.routes.draw do
  devise_for :users, :controllers => {
      :sessions => "users/sessions",
      :confirmations => "users/confirmations",
      :passwords => "users/passwords"}
  root 'questionable_pizzas#index'
  get 'questionable_pizzas/ask_cam'
  post 'questionable_pizzas/create' => 'questionable_pizzas#create'
  get 'questionable_pizzas/create' => 'questionable_pizzas#ask_cam'
  get 'questionable_pizzas/cam_says/:id/:is_it_pizza' => 'questionable_pizzas#cam_says'
  get 'questionable_pizzas' => 'questionable_pizzas#index'
  get 'gayyyyyyyyyy' => 'questionable_pizzas#index'
end
