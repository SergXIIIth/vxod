module Vxod
  class Notify
    def registration(user, host, send_password = false)
      templite = "#{__dir__}/middleware/views/emails/registration.slim"

      Pony.mail(
        to: user.email,
        subject: "Registration on #{host}",
        html_body: render(
          templite, 
          user: user, 
          host: host,
          send_password: send_password
        )
      )
    end

    def openid_registration(openid, host)
      registration(openid.user, host)
    end

    def render(templite, locals)
      Tilt.new(templite).render(nil, locals)
    end
  end
end