module Nanoc3::Helpers::Blogging
  
  # patch url_for and atom_tag_for to omit .html

  old_url_for = instance_method(:url_for)

  define_method(:url_for) do |item|
    url = old_url_for.bind(self).(item)
    url.gsub(/\.html$/, '')
  end

  old_atom_tag_for = instance_method(:atom_tag_for)

  define_method(:atom_tag_for) do |item|
    tag = old_atom_tag_for.bind(self).(item)
    tag.gsub(/\.html$/, '')
  end

end
