class BuildLocaleYmlJob < ActiveJob::Base
  include ActiveJobStatus::Hooks
  queue_as :default

  def perform(content, language)
    doc = YAML.load(content)
    puts "------------BuildLocaleYmlJob---------Start"

    Translation.where(:locale => language.downcase).destroy_all

    doc.to_enum(:walk).each do |path, key, value|
      strvalue = value.is_a?(String) ? value : value.inspect
      trans_item = Translation.new
      trans_item.locale = language.downcase
      path_str = path.join(".")
      path_dot_index = path_str.index('.') + 1
      trans_item.key = "#{path_str[path_dot_index..-1]}.#{key}"
      trans_item.value = value
      trans_item.save
    end
    puts "------------BuildLocaleYmlJob---------Done"
  rescue => e
    puts "------------BuildLocaleYmlJob---------Error"
    puts e
  end
end
