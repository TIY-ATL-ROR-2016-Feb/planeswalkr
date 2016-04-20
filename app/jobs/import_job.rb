class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(data, image_dir)
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
      ## send an email maybe with a link to the new set
    else
      puts "Errors during saving: #{@set.errors.full_messages}"
      ## send an email, saying why we couldn't save
    end
  end
end
