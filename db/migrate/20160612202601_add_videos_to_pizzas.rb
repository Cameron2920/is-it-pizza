class AddVideosToPizzas < ActiveRecord::Migration
  def change
    add_attachment :questionable_pizzas, :pizza_video
  end
end
