module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if verified_user = User.find_by(id: cookies.encrypted['user_id'])
        verified_user
      else
        visitor_name = SecureRandom.urlsafe_base64
        User.create(email: "#{visitor_name}@visit.or", name: "visitor: #{visitor_name[..6]}")
      end
    end
  end
end
