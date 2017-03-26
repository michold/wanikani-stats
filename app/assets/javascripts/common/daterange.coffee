dateRange = do ->

	getDates = (input)->
		text = input.val()
		if text.length > 0
			textDates = text.split(" - ")
			dates = [
				moment(textDates[0], 'DD.MM.YYYY')
				moment(textDates[1], 'DD.MM.YYYY')
			]
		else
			dates = [
				moment().subtract(7, 'days')
				moment()
			]
		dates
	initDateRangePicker = ->
		$('input[data-daterange]').each(->
			$this = $(this)
			dates = getDates($this)
			$this.daterangepicker({
				startDate: dates[0]
				endDate: dates[1]
				locale: {
				  format: 'DD.MM.YYYY'
				  firstDay: 1
				  separator: " - "
				}
			})
		)
	init = ->
		initDateRangePicker()
	{
		init: init
	}

dateRange.init()