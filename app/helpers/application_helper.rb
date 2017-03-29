module ApplicationHelper
	def progress_bar(percent, labels = [])
	  haml_tag :div, :class => "progress" do
		  haml_tag :div, :class => "progress-bar", style: "width:#{percent}%;", 'aria-valuenow' => percent do
		    if percent > 0
		      haml_concat percent
		    end
		  end
    end
    if !labels.empty?
		  haml_tag :div, :class => "progress-labels" do
			  haml_tag :div, :class => "progress-label-left" do
			    haml_concat labels[0]
			  end
			  haml_tag :div, :class => "progress-label-right" do
			    haml_concat labels[1]
			  end
		  end
    end
  end
end
