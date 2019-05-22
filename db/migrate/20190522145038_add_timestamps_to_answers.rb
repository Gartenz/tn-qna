class AddTimestampsToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:answers, null: false)
  end
end
