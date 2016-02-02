require "travel_advice_edition"
require "gds_api/asset_manager"
require "gds_api/panopticon"
require "csv"

class TravelAdviceEdition

  after_create do
    register_with_panopticon if version_number == 1
  end

  state_machine.after_transition to: :published do |edition, transition|
    edition.register_with_panopticon
  end


  def csv_synonyms
    CSV.generate_line(self.synonyms).chomp
  end

  def csv_synonyms=(value)
    # remove spaces between commas and value
    # which prevents parse_line erroring
    value.gsub!(/",\s+"/, '","')
    synonyms = CSV.parse_line(value) || []
    self.synonyms = synonyms.map(&:strip).reject(&:blank?)
  end

  def register_with_panopticon
    details = RegisterableTravelAdviceEdition.new(self)
    registerer = GdsApi::Panopticon::Registerer.new(owning_app: 'travel-advice-publisher', rendering_app: "multipage-frontend", kind: 'travel-advice')
    registerer.register(details)
  end

  private
    def self.attaches(*fields)
      fields.map(&:to_s).each do |field|
        after_initialize do
          instance_variable_set("@#{field}_has_changed", false)
          @attachments ||= {}
        end
        before_save "upload_#{field}".to_sym, :if => "#{field}_has_changed?".to_sym

        define_method(field) do
          unless self.send("#{field}_id").blank?
            @attachments[field] ||= TravelAdvicePublisher.asset_api.asset(self.send("#{field}_id"))
          end
        end

        define_method("#{field}=") do |file|
          instance_variable_set("@#{field}_has_changed", true)
          instance_variable_set("@#{field}_file", file)
        end

        define_method("#{field}_has_changed?") do
          instance_variable_get("@#{field}_has_changed")
        end

        define_method("remove_#{field}=") do |value|
          unless value.blank?
            self.send("#{field}_id=", nil)
          end
        end

        define_method("upload_#{field}") do
          begin
            response = TravelAdvicePublisher.asset_api.create_asset(:file => instance_variable_get("@#{field}_file"))
            self.send("#{field}_id=", response.id.match(/\/([^\/]+)\z/) {|m| m[1] })
          rescue GdsApi::BaseError
            errors.add("#{field}_id".to_sym, "could not be uploaded")
          end
        end
        private "upload_#{field}".to_sym
      end
    end
    attaches :image, :document

end
