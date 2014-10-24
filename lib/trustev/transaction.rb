require 'digest'

module Trustev
  class Transaction
    def retrieve_token
      time = Time.now
      hashed_password = password time
      hash = sha256hash time

      body = [
        {
          "UserName" => @username,
          "Password" => hashed_password,
          "Sha256Hash" => hash,
          "Timestamp" => Time.now.to_i.to_s
        }
      ]


    end

    def password(time)
      generate_hash @password, time
    end

    def sha256hash(time)
      generate_hash @username, time
    end

    def generate_hash(modifier, time)
      sha256 = Digest::SHA256.new
      sha256 << "#{time.strftime '%Y%m%d%H%M%S'}.#{modifier}"
      password_part_1 = sha256.hexdigest
      sha256 = Digest::SHA256.new
      sha256 << "#{password_part_1}.#{@shared_secret}"
      sha256.hexdigest
    end
  end
end