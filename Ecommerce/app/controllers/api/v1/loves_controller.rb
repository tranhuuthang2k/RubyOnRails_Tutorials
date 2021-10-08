class Api::V1::LovesController< Api::V1::BaseController
  skip_before_action :require_jwt
  before_action :load_user, only: [:index, :unlove]
  
    def index
      product_favorite = @user.product_favorites.new(user_id: @user.id, product_id: params[:product_id])
      if product_favorite.save
        render json: success_message('Successfully',{ product_favorite: ActiveModelSerializers::SerializableResource.new(product_favorite, each_serializer: LoveSerializer),})
      else
        render json: error_message(t "product id not_found")
      end
    end
    
    def unlove
      product_favorite = @user.product_favorites.find_by(product_id: params[:product_id])
      if product_favorite
          product_favorite.delete
          render json: success_message('Successfully',{ product_favorite: ActiveModelSerializers::SerializableResource.new(product_favorite, each_serializer: LoveSerializer),})
        else
          render json: error_message(t "product id not_found")
        end
    end

    private
    def load_user
      token = params[:token]
      hmac_secret = 'rubyk01'
      decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
      @user = User.find_by(api_token_digest: decoded_token.first['data'])
    end
end