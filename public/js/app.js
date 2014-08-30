(function($) {
  $(".add-page-form").on("submit", function() {
    var url = $(this).find("[name='url']").val().replace(/^\s+/, "").replace(/\s+$/, "");

    if(url == "") {
      $(this).find("[name='url']").focus();
    } else {
      var domain = url.replace(/^https?:\/\//, "").split("/")[0];

      var path = url.split(domain)[1].split("/").map(function(c) { return encodeURIComponent(c) }).join("/");

      window.location.href = "/обсуждение/" + domain + path;
    }

    return false;
  });

  $(".widget[data-widget='toggable']").each(function() {
    var w = $(this);

    w.find(".toggle-button").click(function() {
      w.find(".section-1").toggleClass("hidden");
      w.find(".section-2").toggleClass("hidden");

      if(w.find(".section-1").is(":visible")) {
        $(this).text($(this).attr("data-text-1"));
      } else {
        $(this).text($(this).attr("data-text-2"));
      }
    });
  });



})(jQuery);
