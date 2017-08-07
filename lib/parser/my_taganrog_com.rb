module Parser
  class MyTaganrogCom < BaseScraper
    I18n.locale = :ru

    def parse
      p "start #{self.class.to_s}"

      count_pages = total_count_pages(site.url, paginate_container: 'div#main-wrapper div#main-content div.item-list ul.pager li.pager-last a')

      is_break = false
      count_pages.times do |i|
        links = get_page_links("#{site.url}/?page=#{i}", container_link: 'div#main-content div.block-content div.article h2.node-title a')

        links.each do |link|
          href = link.attr('href')
          data = get_news_data(
              "#{site.url}#{href}",
              site.url,
              container_title: 'div#main-wrapper div#main-content h1#page-title',
              container_image: 'div#main-content div.region-content div#block-system-main div.field-items p.rtecenter img',
              container_date: 'div#main-content div.footer span.pubdate',
              container_description: 'div#main-content div.region-content div#block-system-main div.field-items div.field-item p'
          )
          data[:news][:site_id] = site.id
          data[:news][:url] = "#{site.url[0...-1]}#{href}"
          data[:news][:region_id] = region.id
          data[:news][:date] = get_date(data[:news][:date]).to_datetime

          if data[:news][:date] > last_date
            save_news_and_photos(data[:news], data[:photos])
          else
            is_break = true
            break
          end
        end
        break if is_break
      end
      p "done #{self.class.to_s}"
    end



    def site
      @site ||= Site.find_by_name('mytaganrog.com')
    end

    def region
      @region ||= Region.find_by_name(I18n.t('regions.rostov_region'))
    end

    def last_date
      @last_date ||= site.news.last_date
    end
  end
end