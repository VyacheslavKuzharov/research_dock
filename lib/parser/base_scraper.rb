module Parser
  class BaseScraper

    def total_count_pages(url, options ={})
      str = agent.get(url).at(options[:paginate_container]).attr('href')
      str.scan(/\d+/).last.to_i rescue 1
    end

    def get_page_links(url, options ={})
      agent.get(url).search(options[:container_link])
    end

    def get_news_data(url, domain, options = {})
      info = Hash.new
      info[:news] = {}
      info[:photos] = {}
      page = agent.get(url)

      info[:news][:title] = page.search(options[:container_title]).text.strip
      info[:news][:date] = page.search(options[:container_date]).text.strip
      info[:news][:description] = page.search(options[:container_description]).text.strip.delete("\r").delete("\n").delete("\t")
      info[:news][:city_id] = get_city_id(info[:news][:title])

      image_node = page.search(options[:container_image])

      if !image_node.blank? && !image_node.attr('class').nil? && image_node.attr('class').value  == 'img'
        span_img = image_node.attr('style').value
        info[:news][:remote_image_url] = span_img.slice!(/http.*jpg/)
        info[:photos][:remote_photo_url] = [ info[:news][:remote_image_url] ]
      elsif !image_node.blank?
        info[:news][:remote_image_url] = get_image_url(image_node.attr('src').value, domain)

        nodes = page.search(options[:container_image])
        info[:photos][:remote_photo_url] = []
        nodes.each do |node|
          link = get_image_url(node.attr('src'), domain)
          info[:photos][:remote_photo_url] << link
          info[:photos]
        end
      end

      info
    end


    # not best solution
    def get_city_id(str)
      match_region = str.match(/ростовская/i) || str.match(/ростовскую/i) || str.match(/ростовской/i) || str.match(/таганрогская/i) || str.match(/таганрогскую/i) || str.match(/таганрогской/i) || str.match(/таганрогом/i) || str.match(/ростовом/i)
      match_data = (str.match(/ростов/i) || str.match(/таганрог/i))
      return if match_region

      City.find_by_name(match_data.to_s).id rescue nil
    end

    # really not best solution
    def get_image_url(str, domain)
      ary = str.split('/')
      if ary[0] == ''
        domain + str
      else
        str
      end
    end

    def get_date(str)
      ary = str.split
      day = ary.delete_at(0)
      month = ary.delete_at(1)

      rus_day_index = rus_weekdays.index(day)
      rus_month_index = rus_month.index(month)

      ary.insert(0, eng_weekdays[rus_day_index]) if rus_day_index
      ary.insert(2, eng_month[rus_month_index]) if rus_month_index
      ary.join(' ').to_datetime
    end

    def rus_weekdays
      %w(Понедельник Вторник Среда Четверг Пятница Суббота Воскресение)
    end

    def eng_weekdays
      %w(Monday Tuesday Wensday Thusday Friday Saturday Sunday)
    end

    def rus_month
      %w(января февраля марта апреля мая июня июля августа сентября октября ноября декабря)
    end

    def eng_month
      %w(January February Mart April May June July August September October November December)
    end



    private

    def agent
      @agent ||= Mechanize.new
    end

    def save_news_and_photos(news, photos)
      record = News.create!(news)
      photos[:remote_photo_url].each { |photo| record.photos.create(remote_photo_url: photo) } unless photos[:remote_photo_url].nil?
      p "news and photos for: #{record.title}, is saved..."
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Parser::BaseScraper ERROR! Message: #{e}."
    end
  end
end