class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :subtitle
      t.date :start_date
      t.string :url
      t.references :location

      t.timestamps
    end
  end
end
