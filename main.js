$(function () {
	$('#char_loader').animate({
		opacity: 1,
		top: "+=25",
	}, 8000, function () {
	});
	setTimeout(() => {
		$('#welcomeBody').fadeOut(900)
	}, 10000)
});

window.addEventListener("message", function (event) {
	var data = event.data;

	if (data.action == "updateSpeed") {
		$('.speed-text').text(`${Math.floor(data.speed)} MPH`)
	}
	if (data.action == "updateFuel") {
		$('.progress').css('width', data.fuel + '%')
	}

	if (data.action == "show") {
		$('.container').fadeIn()
		$('.container').css('left', data.mapLoc.x + 'px')
		$('.container').css('top', data.mapLoc.y + 'px')
		$('.container').css('width', data.mapLoc.width + 'px')
		$('.speed-text').css('font-size', Math.min(data.mapLoc.width / 15, 18) + 'px')
	}

	if (data.action == "hide") {
		$('.container').fadeOut()
	}
})