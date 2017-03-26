autoSubmit = do ->
	initAutoSubmit = ->
		$('[data-autosubmit]').each( ->
			$this = $(this)
			eventName
			if $this.is('[data-daterange]')
				eventName = 'apply.daterangepicker'
			else
				eventName = 'change'
			$this.on(eventName, ->
				$(this).closest('form').submit()
		))
	init = ->
		initAutoSubmit()
	{
		init: init
	}

autoSubmit.init()