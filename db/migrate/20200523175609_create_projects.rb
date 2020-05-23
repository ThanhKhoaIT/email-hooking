# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.timestamps

      t.string :name, null: false
      t.string :hook_email, null: false
      t.string :hook_url, null: false
    end
  end
end
