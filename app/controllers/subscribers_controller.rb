class SubscribersController < ApplicationController

  def index
    @mailing_list = MailingList.find(params[:mailing_list_id])
    @mailbox = @mailing_list.mailbox
    @subscribers = @mailing_list.subscribers
    @new_subscriber = Subscriber.new
  end

  def create
    mailing_list = MailingList.find(params[:mailing_list_id])
    @subscriber = mailing_list.subscribers.new(subscriber_params)

    if @subscriber.save
      flash.notice = "Subscriber added"
    else
      errors_text = @subscriber.errors.full_messages.join(", ")
      flash.alert = "Cannot add this subscriber: #{errors_text}"
    end

    redirect_to(mailing_list_subscribers_path(mailing_list))
  end

  def destroy
    mailing_list = MailingList.find(params[:mailing_list_id])
    subscriber = mailing_list.subscribers.find(params[:id])

    unless subscriber
      flash.alert = "Cannot unsubscribe this email in the subscribers"
      return redirect_to(mailing_list_subscribers_path(mailing_list))
    end

    subscriber.destroy
    flash.notice = "Email removed from subscribers"
    redirect_to(mailing_list_subscribers_path(mailing_list))
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:name, :email)
  end
end
