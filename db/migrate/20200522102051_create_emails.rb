# frozen_string_literal: true

class CreateEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :emails do |t|
      t.timestamps

      t.string :message_id, null: false
      t.string :subject, null: false
      t.text :from_emails, null: false
      t.text :to_emails, null: false
      t.text :body_html
      t.text :body_text
      t.string :response_code
    end
  end
end
