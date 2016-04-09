class BoardMailer < ActionMailer::Base
  default from: "system@ppc-posting-board-2-proto.herokuapp.com"
  
  def welcome_email(user)
    @user = user
    mail(:to => "#{@user.name} <#{@user.email}>", 
         :subject => "Welcome to the PPC (Board)!") do |format|
      format.text
      format.html
    end
  end

  def notify_watchers(new_reply, post_watched, user)
    @user = user
    @post = new_reply
    @parent = post_watched
    mail(:to => "#{@user.name} <#{@user.email}>", 
         :subject => "New reply to \"#{@parent.subject}\" on the PPC Board") do |format|
      format.text
      format.html
    end
  end
end
