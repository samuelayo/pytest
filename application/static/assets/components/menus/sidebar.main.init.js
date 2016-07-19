(function($)
{

	// handle menu toggle button action
	

	$('[data-toggle="navbar-color"] a').on('click', function(e){
		e.preventDefault();
		
		if ($(this).is('.active'))
			return;

		if ($(this).is('.color-white'))
			$('.navbar.main').removeClass('navbar-inverse navbar-blue navbar-primary');

		if ($(this).is('.bg-primary'))
		{
			$('.navbar.main').removeClass('navbar-inverse navbar-blue').addClass('navbar-primary');
			$('#menu').addClass('sidebar-brand-primary');
		}
		else
			$('#menu').removeClass('sidebar-brand-primary');

		if ($(this).is('.color-blue'))
		{
			$('.navbar.main').removeClass('navbar-inverse navbar-primary').addClass('navbar-blue');
			$('#menu').addClass('sidebar-blue');
			$('html').addClass('layout-blue');
		}

		if ($(this).is('.color-inverse'))
		{
			$('.navbar.main').removeClass('navbar-blue navbar-primary').addClass('navbar-inverse');
			$('#menu').removeClass('sidebar-blue');
			$('html').removeClass('layout-blue');
		}

		$(this).parent().find('.active').removeClass('active');
		$(this).addClass('active');
	});

	if ($('.sidebar-blue').length)
	{
		$('html').addClass('layout-blue');
		$('.navbar.main').removeClass('navbar-inverse').addClass('navbar-blue');
		$('#toggleNavbarColor a.color').removeClass('active').find('.color-blue').addClass('active');
	}
	if ($('.sidebar-blue.sidebar-brand-primary').length)
	{
		$('.navbar.main').removeClass('navbar-blue').addClass('navbar-primary');
		$('#toggleNavbarColor a.color').removeClass('active').find('.bg-primary').addClass('active');
	}
})(jQuery);