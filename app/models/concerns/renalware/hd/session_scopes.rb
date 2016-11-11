module Renalware
  module HD
    module SessionScopes
      def with_sessions_falling_within(period)
        falling_within(period)
      end

      def falling_within(range)
        where(hd_sessions: {
                type: Session::Closed.sti_name,
                signed_off_at: range
              }).or(
          where(hd_sessions: {
                  type: Session::DNA.sti_name,
                  performed_on: range
                }))
      end

      def with_finished_sessions
        finished
      end

      def finished
        where(hd_sessions: { type: [Session::Closed.sti_name, Session::DNA.sti_name] })
      end
    end
  end
end