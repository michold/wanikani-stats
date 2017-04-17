BindClick = do ->
	bindClick = ->
		$('[data-click]').on('click', (event)-> 
			$this = $(this)
			selector = $this.data('click')
			$toClick = $this.find(selector)
			if !$(event.target).is($toClick) 
				# jQuery click doesn't trigger on a[href] if there are no handlers bound to it
				# vanilla js does the job
				$toClick[0].click()
				
		)
		
	init = ->
		bindClick()
	{
		init: init
	}

BindClick.init()