# frozen_string_literal: true

class Email < ApplicationRecord

  serialize :to_emails, Array
  serialize :from_emails, Array

  after_commit :add_hook_job!, on: :create

  def self.add!(mail)
    self.create!(
      message_id: mail.message_id,
      subject: mail.subject,
      from_emails: mail.from,
      to_emails: mail.to,
      body_html: mail.html_part.body.to_s.unpack1('M'),
      body_text: mail.text_part.body.to_s.unpack1('M'),
    )
  end

  private

  def add_hook_job!
    ::HookJob.perform_later(self.id)
  end

end
