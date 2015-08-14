module V1
  class ItemsController < ApplicationController

    THRESHOLD = -200

    before_action :find_user

    def create
      @item = @user.items.create(item_params)

      if @item.persisted?
        balance_check
        render json: @item, status: :created
      else
        render json: { errors: @item.errors }, status: :unprocessable_entity
      end
    end

    private

    def balance_check
      new_balance = @user.process_balance
      if new_balance < THRESHOLD
        # @user.charge_late
        @user.mark_as_delinquent
      else
        @user.mark_as_clean
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

