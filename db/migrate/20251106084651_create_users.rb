class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.float :preferred_working_hour_per_day

      t.timestamps
    end
  end
end
