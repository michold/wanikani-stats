selectpicker = do ->

	initSelectpicker = ->
		$('.selectpicker').selectpicker()
		
	init = ->
		initSelectpicker()
	{
		init: init
	}

selectpicker.init()