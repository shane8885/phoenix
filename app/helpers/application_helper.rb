module ApplicationHelper
    def title
        base_title = "My Film Festival"
        if @title.nil?
            base_title
        else
            "#{base_title} | #{@title}"
        end
    end

    def logo
        image_tag("logo.jpg", :alt => "MFF Logo", :size => "40x40" )
    end
end
