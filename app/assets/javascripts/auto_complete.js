$(document).on('ready ajaxSuccess', function() {

  $.ui.autocomplete.prototype._renderItem = function (ul, item) {
    var t = String(item.value).replace(
      new RegExp(this.term, "gi"),
      "<span class='ui-state-highlight'>$&</span>"
    );
    return $("<li></li>")
      .data("item.autocomplete", item)
      .append("<a>" + t + "</a>")
      .appendTo(ul);
  };


  $("[data-autocomplete-source]").each(function() {
    var url = $(this).data("autocomplete-source");
    var parentForm = $(this).closest("form");
    var target = parentForm.find($(this).data("autocomplete-rel"));
    $(this).autocomplete({
      appendTo: $(parentForm), // appending to the form resolves issues with autocomplete hidden in modals
      minLength: 2,
      autoFocus: true,
      source: function(request,response) {
        $.ajax({
          url: url,
          data: { term: request.term },
          success: function(data) {
            var list = $.map(data, function(patient) {
              return {
                label: patient.label,
                id: patient.id
              };
            });
            response(list);
          },
          error: function(jqXHR, textStatus, errorThrown) {
            var msg = "An error occurred.  Please contact an administrator.";
            response({ label: msg, id: 0});
          }
        });
      },
      search: function(event, ui) {
        $(target).val("");
      },
      select: function(event, ui) {
        $(target).val(ui.item.id);
      }
    });
  });

  $(document).on("click", "[data-clear-value-on-click]", function() {
    var target = $(this).data("clear-value-on-click");
    $(target).val("");
  })
});
