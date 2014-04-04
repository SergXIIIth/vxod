module Vxod
  class Notify
    def self.registration(user, auto_password)
      # Pony.options = {
      #   from: '<email>', 
      #   via: :smtp, 
      #   via_options: { 
      #     address:      'smtp.yandex.ru',
      #     port:         '587',
      #     smtp_domain:  '<domain>',
      #     user_name:    '<user_name>',
      #     password:     '<password>',

      #     enable_starttls_auto: true,
      #     authentication: :plain
      #   } 
      # }


      templite = "#{__dir__}/middleware/views/emails/registration.slim"

      Pony.mail(
        to: user.email,
        subject: 'Registration',
        html_body: Tilt.new(templite).render(user)
      )
    end
  end
end