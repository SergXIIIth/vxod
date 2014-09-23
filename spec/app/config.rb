Mongoid.load!(__dir__ + '/mongoid.yml')

if %w(development production).include?(ENV['RACK_ENV'])
  Pony.options = {
    from: 'Makridenkov <hello@makridenkov.com>',
    via: :smtp,
    via_options: {
      address:      'smtp.yandex.ru',
      port:         '587',
      smtp_domain:  'makridenkov.com',
      user_name:    ENV['smtp.user'],
      password:     ENV['smtp.password'],

      enable_starttls_auto: true,
      authentication: :plain
    }
  }
end
