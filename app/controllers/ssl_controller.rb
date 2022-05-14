class SslController < ApplicationController
  def letsencrypt
    if params[:id] == ENV["LETSENCRYPT_REQUEST"]
      render plain: ENV["LETSENCRYPT_RESPONSE"]
    end
  end
end
