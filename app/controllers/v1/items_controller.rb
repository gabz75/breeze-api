module V1
  class ItemsController < ApplicationController

    THRESHOLD = -200

    before_action :find_user

    def create
      @previous_item = @user.items.last
      @previously_delinquent = @user.delinquent
      @item = @user.items.create(item_params)

      if @item.persisted?
        @user.process_balance
        trello_integration
        late_fee
        render json: @user, status: :created
      else
        render json: { errors: @item.errors }, status: :unprocessable_entity
      end
    end

    private

    def trello_integration
      if @user.balance < THRESHOLD and !@previously_delinquent
        @user.mark_as_delinquent
      elsif @user.balance >= THRESHOLD and @previously_delinquent
        @user.mark_as_clean
      end
    end

    def late_fee
      if @previous_item and @previously_delinquent
        days = ((@item.date - @previous_item.date) / (24 * 3600)).to_i
        @user.charge_late_fee(days)
      end
    end


    def find_user
      @user = User.find(params[:user_id])
    end

    def item_params
      params.permit(:item_type, :amount, :date)
    end

  end
end
