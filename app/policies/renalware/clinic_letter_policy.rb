module Renalware
  class ClinicLetterPolicy < LetterPolicy
    def new? ; has_privilege? end

    private
    def has_privilege?
      user.has_role?(:clinician) || user.has_role?(:admin) || user.has_role?(:super_admin)
    end
  end
end