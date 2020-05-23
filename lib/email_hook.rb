# frozen_string_literal: true

class EmailHook

  def initialize(email)
    @email = email
  end

  def call
    request!
    update_response!
  end

  private

  attr_reader :email
  attr_reader :response

  def request!
    @response = Http.post('https://enk087d3a23hh.x.pipedream.net', form: {
      message_id: email.message_id,
      to: email.to_emails,
      from: email.from_emails,
      subject: email.subject,
      html: email.body_html,
      text: email.body_text,
    })
  end

  def update_response!
    email.update!(response_code: response.code)
  end

end
