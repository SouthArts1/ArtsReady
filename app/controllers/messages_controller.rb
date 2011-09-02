class MessagesController < ApplicationController

  def create
    @message = current_org.messages.create(params[:message].merge({:user => current_user}))
    if @message.save
      redirect_to lend_a_hand_path, :notice => 'Message sent.'
    else
      redirect_to lend_a_hand_path, :notice => 'There was a problem with your message.'
    end
    
  end

end
