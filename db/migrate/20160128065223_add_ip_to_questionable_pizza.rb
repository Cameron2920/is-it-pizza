class AddIpToQuestionablePizza < ActiveRecord::Migration
  def change
    add_column :questionable_pizzas, :client_ip, :string
  end
end
