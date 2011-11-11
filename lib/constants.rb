module Constants
    SITE_HOST = Proc.new {
    if Rails.env == 'production'
      'nextsprocket.com'
    else
      '127.0.0.1:3000'
    end
  }.call

  # DEFAULT_DATE_TIME_FORMAT = "%Y/%m/%d %H:%M:%S +0000"
  DEFAULT_DATE_TIME_FORMAT = "%m/%d/%Y %I:%M %p"
  MONTH_DAY_YEAR_FORMAT = "%b %d %Y"
  DATE_FORMAT_FOR_PERMALINK = "%y%m%d%H%M%S"

  CATEGORIES = ["New Project", "New Feature", "Bug Fix", "Source Language Translation", "Documentation", "Example Code"]
  COMPUTER_LANGUAGES = ["Ruby", "PHP", "Perl", "Python", "Javascript", "Java", "Scala", "Clojure", "C++", "C", "C#", "Objective-C"]
  DEFAULT_LICENSE = "MIT License"
  OPEN_SOURCE_LICENSES =  ["MIT License", "Apache License 2.0", "BSD License", "GPL 2.0", "GPL 3.0", "LGPL 3.0",
    "Eclipse Public License", "Mozilla Public License"]
  OPEN_SOURCE_LICENSE_LINKS =     {"MIT License" => "http://www.opensource.org/licenses/mit-license.php",
     "Apache License 2.0" => "http://www.opensource.org/licenses/apache2.0.php",
     "BSD License" => "http://www.opensource.org/licenses/bsd-license.php",
     "GPL 2.0" => "http://www.opensource.org/licenses/gpl-2.0.php",
     "GPL 3.0" => "http://www.opensource.org/licenses/gpl-3.0.html",
     "LGPL 3.0" => "http://www.opensource.org/licenses/lgpl-3.0.html",
     "Eclipse Public License" =>"http://www.opensource.org/licenses/eclipse-1.0.php",
     "Mozilla Public License" => "http://www.opensource.org/licenses/mozilla1.1.php"}
  SOLUTION_FORMATS =  ["Link to Source Code", "Text Document", "Archive file"]

  class TaskRewardStatus
    UNPAID = 'unpaid'
    PAID = 'paid'
  end
  
    # accepted means task creator clicked 'accept'
    # paid gets set when the task creator pays thru paypal
    class TaskSubmissionStatus
    UNREAD = 'unread'
    OPEN = 'open'
    REJECTED= 'rejected'
    ACCEPTED = 'accepted'
    PAID = 'paid'
  end

  class TaskStatus
    OPEN = 'open'
    CANCELED = 'canceled'
    COMPLETED = 'completed'
    EXPIRED = 'expired'
  end

  class ReputationActionCode
    PAID_FOR_SUBMISSION = 1
    REJECTED_SUBMISSION_WITHOUT_REASON = 2
    TASK_SUBMISSION_ACCEPTED = 3
    OPENED_AND_IGNORED_SUBMISSION = 4
  end

  class ReputationPoints
    PAID_FOR_SUBMISSION = 1
    REJECTED_SUBMISSION_WITHOUT_REASON = -5
    TASK_SUBMISSION_ACCEPTED = 2
    OPENED_AND_IGNORED_SUBMISSION = -3
  end
  
  class ActivityItemType
    TASK_CREATED = 1
    TASK_SUBMISSION_ACCEPTED = 2
    TASK_COMPLETED = 3
    NEW_CONTRIBUTION = 4
    CREATOR_REWARD_INCREASED = 5
    NEW_TASK_COMMENT = 6
    NEW_TASK_SUBMISSION_COMMENT = 7
    NEW_TASK_SUBMISSION = 8
    NEW_USER = 9
  end
  
  REPUTATION_TEXT = {ReputationActionCode::PAID_FOR_SUBMISSION => "Paid for submission",
                          ReputationActionCode::REJECTED_SUBMISSION_WITHOUT_REASON => "Rejected submission without comment",
                          ReputationActionCode::TASK_SUBMISSION_ACCEPTED => "Task submission accepted",
                          ReputationActionCode::OPENED_AND_IGNORED_SUBMISSION => "Opened and ignored submission."}
end