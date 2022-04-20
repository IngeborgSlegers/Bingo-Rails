class CreateSquares < ActiveRecord::Migration[7.0]
  def change
    create_table :squares do |t|
      t.string :squareValue
      t.belongs_to :theme, foreign_key: true

      t.timestamps
    end
  end
end
