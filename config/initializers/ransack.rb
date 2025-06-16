Ransack.configure do |config|
  config.add_predicate 'between',
    arel_predicate: 'between',
    formatter: proc { |v| start_date, end_date = *v.split(' - ').map { |date_string| DateTime.parse(date_string) }; Range.new(start_date.beginning_of_day, end_date.end_of_day) },
    validator: proc { |v| v.present? },
    type: :string

  config.add_predicate 'for_group',
    arel_predicate: :in,
    formatter: proc { |v| TagGroup.find_by(name: v).genres.pluck(:name) },
    validator: proc { |v| TagGroup.exists?(name: v) && TagGroup.find_by(name: v).genres.any? },
    compound: true,
    type: :string
end
