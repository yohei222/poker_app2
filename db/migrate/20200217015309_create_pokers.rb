class CreatePokers < ActiveRecord::Migration[5.2]
  def change
    create_table :pokers do |t|
      t.string :poker
      t.timestamps
    end
  end
end
