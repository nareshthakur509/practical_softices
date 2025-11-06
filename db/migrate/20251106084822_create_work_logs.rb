class CreateWorkLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :work_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.decimal :hours
      t.string :notes

      t.timestamps
    end
  end
end
