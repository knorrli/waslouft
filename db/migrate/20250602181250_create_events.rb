class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :subtitle
      t.date :start_date, null: false
      t.datetime :start_time
      t.string :url, null: false

      t.timestamps
    end
  end
end
