ajaxRefresh = do ->
	initAjaxRefresh = ->
		$('[data-ajax-refresh]').each( ->
			$this = $(this)
			url = $this.data('url')
			$icon = $this.find('.glyphicon')
			console.log($icon)
			$this.on('click', ->
				$icon.addClass("glyphicon-spin")
				$.ajax(
				  url: url
				  success: ->
				    window.location.reload(false)
				).done( ->
						$icon.removeClass("glyphicon-spin")
				)
		))
	init = ->
		initAjaxRefresh()
	{
		init: init
	}

ajaxRefresh.init()