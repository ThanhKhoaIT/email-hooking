# frozen_string_literal: true

require 'email_hook'

class HookJob < ActiveJob::Base

  queue_as :default

  def perform(email_id)
    email = Email.find(email_id)
    ::EmailHook.new(email).call
  end

end
