$(function(){
    $('#tabs').tabs();
    $('#popout').click(function (ev) {
	var url = $(this).attr('href');
	var name = 'Tempus';
	var size = 'width=850,height=650';
	window.open(url, name, size);
	ev.preventDefault();
    });
});
