class GateController < ApplicationController
  # see https://github.com/gonzalo-bulnes/simple_token_authentication#allow-controllers-to-handle-token-authentication
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  acts_as_token_authentication_handler_for User, fallback: :exception

  def open
    # render json: { ok: true }
    # Access.create(user: current_user, openedWith: params[:opened_with])
    GateOpenerJob.perform_async(user: current_user, openedWith: params[:opened_with])
  end

end
