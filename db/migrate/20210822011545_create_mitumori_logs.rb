class CreateMitumoriLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :mitumori_logs do |t|
      t.references :email, foreign_key: true
      t.string :bukken_name
      t.string :url
      t.boolean :status, default: false
      t.text   :shop_names

      t.timestamps
    end
  end
end
