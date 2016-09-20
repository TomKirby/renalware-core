module Renalware
  log "Adding Demographics for Roger RABBIT"
  user = User.find_by(username: "kchdoc")
  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')

  rabbit.title = "Mr"
  rabbit.suffix = "OBE"
  rabbit.marital_status = "divorced"
  rabbit.telephone1 = "0201 555 1212"
  rabbit.email = "rogerrabbit@rmail.co.uk"
  rabbit.religion = Renalware::Patients::Religion.second!
  rabbit.language = Renalware::Patients::Language.first!
  rabbit.by = user
  rabbit.document = {referral:
    {referral_date: 1.week.ago,
      referral_type: "Urgent",
      referral_notes: "NB family friend of referrer",
      referring_physician_name: "Dr Jack L N Hyde"},
    admin_notes: "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
    pharmacist:
    {name: "P N Boots",
      address: {city: "London",
        postcode: "W1A 1AA",
        street_1: "Hallam St",
        organisation_name: "Boots Pharmacist"
      },
    telephone: "0201 555 1288"
    },
    next_of_kin:
      {name: "Sir Reginald Rabbit",
      address: {city: "London",
        postcode: "W1 A11",
        street_1: "221B Baker St"
        },
      telephone: "0201 555 7788"
      },
    district_nurse:
    {name: "Flo Nightingale",
    address:
      {city: "London",
      street_1: "333 Tooley St",
      street_2: "3rd Floor",
      organisation_name: "Southwark Nurses"
      },
      telephone: "0201 555 9999"
    },
    interpreter_notes: "Second language French",
    special_needs_notes: "Lorem ipsum dolor sit amet"
  }
  rabbit.save!

  log "Adding Primary Care Physician for Roger RABBIT"
  practice = Patients::Practice.first
  system_user = SystemUser.find

  primary_care_physician = Patients::PrimaryCarePhysician.find_or_create_by!(code: 'GP912837465') do |doc|
    doc.given_name = 'John'
    doc.family_name = 'Merrill'
    doc.email = 'john.merrill@nhs.net'
    doc.practitioner_type = 'GP'
    doc.practices << practice
  end

  rabbit.primary_care_physician = primary_care_physician
  rabbit.practice = practice
  rabbit.by = system_user
  rabbit.save!

  log "Adding Address for Roger RABBIT"
  rabbit.build_current_address(
    name: "M. Roger Rabbit",
    street_1: '123 South Street',
    city: 'Toontown',
    postcode: 'TT1 1HD',
    country: 'United Kingdom'
    )
  rabbit.by = system_user
  rabbit.save!

end
