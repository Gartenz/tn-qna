class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.integer :score, default: 1
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end
  end
end
