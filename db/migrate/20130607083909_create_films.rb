class CreateFilms < ActiveRecord::Migration
  def self.up
    create_table :films do |t|
      t.string :name
      t.string :year
      t.string :director
      t.text   :synopsis

      t.timestamps
    end
  end

  def self.down
    drop_table :films
  end
end
