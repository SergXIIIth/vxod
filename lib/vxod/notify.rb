module Vxod
  class Notify
    def registration(user, host, auto_password = false)
      templite = "#{__dir__}/middleware/views/emails/registration.slim"

      Pony.mail(
        to: user.email,
        subject: "Registration on #{host}",
        html_body: render(
          templite, 
          user: user, 
          host: host,
          auto_password: auto_password
        )
      )
    end

    def render(templite, locals)
      Tilt.new(templite).render(nil, locals)
    end
  end
end