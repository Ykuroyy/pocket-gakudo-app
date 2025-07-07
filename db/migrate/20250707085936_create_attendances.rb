class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.string :child_name
      t.string :status
      t.date :date
      t.text :message

      t.timestamps
    end
  end
end
