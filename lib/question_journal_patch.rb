module QuestionJournalPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      has_one :question, :dependent => :destroy

      after_create :send_question_notification
    end

  end

  module ClassMethods
  end

  module InstanceMethods
    def send_question_notification
      if self.is_a?(Journal)
        if question
          question.save
          QuestionMailer.asked_question(self).deliver
        end
      end
    end

    def question_assigned_to
      # TODO: pull out the assigned user on edits
    end
  end
end
