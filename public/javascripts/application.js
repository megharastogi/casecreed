var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-12366970-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();


$(document).ready(function(){
	$('#cssdropdown li.headlink').hover(
		function() { $('ul', this).css('display', 'block'); },
		function() { $('ul', this).css('display', 'none'); });
	});


	$(document).ready(function() {

		$("a[rel=pop_up]").fancybox({
			'overlayShow'	: false,
			'transitionIn'	: 'elastic',
			'transitionOut'	: 'elastic'
		})
	});

	$(document).ready(function() {

		$('#available_timing_option_1').change(function() {
			if($(this).is(':checked'))  {
				$('#date_to').hide();
				$('#days').hide();

			}
		});

		$('#available_timing_option_2').change(function() {
			if($(this).is(':checked'))  {
				$('#date_to').show();
				$('#days').hide();

			}
		});

		$('#available_timing_option_3').change(function() {
			if($(this).is(':checked'))  {
				$('#date_to').show();
				$('#days').show();

			}
		});
	});


	var DatePicked = function() {
		var from = $("#available_timing_date_from");
		var to = $("#available_timing_date_to");
		var days = $("#number_of_days");

		var triggeringElement = $(this);

		var fromDate = from.datepicker("getDate");

		var minArrivalDate = new Date();
		if (fromDate != null) {
			minArrivalDate.setDate(fromDate.getDate() + 1);
		} else {
			minArrivalDate.setDate(minArrivalDate.getDate() + 1);
		}
		to.datepicker('option', 'minDate', minArrivalDate);

		var toDate = to.datepicker("getDate");

		if (fromDate != null && toDate != null && triggeringElement.attr("id") != "number_of_days") {
			var oneDay = 1000*60*60*24;
			var difference = Math.ceil((toDate.getTime() - fromDate.getTime()) / oneDay);
			days.val(difference);
		} else if (fromDate != null && triggeringElement.attr("id") == "number_of_days") {
			var daysEntered = parseInt(days.val());
			if (daysEntered >= 2) {
				var newArrivalDate = new Date();
				newArrivalDate.setDate(fromDate.getDate() + daysEntered);
				to.datepicker("setDate", newArrivalDate);
			} else {
				alert("Must be greater than 2.");
			}
		}
	}
	$(function() {
	if ($("#available_timing_date_from").is('*') ){  //
		$('#available_timing_date_from').datepicker({ minDate: 0,
			onSelect: DatePicked
		});
		$("#available_timing_date_to").datepicker({
			onSelect: DatePicked
		});
		$("#number_of_days").change(DatePicked);
		DatePicked();
    }
	});

$(function() {
    $('#user_lawyer_detail_attributes_description').wysiwyg();
});


$(function() {
    $('#user_lawyer_detail_attributes_professional_membership').wysiwyg();
});

$(function() {
    $('#user_lawyer_detail_attributes_awards').wysiwyg();
});

$(function() {
    $('#user_lawyer_detail_attributes_education').wysiwyg();
});

$(function() {
    $('#user_lawyer_detail_attributes_professional_statement').wysiwyg();
});

$(function() {
    $('#user_lawyer_detail_attributes_area_served').wysiwyg();
});

function get_timings_lawyer_show_page(date_from,lawyer_id)
{
    jQuery.ajax({
			data: 'date=' + date_from + "&lawyer_id="+lawyer_id,
			dataType: 'script',
			type: 'get',
			url: "/lawyers/get_timings_one_lawyer"
		});
}

$(document).ready(function() {
	$('#lawyer_category_parent_category').change(function() {
		jQuery.ajax({
			data: 'id=' + $('#lawyer_category_parent_category').val(),
			dataType: 'script',
			type: 'post',
			url: "/categories/get_sub_categories"
		});
	});
});


$(function() {
win = $(window);
element = $('#lawyer_top');

if (element.length) {                // <-- Make sure element exists
    win.scroll(function () {         // <-- When scrolling do the following
        if (win.scrollTop() > 400) { // <-- Adjust number.  Explanation to follow
            element.css({'position':'fixed', 'top':'0px'});
            element.addClass('dynamic_header');
        } else {
            element.css({'position':'relative', 'top':'auto'});
            element.removeClass('dynamic_header');
        }
    });
}
});

