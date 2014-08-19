(function($) {
  $(".add-page-form").on("submit", function() {
    var url = $(this).find("[name='url']").val().replace(/^\s+/, "").replace(/\s+$/, "");

    if(url == "") {
      $(this).find("[name='url']").focus();
    } else {
      var domain = url.replace(/^https?:\/\//, "").split("/")[0];

      var path = url.split(domain)[1].split("/").map(function(c) { return encodeURIComponent(c) }).join("/");

      window.location.href = "/comments/" + domain + path;
    }

    return false;
  });

})(jQuery);
