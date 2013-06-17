class Film < ActiveRecord::Base
  validates_presence_of :name, :year, :director, :synopsis

  has_many :reviews

  has_many :archives, :dependent=>:destroy, :as => :attachable

  has_many :film_multimedia_libraries, :class_name => "FilmMultimediaLibrary", :dependent => :destroy
  has_many :multimedia_libraries, :through => :film_multimedia_libraries, :source => "multimedia_library"

  #searchable do
  #  text :name
  #  text :year
  #  text :director
  #end

end
