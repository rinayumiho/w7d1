class User < ApplicationRecord
    validates :user_name, :password_digest, :session_token, presence: true
    validates :user_name, :session_token, uniqueness: true
    # after_initialize :set_token 

    def self.generate_session_token
        SecureRandom::urlsafe_base64
    end

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        if user && user.is_password?(password)
            user
        else 
            nil
        end
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = Bcrypt::Password.create(password)
    end

    def is_password?(password)
        Bcrypt::Password.new(self.password_digest).is_password?(password)
    end
end
