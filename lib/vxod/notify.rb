module Vxod
  class Notify
    def registration(user, user_password, host, send_password = true)
      templite = "#{__dir__}/middleware/views/emails/registration.slim"

      Pony.mail(
        to: user.email,
        subject: "Registration on #{host}",
        html_body: render(
          templite, 
          user: user, 
          host: host,
          password: user_password,
          send_password: send_password
        )
      )
    end

    def openid_registration(openid, user_password, host)
      registration(openid.user, user_password, host)
    end

    def render(templite, locals)
      Tilt.new(templite).render(nil, locals)
    end
  end
end