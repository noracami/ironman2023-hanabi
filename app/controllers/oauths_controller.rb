# frozen_string_literal: true

class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    if Rails.env.production?
      login_at(params[:provider])
    else

      @user = User.find_or_create_by
    end
  end

  def callback
    provider = params[:provider]
    if (@user = login_from(provider))
      cookies.encrypted['user_id'] = @user.id

      redirect_to root_path, notice: "Logged in from #{provider.titleize}!"
    else
      begin
        @user = create_from(provider)
        # NOTE: this is the place to add '@user.activate!' if you are using user_activation submodule

        reset_session # protect from session fixation attack
        cookies.encrypted['user_id'] = @user.id
        auto_login(@user)
        redirect_to root_path, notice: "Logged in from #{provider.titleize}!"
      rescue StandardError => e
        pp '&' * 100
        pp e
        pp '&' * 100
        redirect_to root_path, alert: "Failed to login from #{provider.titleize}!"
      end
    end
  end
end
