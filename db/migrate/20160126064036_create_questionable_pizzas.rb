class CreateQuestionablePizzas < ActiveRecord::Migration
  def change
    create_table :questionable_pizzas do |t|
      t.column :is_it_pizza, :integer, :null => false

      t.timestamps
    end
    add_attachment :questionable_pizzas, :pizza_image
  end
end
