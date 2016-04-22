class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(data, image_dir, user)
    ActiveRecord::Base.transaction do
      @set = CardSet.new(name: data["name"],
                         set_type: data["type"],
                         code: data["code"],
                         release_date: DateTime.parse(data["releaseDate"]),
                         block: data["block"],
                         image_dir: image_dir)
      @cards = data["cards"].map do |card|
        Card.import_from_json(card)
      end
      @set.cards = @cards
      @set.save
    end
    if @set && @set.persisted?
      puts "Set imported successfully for #{@user.full_name} (#{@user.email})."
      ## send an email maybe with a link to the new set
    else
      set_errors = @set.errors.full_messages.uniq.join(", ")
      card_errors = @set.cards.flat_map { |x| x.errors.full_messages }.uniq
      puts "Failed to import. Set errors include '#{set_errors}' and card errors included '#{card_errors}'."
      ## Send an email with the errors.
    end
  end
end
