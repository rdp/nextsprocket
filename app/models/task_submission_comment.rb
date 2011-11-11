class TaskSubmissionComment
  include MongoMapper::EmbeddedDocument

  key :profile_id, ObjectId, :required => true
  key :content, String
  key :created_at, Time

  belongs_to :profile

  def email_creators!
      task_submission = self._parent_document #embedded doc so can't refer to task_submission_id
      ActivityItem.create_new_task_submission_comment_event(self.profile, self, task_submission)

      task = task_submission.task
      if task_submission.profile.id == self.profile.id
        # send to task creator
        UserNotifier.deliver_new_task_submission_comment(task, task_submission, task.profile.user, self)
      else
        #send to task submission creator
        UserNotifier.deliver_new_task_submission_comment(task, task_submission, task_submission.profile.user, self)
      end
  end

end
