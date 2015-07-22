require 'rails_helper'

feature 'Drafting a letter', js: true do

  background do
    create(:letter_description, text: 'Clinic letter')
    @doctor = create(:doctor)
    @practice = create(:practice)
    @doctor.practices << @practice
    @patient = create(:patient, :with_clinic_visits, doctor: @doctor, practice: @practice)
    @clinic_visit = @patient.clinic_visits.last

    login_as_super_admin
    visit new_clinic_visit_letter_path(clinic_visit_id: @clinic_visit.to_param)
  end

  scenario 'a clinic letter' do
    select 'Clinic letter', from: 'Description'
    select2 'Aneurin Bevan', from: '#letter_author_id'
    fill_in 'Message', with: 'Dear Dr. Goode, I am pleased to inform you that the latest clinic appointment went extremely well'

    click_on 'Save'

    expect(current_path).to eq(patient_letters_path(@patient))

    within('table.letters tbody tr:first-child') do
      expect(page).to have_content('Aneurin Bevan')
      expect(page).to have_content('Clinic letter')
      expect(page).to have_content('draft')
    end
  end

  scenario 'an invalid letter' do
    select2 'Aneurin Bevan', from: '#letter_author_id'

    click_on 'Save'

    expect(page).to have_content('Failed to save letter')
    expect(page).to have_content("Letter description can't be blank")
  end

  scenario 'a letter to a recipient other than the doctor or patient' do
    select 'Clinic letter', from: 'Description'
    select2 'Aneurin Bevan', from: '#letter_author_id'
    choose 'letter_recipient_other'
    fill_in 'other_recipient_address', with: '28 Newton Road, Torquay, Devon, TQ2 5BZ'
    fill_in 'Message', with: 'Dear Dr. Goode, I am pleased to inform you that the latest clinic appointment went extremely well'

    expect { click_on 'Save' }.to change(Address, :count).by(1)

    expect(current_path).to eq(patient_letters_path(@patient))
  end

  scenario 'a letter sent for review' do
    select 'Clinic letter', from: 'Description'
    select 'review', from: 'Status'
    select2 'Aneurin Bevan', from: '#letter_author_id'
    fill_in 'Message', with: 'Dear Dr. Goode, I am pleased to inform you that the latest clinic appointment went extremely well'

    click_on 'Save'

    within('table.letters tbody tr:first-child') do
      expect(page).to have_content('review')
    end
  end

  scenario 'a death notification' do

  end

  scenario 'a discharge notification' do

  end

  scenario 'a simple letter' do

  end
end
