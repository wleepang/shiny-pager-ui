(function() {  // IIF closure ...

/**
 * PagerUI JS object constructor
 *
 * @param target - selector string or jQuery object representation of pager-ui
 *    container node
 * @param {boolean} [locate] - flag to search for pager-ui container node.  Use
 *    only if target is not a DOM element with class "pager-ui"
 * @param {string} [direction] - direction to search for pager-ui container node
 *    if locate = true.  Options are "parent" (default) or "child".
 *
 * @returns {Object} A PagerUI object with properties:
 *  - root: the jQuery object for the pager-ui container
 *  - page_current: the jQuery object for the child input.page-current field
 *  - pages_total: the jQuery object for the chile input.pages-total field
 */
PagerUI = function(target, locate, direction) {
  var me = this;

  me.root = null;
  me.page_current = null;
  me.pages_total = null;

  if (typeof locate !== 'undefined' && locate) {
    if (direction === 'child') {
      me.root = $(target).find(".pager-ui").first();
    } else {
      // default direction is to search parents of target
      me.root = $(target)
        .parentsUntil(".pager-ui")
        .parent();  // travers to the root pager-ui node
    }
  } else {
    // pager-ui node is explicitly specified
    me.root = $(target);
  }

  if (me.root) {
    me.page_current = me.root.find(".page-current");
    me.pages_total = me.root.find(".pages-total");
  }

  return(me);
};

/**
 * Delegated event handlers
 */

// delegate a click event handler for pager page-number buttons
$(document).on("click", "button.page-num-button", function(event) {
  var $btn = $(event.target);
  var page_num = $btn.data("page-num");
  var $pager = new PagerUI($btn, true);

  $pager.page_current
    .val(page_num)
    .trigger("change");

});

$(document).on("click", "button.page-prev-button", function(event) {
  var $pager = new PagerUI(event.target, true);

  var page_current = parseInt($pager.page_current.val());

  if (page_current > 1) {
    $pager.page_current
      .val(page_current-1)
      .trigger('change');
  }

});

$(document).on("click", "button.page-next-button", function(event) {
  var $pager = new PagerUI(event.target, true);

  var page_current = parseInt($pager.page_current.val());
  var pages_total = parseInt($pager.pages_total.val());

  if (page_current < pages_total) {
    $pager.page_current
      .val(page_current+1)
      .trigger('change');
  }

});

// delegate a change event handler for pages-total to draw the page buttons
$(document).on("change", "input.pages-total", function(event) {
  var $pager = new PagerUI(event.target, true);
  pagerui_render($pager.root);
});

// delegate a change event handler for page-current to draw the page buttons
$(document).on("change", "input.page-current", function(event) {
  var $pager = new PagerUI(event.target, true);
  pagerui_render($pager.root);
});



/**
 * Render pager-ui buttons
 * @param target - selector string or jQuery object representation of pager-ui
 *    container node
 * @param {number} [page_current] - current page number (1-based). If undefined
 *    the value of a input element that is a child of target with class
 *    .page-current is used.
 * @param {number} [pages_total] - total number of pages. If undefined
 *    the value of a input element that is a child of target with class
 *    .pages-total is used.
 *
 * Requires Underscore.js
 *
 * @returns Nothing
 */
pagerui_render = function(target, page_current, pages_total) {
  var $target = $(target);
  var $btn_prev = $target.find(".page-prev-button");
  var $btn_next = $target.find(".page-next-button");
  var $btn_group = $target.find(".page-button-group-numbers");

  if (typeof page_current === "undefined") {
    page_current = parseInt($target.find("input.page-current").val());
  }

  if (typeof pages_total === "undefined") {
    pages_total = parseInt($target.find("input.pages-total").val());
  }

  // reset prev/next to an enabled state
  $btn_prev.prop("disabled", false);
  $btn_next.prop("disabled", false);

  // clear any pre-existing buttons
  $btn_group.html("");

  // test if anything should be rendered at all
  if (!pages_total) {
    $btn_prev.prop("disabled", true);
    $btn_next.prop("disabled", true);
    $btn_group.append(
      $("<span />").addClass("text-muted").html("no pages")
    );
    return;
  }

  if (page_current == 1) {
    $btn_prev.prop("disabled", true);
  }

  if (page_current == pages_total) {
    $btn_next.prop("disabled", true);
  }

  // create a button template
  var $btn_tpl = $("<button />").addClass('btn btn-default');

  // create a "..." spacer button
  var $btn_dots = $btn_tpl.clone()
    .attr('disabled', 'disabled')
    .html('...');

  // determine what range (hi/med/low) the current page is in
  var show_lo_dots = !_.contains(_.range(1,4), page_current);
  var show_hi_dots = !_.contains(_.range(pages_total-2, pages_total+1), page_current);

  // create an array of all page number buttons to slice for button sets
  var $btn_nums = [];
  for (var i=1; i<=pages_total; i++) {
    var $btn_num = $btn_tpl.clone()
      .attr('data-page-num', i)
      .addClass('page-num-button')
      .html(i);

    if (i == page_current) {
      $btn_num
        .attr('disabled', 'disabled')
        .removeClass('btn-default')
        .addClass('btn-info');
    }

    $btn_nums.push($btn_num);
  }

  // utility functions for rendering button sets
  // - a numeric comparison function for Array.sort()
  // - an iteratee for _.map to retrieve page num buttons
  var NumericAscending = function(a,b){return a-b};
  var GetPageNumButton = function(page_num){return $btn_nums[page_num - 1]};

  // render the page number buttons
  if (pages_total <= 10) {
    // show all buttons
    $btn_group.append($btn_nums);

  } else {
    var $btn_set = [];
    if ( show_lo_dots &&  show_hi_dots) {
      // mid-range button set
      // [1] ... [p-1][p][p+1] ... [N]
      $btn_set = $btn_set
        .concat([
          $btn_nums[0],
          $btn_dots.clone()
        ])
        .concat(_.map(
          _.range(page_current-1, page_current+2),  // [-1,+1] current page
          GetPageNumButton
        ))
        .concat([
          $btn_dots.clone(),
          $btn_nums[pages_total-1]
        ]);

    } else
    if (!show_lo_dots &&  show_hi_dots) {
      // lo-range button set
      // [1][2][3] ... [N]
      $btn_set = $btn_set
        .concat(_.map(
          _.union(_.range(1, 4), [page_current + 1])
            .sort(NumericAscending),  // [1, current page + 1]
          GetPageNumButton
        ))
        .concat([
          $btn_dots.clone(),
          $btn_nums[pages_total-1]
        ]);

    } else
    if ( show_lo_dots && !show_hi_dots) {
      // hi-range button set
      // [1] ... [N-2][N-1][N]
      $btn_set = $btn_set
        .concat([
          $btn_nums[0],
          $btn_dots.clone()
        ])
        .concat(_.map(
          _.union(_.range(pages_total-2, pages_total+1), [page_current - 1])
            .sort(NumericAscending),  // [current page - 1, pages_total]
          GetPageNumButton
        ));

    }

    $btn_group.append($btn_set);
  }

};



/**
 * Shiny Registration
 */

var pageruiInputBinding = new Shiny.InputBinding();
$.extend(pageruiInputBinding, {
  find: function(scope) {
    return( $(scope).find(".pager-ui") );
  },
  initialize: function(el) {
    // called when document is ready using initial values defined in ui.R
    // documented in input_binding.js but not in docs (articles)
    pagerui_render(el);
  },
  // getId: function(el) {},
  getValue: function(el) {
    return({
      page_current: parseInt($(el).find(".page-current").val()),
      pages_total: parseInt($(el).find(".pages-total").val())
    });
  },
  setValue: function(el, value) {
    $(el).find(".page-current").val(value.page_current);
    $(el).find(".pages-total").val(value.pages_total);
  },
  receiveMessage: function(el, data) {
    // This is used for receiving messages that tell the input object to do
    // things, such as setting values (including min, max, and others).
    // documented in input_binding.js but not in docs (articles)
    if (data.page_current) {
      $(el).find(".page-current")
        .val(data.page_current)
        .trigger('change');
    }

    if (data.pages_total) {
      $(el).find(".pages-total")
        .val(data.pages_total)
        .trigger('change');
    }
  },
  subscribe: function(el, callback) {
    $(el).on("change.pageruiInputBinding", function(e) {
      callback(true);
    });
    $(el).on("click.pageruiInputBinding", function(e) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".pageruiInputBinding");
  },
  getRatePolicy: function() {
    return("debounce");
  }
});

Shiny.inputBindings
  .register(pageruiInputBinding, "oddhypothesis.pageruiInputBinding");

}()); // End IIF Closure
