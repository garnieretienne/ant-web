class SubscribersController < ApplicationController

  def index
    @mailing_list = MailingList.find(params[:mailing_list_id])
    @subscribers = @mailing_list.subscribers
    @new_subscriber = @subscribers.new
  end

  def create
    mailing_list = MailingList.find(params[:mailing_list_id])
    subscription = mailing_list.subscribe(
      user_params[:name], user_params[:email_address]
    )

    if subscription.save
      flash.notice = "Subscriber correctly added"
    else
      errors_text = subscription.errors.full_messages.join(", ")
      flash.alert = "Cannot add this subscriber: #{errors_text}"
    end

    redirect_to(mailing_list_subscribers_path(mailing_list))
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address)
  end
end
