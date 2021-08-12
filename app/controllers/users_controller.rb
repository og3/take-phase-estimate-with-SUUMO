class UsersController < ApplicationController
  before_action :authenticate_user!
  # 利用状況が見られる
  def show
    @aimitumori_logs = current_user.aimitumori_logs
  end

end
