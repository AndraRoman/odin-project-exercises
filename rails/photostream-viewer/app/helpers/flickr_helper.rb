module FlickrHelper

  def url(photo)
    "http://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}.jpg"
  end

  # search result by itself is a FlickRaw::ResponseList, not an array
  def user_photos(user_id, photo_count)
    flickr.photos.search(:user_id => user_id).to_a[0...photo_count]
  end

  def render_flickr_sidebar_widget(user_id)
    begin
      photos = user_photos(user_id, 12)
      if photos && !photos.empty?
        render :partial => 'flickr/sidebar_widget', :locals => { :photos => photos }
      else
        render :text => "Oops, that user seems to have no photos!"
      end
    rescue Exception
      render :partial => '/flickr/unavailable'
    end
  end

end
