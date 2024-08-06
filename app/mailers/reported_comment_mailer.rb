class ReportedCommentMailer < ApplicationMailer
    def reported_comments_noti(reported_comments_email)
        mail(to: reported_comments_email, subject: "Comment is reported and deleted")
    end
end
