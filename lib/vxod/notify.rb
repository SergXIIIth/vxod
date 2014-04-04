module Vxod
  class Notify
    def self.registration(user, auto_password = false)
      templite = "#{__dir__}/middleware/views/emails/registration.slim"

      Pony.mail(
        to: user.email,
        subject: 'Registration',
        html_body: render(templite, user, auto_password: auto_password)
      )
    end

    def self.render(templite, model, scope)
      Tilt.new(templite).render(mode, scope)
    end
  end
end