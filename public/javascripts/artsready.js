$(function(){
	// $("select, input[type='checkbox'], input[type='radio'], input:file").uniform();
	$("input[type='checkbox'], input:file").uniform();
	
	$(".questionnaire tbody, .resource tbody").hide().eq(0).show();

  $.tablesorter.addParser({
	id: 'rfc822TimeOrNever',

	format: function (s) {
	  return Date.parse(s) || 0;
	},
	type: 'numeric'
  });

  $(".wrapper table").tablesorter({
	//debug: true
  });

	$('.datepicker').datepicker({
	  showOn: 'both',
	  buttonImage: '/images/calendar.gif',
	  changeMonth: true,
	  changeYear: true,
	  dateFormat: "yy-mm-dd",
	});
	
});


$("#crisis-activate").live('click', function(event) {
	// alert('Crisis Activated!');
});
$("#crisis-deactivate").live('click', function(event) {
	return confirm('Are you sure?');	
});

// Hide buddies list on the crisis page until the "Private" option is chosen

var buddiesList = function(visibilityToggle, visibilityInput){
  $(function($) {
    var $buddiesList = $("#battle-buddies-list");
    var $visibility = $("#"+visibilityToggle)
    if ($visibility.length) {
      if (!$visibility.attr("checked")){
        $buddiesList.hide();
      }
    }

    $(visibilityInput).click(function(){
      if (this.id == visibilityToggle){
        $buddiesList.show();
      }
      else {
        $buddiesList.hide();
      }
    });
  });
}

buddiesList("crisis_visibility_private",
            "#crisis-visibility input[name='crisis[visibility]']");
buddiesList("article_visibility_shared",
            "#article-visibility input[name='article[visibility]']");


$(".skip-question").live('click', function(event) {
	$(this).closest('form').submit();
  return false;
});

$(".reconsider-question").live('click', function(event) {
  $(this).closest('form').submit();
  return false;
});

// Resources navigation toggle
$(".side-nav li a").live('click', function(event) {
	// Keeps the link from actually doing anything
	if (event.preventDefault) {
		event.preventDefault();
	} else {
		event.returnValue = false;
	}
	el = $(this);
	
	$(".side-nav li").removeClass("active");
	el.parent("li").addClass("active");
	$(".side-nav-panels tbody").hide().eq( el.parent("li").index() ).show();
});

// Action items "add resource" button
$(".add-resource-button").live('click', function(event) {
	event.preventDefault(); // Keeps the link from actually doing anything

	var title = $(".add-resource .title input").val();
	var source = $(".add-resource .source input").val();
	var description = $(".add-resource .description input").val();
	var tags = $(".add-resource .tags input").val();

	$(".resource tbody:last-child tr:last-child").clone().appendTo( $(".resource") );
	$(".resource tbody tr:last-child td.title").html(in_p(title));
	$(".resource tbody tr:last-child td.source").html(in_p(source));
	$(".resource tbody tr:last-child td.description").html(in_p(description));
	$(".resource tbody tr:last-child td.tags").html(in_p(tags));
	$(".resource tbody tr:last-child td.updated").html(in_p('today'));
});

function in_p(value) {
	return "<p>" + value + "</p>"
}

// Submit AJAX on questionnaire when select boxes are changed
$('.questionnaire select').live('change', function(event) {
	var selectValue = $(this).val();
	var selectParent = $(this).closest("tr");
	
	// AJAX Call here, put the following inside the success callback
	selectParent.after('<span class="uploading">hi</span>');
	$(".uploading").animate({
			opacity: 1
		}, 250)
		.delay(1000)
		.animate({
			opacity: 0
		}, 250, function() {
			$(".uploading").remove();
	});
	
});

// Submit AJAX on questionnaire when content changes
$('.actionitems select').live('change', function(event) {
	var selectParent = $(this).closest("tr");
	updateQuestionnaire(selectParent);
});
// Event listeners for editable regions
$('.actionitems .editable').live('focus', function() {
	  before = $(this).html();
	}).live('blur keyup paste', function() { 
	  if (before != $(this).html()) { $(this).trigger('change'); }
});
// Using above listeners, if content changes, update
$('.actionitems .editable').live('blur', function() {
	var selectParent = $(this).closest("tr");
	updateQuestionnaire(selectParent);
});

function updateQuestionnaire(selectParent) {
	var actionItem = selectParent.find(".item").text();
	var actionAssigned = selectParent.find(".assigned option:selected").val();
	var actionDue = selectParent.find(".due input").val();
	var actionPriority = selectParent.find(".priority option:selected").val();
	//alert(actionItem+", "+actionAssigned+", "+actionDue+", "+actionPriority);
	
	// AJAX Call here, put the following inside the success callback
	selectParent.after('<span class="uploading">hi</span>');
	$(".uploading").animate({
			opacity: 1
		}, 250)
		.delay(1000)
		.animate({
			opacity: 0
		}, 250, function() {
			$(".uploading").remove();
	});
	
}

// For questions on assess
$('.button.respond, .question .prompt, .answers .button').live('click', function() {
	toggleQuestion(this);
	var question = $(this).parents('.question');
	question.removeClass('not-applicable');
	question.find('.reconsider').remove();
	if (!question.hasClass('answered')) {
		question.find('.respond').show(); 
	}
	return false;
});

$('form.edit_answer input[type=radio]').live('change', function() {
  var $form = $(this).closest('form');
  $form.find('.save-response').attr('disabled',
    $form.find('input[type=radio]:checked').length < 2);
});

$(function() {
  $('form.edit_answer .save-response').attr('disabled', true);
});

function toggleQuestion(button) {
	var question = $(button).parents('.question');
  question.find('.answer').toggle();
  question.find('.explain').toggle();
}

$('.critical-function-toggle input[type=checkbox]').live({
  change: function() {
    $(this).closest('form').submit();
  }
});

var manageInfoBubble;

// Tooltips
$(function () {
  // options
  var distance = 10;
  var time = 250;
  var hideDelay = 100;

  manageInfoBubble = function() {	
    var hideDelayTimer = null;

    // tracker
    var beingShown = false;
    var shown = false;
    
    var trigger = $('.info-bubble-trigger', this);
    var popup = $('.info-bubble-text', this).css('opacity', 0);

    // set the mouseover and mouseout on both element
    $([trigger.get(0), popup.get(0)]).mouseover(function () {
      // ignore spurious mouseovers while the item is hidden
      if (trigger.filter(':visible').length == 0) return;

      // stops the hide event if we move from the trigger to the popup element
      if (hideDelayTimer) {clearTimeout(hideDelayTimer);}

      // don't trigger the animation again if we're being shown, or already visible
      if (beingShown || shown) {
        return;
      } else {
        beingShown = true;

        // reset position of popup box
        popup.css({
		  top: 33,
          left: 80,
		  marginLeft: -100,
          display: 'block' // brings the popup back in to view
        })

        // (we're using chaining on the popup) now animate it's opacity and position
        .animate({
          top: '-=' + distance + 'px',
          opacity: 1
        }, time, 'swing', function() {
          // once the animation is complete, set the tracker variables
          beingShown = false;
          shown = true;
        });
		$(this).closest('tr').siblings('tr').find('.info-bubble').fadeOut();
      }
    }).mouseout(function () {
      // reset the timer if we get fired again - avoids double animations
      if (hideDelayTimer) {clearTimeout(hideDelayTimer);}
      
      // store the timer so that it can be cleared in the mouseover if required
      hideDelayTimer = setTimeout(function () {
        hideDelayTimer = null;
        popup.animate({
          top: '-=' + distance + 'px',
          opacity: 0
        }, time, 'swing', function () {
          // once the animate is complete, set the tracker variables
          shown = false;
          // hide the popup entirely after the effect (opacity alone doesn't do the job)
          popup.css('display', 'none');
        });
      }, hideDelay);
		
		$(this).closest('tr').siblings('tr').find('.info-bubble').fadeIn();
    });
  };

  $('.info-bubble').each(manageInfoBubble);
});

