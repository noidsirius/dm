class UserMailer < ActionMailer::Base

  # class variable to hold logo
  @@acm = File.read(Rails.root.join('app', 'assets', 'images', 'acm-logo.png'))

  # setting default from
  default from: "UT DM Contest"

  # call this method to send an email
  def welcome(user)
#     recipient = user.email
#     subject =
#         'به شاخه‌ی دانشجویی ای‌سی‌ام دانشگاه تهران خوش آمدید'
#     attachments.inline['acm.png'] = @@acm
#
#     puts 'Email: to => ' + recipient + ', subject => ' + subject
#     mail(to: recipient, subject: subject) do |format|
#       format.html { render 'welcome_message' }
# #      format.html { render 'welcome_message' }
#     end
  end
  def submission_complete(submission)
#     recipient = submission.profile.user.email
#     subject =
#         'UT DM - Problem ' + submission.problem.id.to_s
#
#     puts 'Email: to => ' + recipient + ', subject => ' + subject
#     mail(to: recipient, subject: subject) do |format|
#       format.html { render 'submission_message' , :locals => {:submission => submission} }
# #      format.html { render 'welcome_message' }
#     end
  end

  def submission_response(submission)
#     recipient = submission.profile.user.email
#     subject =
#         'UT DM - Problem ' + submission.problem.id.to_s
#
#     puts 'Email: to => ' + recipient + ', subject => ' + subject
#     mail(to: recipient, subject: subject) do |format|
#       format.html { render 'submission_response' , :locals => {:submission => submission} }
# #      format.html { render 'welcome_message' }
#     end
  end

  def auction_change(auction, user, bid)
#     recipient = user.email
#     subject =
#         'UT DM - Auction ' + auction.name
#
#     puts 'Email: to => ' + recipient + ', subject => ' + subject
#     mail(to: recipient, subject: subject) do |format|
#       format.html { render 'auction_change' , :locals => {:profile => user.profile, :auction => auction, :bid => bid} }
# #      format.html { render 'welcome_message' }
#     end
  end


  def start_register(profile, event)
#     recipient = profile.user.email
#     subject =
#         'شاخه‌ی دانشجویی ای‌سی‌ام دانشگاه تهران -' +
#             'آغاز ثبت نام رویداد ' + event.title
#     attachments.inline['acm.png'] = @@acm
#
#     puts 'Email: to => ' + recipient + ', subject => ' + subject
#     mail(to: recipient, subject: subject) do |format|
#       format.html { render 'start_register', :locals => {:profile => profile, :event => event} }
# #      format.html { render 'welcome_message' }
#     end
  end



end