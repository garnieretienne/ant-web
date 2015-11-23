class MailingListsController < ApplicationController

  def index
    @mailing_lists = MailingList.all
    @new_mailing_list = MailingList.new
  end

  def create
    mailing_list = current_user.mailing_lists.new(mailing_list_params)

    if mailing_list.save
      flash.notice = "Mailing list created"
    else
      errors_text = mailing_list.errors.full_messages.join(", ")
      flash.alert = "Cannot create the mailing list: #{errors_text}"
    end

    redirect_to(mailing_lists_path)
  end

  def destroy
    mailing_list = current_user.mailing_lists.find(params[:id])
    mailing_list.destroy
    redirect_to(mailing_lists_path, notice: "Mailing list destroyed")
  end

  private

  def mailing_list_params
    params.require(:mailing_list).permit(:name, :title)
  end
end
