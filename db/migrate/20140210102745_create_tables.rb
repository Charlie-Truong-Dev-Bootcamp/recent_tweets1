class CreateTables < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :username
      t.timestamps
    end

    create_table :tweets do |t|
      t.string :text
      t.string :sent_at
      t.belongs_to :twitter_user
      t.timestamps
    end

    add_index :tweets, :twitter_user_id
  end
end
