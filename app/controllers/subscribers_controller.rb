class SubscribersController < ApplicationController

  def index
    @mailing_list = MailingList.find(params[:mailing_list_id])
    @subscribers = @mailing_list.subscribers
    @new_subscriber = Subscriber.new
  end

  def create
    mailing_list = MailingList.find(params[:mailing_list_id])
    subscription = mailing_list.subscribe(
      subscriber_params[:name], subscriber_params[:email]
    )

    if subscription.save
      flash.notice = "Subscriber correctly added"
    else
      errors_text = subscription.errors.full_messages.join(", ")
      flash.alert = "Cannot add this subscriber: #{errors_text}"
    end

    redirect_to(mailing_list_subscribers_path(mailing_list))
  end

  def destroy
    mailing_list = MailingList.find(params[:mailing_list_id])
    subscriber = mailing_list.subscribers.find(params[:id])

    if mailing_list.unsubscribe(subscriber.email)
      flash.notice = "This email has been removed from this list subscribers"
    else
      flash.alert = "Cannot unsubscribe this email"
    end

    redirect_to(mailing_list_subscribers_path(mailing_list))
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:name, :email)
  end
end
