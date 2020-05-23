# frozen_string_literal: true

require 'smtp_server'

task smtp_service: :environment do
  server = SmtpServer.new(25, '0.0.0.0', 4)

  at_exit do
    if server
      puts "#{Time.now}: Shutdown MySmtpd..."
      server.stop
    end
    puts "#{Time.now}: MySmtpd down!"
  end

  server.start
  server.join
end
