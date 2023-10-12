# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      return unless (verified_user = User.find_by(id: cookies.encrypted['user_id']))

      verified_user
    end
  end
end
