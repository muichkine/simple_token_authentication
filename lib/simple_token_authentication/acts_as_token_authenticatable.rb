module SimpleTokenAuthentication
  module ActsAsTokenAuthenticatable
    extend ActiveSupport::Concern

    # Please see https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
    # before editing this file, the discussion is very interesting.

    included do
      before_save :ensure_authentication_token
      private :generate_authentication_token
    end

    def ensure_authentication_token
      if authentication_token.blank?
        self.authentication_token = generate_authentication_token(token_generator)
      end
    end

    def generate_authentication_token(token_generator)
      loop do
        token = token_generator.generate_token
        break token if token_suitable?(token)
      end
    end

    def token_suitable?(token)
      not self.class.exists?(authentication_token: token)
    end

    def token_generator
      @token_generator ||= SimpleTokenAuthentication::TokenGenerator.new
    end

  end

end
