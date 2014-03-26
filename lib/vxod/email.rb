module Vxod
  class Email
    def self.valid?(email)
      email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
    end
  end
end