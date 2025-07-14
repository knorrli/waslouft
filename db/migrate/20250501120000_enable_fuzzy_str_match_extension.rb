class EnableFuzzyStrMatchExtension < ActiveRecord::Migration[8.0]
  def change
    enable_extension('fuzzystrmatch')
  end
end
