class Admin::MessagesController < Admin::AdminController

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to lend_a_hand_path, :notice => 'Message deleted.'
  end

end
