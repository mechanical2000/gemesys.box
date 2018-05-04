module Agilibox::FontAwesomeHelper
  def icon(id, fa_style: nil, size: nil, spin: false, **options)
    id = id.to_s.tr("_", "-").to_sym

    if fa_style.nil?
      fa_style = Agilibox::FontAwesomeHelper.database.dig(id, :styles).to_a.first
    end

    css_classes = options.delete(:class).to_s.split(" ")
    css_classes << "icon"
    css_classes << "fa-#{id}"
    css_classes << "fa#{fa_style.to_s[0]}"
    css_classes << "fa-#{size}" if size
    css_classes << "fa-spin" if spin

    attributes = options.merge(class: css_classes.sort.join(" ")).sort.to_h

    content_tag(:span, attributes) {}
  end

  class << self
    def database
      @database ||= YAML.safe_load(database_yml).deep_symbolize_keys
    end

    def database_path
      Rails.root.join("tmp", "fa_database_#{version}.yml")
    end

    def database_yml
      download_database! unless File.size?(database_path)
      File.read(database_path)
    end

    def download_database!
      require "open-uri"
      url  = "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/advanced-options/metadata/icons.yml"
      data = URI.parse(url).open.read
      File.write(database_path, data)
    end

    def version
      require "font_awesome/sass/version"
      FontAwesome::Sass::VERSION
    end
  end # class << self
end