# frozen_string_literal: true

class SmtpServer < MidiSmtpServer::Smtpd

  def on_message_data_event(ctx)
    @mail = Mail.read_from_string(ctx[:message][:data])
    logger.debug("[#{ctx[:envelope][:from]}] for recipient(s): [#{ctx[:envelope][:to]}] | Subject: #{@mail.subject}")
    Email.add!(@mail)
  end

end
