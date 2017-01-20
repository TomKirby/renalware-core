# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "APD"
  inflect.acronym "CAPD"
  inflect.acronym "CC"
  inflect.acronym "CCs"
  inflect.acronym "CM"
  inflect.acronym "DNA"
  inflect.acronym "EDTA"
  inflect.acronym "ESRF"
  inflect.acronym "HD"
  inflect.acronym "HDF"
  inflect.acronym "HL7"
  inflect.acronym "MDM"
  inflect.acronym "PD"
  inflect.acronym "PET"
  inflect.acronym "PRD"
  inflect.acronym "XHR"
  inflect.acronym "GP"
end
