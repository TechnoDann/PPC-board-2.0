class BoardMailer < ActionMailer::Base
  default from: "system@ppc-board.invalid"
  
  def welcome_email(user)
    @user = user
    mail(:to => "#{@user.name} <#{@user.email}>", 
         :subject => "Welcome to the PPC (Board)!") do |format|
      format.text
      format.html
    end
  end
end
