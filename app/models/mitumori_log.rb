class MitumoriLog < ApplicationRecord
  belongs_to :email

  def self.create_mitumori_log(params, email)
    create(email_id: email.id, bukken_name: params[:room_name], url: params[:url],shop_names: params[:shop_list])
  end

end
