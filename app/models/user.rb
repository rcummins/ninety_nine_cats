class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true
    validates :password, length: { in: 8..30 }, allow_nil: true

    after_initialize :ensure_session_token
    
    attr_reader :password

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    private

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end
    
    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)

        return user if user && user.is_password?(password)
        return nil
    end
end
