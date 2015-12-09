class APIController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authorize

  # Only authorize request with the correct API token
  # (see `config/initializers/api_token.rb`)
  def authorize
    unless params[:token] == Rails.configuration.api_token
      return render(plain: "Unauthorized API token\n", status: :unauthorized)
    end
  end
end
