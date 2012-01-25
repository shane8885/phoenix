module ApplicationHelper
    def title
        base_title = "Garage Film Festival"
        if @title.nil?
            base_title
        else
            "#{base_title} - #{@title}"
        end
    end

    def logo
        image_tag("logo.gif", :alt => "MFF Logo" )
    end
end
