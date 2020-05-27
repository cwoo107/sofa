class CreateEntrees < ActiveRecord::Migration[5.2]

  def change
    create_table :entrees do |t|
      t.string :name
      t.string :category
      t.string :price
      t.text :description
      t.boolean :available
      t.timestamps
    end
  end
end
