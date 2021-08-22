class CreateEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :emails do |t|
      t.string :email, null: false, default: ""
      t.boolean :ban, default: false
      t.timestamps
    end
  end
end
