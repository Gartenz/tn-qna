class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.boolean :good, default: false
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end
  end
end
