require "benchmark"

namespace :hd do
  desc "Signs-off Open sessions that have a signed_off_by and are more than a few days old. "\
       "A usability update may render this task redundant in the future but currently there are " \
       "Save and Save and Sign-Off buttons, and user is not alwasy using the latter."
  task close_stale_open_sessions: :environment do
    Rails.logger = Logger.new(STDOUT)
    Renalware::HD::Sessions::CloseStaleOpenSessions.call(
      performed_before: 3.days.ago
    )
  end
end
