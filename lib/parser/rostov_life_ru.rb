module Parser
  class RostovLifeRu < BaseScraper
    I18n.locale = :ru

    def parse
      p "start #{self.class.to_s}"
      count_pages = total_count_pages("#{site.url}nenovosti/posts", paginate_container: 'article.b-content div.b-content__main div.b-pagination a:last')

      is_break = false
      count_pages.times do |i|
        links = get_page_links("#{site.url}/nenovosti/posts?page=#{i+1}", container_link: 'article.b-content div.b-content__main article.n-grid__column a')

        links.each do |link|
          href = link.attr('href')
          data = get_news_data(
              "#{site.url}#{href}",
              site.url,
              container_title: 'article.b-content h1.b-title',
              container_image: 'div.n-post-plate__pic2 span.img',
              container_date: 'article.b-content small.n-post-plate__panel__date',
              container_description: 'article.b-content section.n-post div.n-post__text'
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
      @site ||= Site.find_by_name('rostovlife.ru')
    end

    def region
      @region ||= Region.find_by_name(I18n.t('regions.rostov_region'))
    end

    def last_date
      @last_date ||= site.news.last_date
    end
  end
end