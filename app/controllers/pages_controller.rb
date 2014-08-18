class PagesController < Sinatra::Base
  get "/" do
    "No Comment"
  end

  get %r{/c/(.+)} do |url|
   
    <<-HTML
<html>
<head>
  <title>Комментарии для #{url}</title>


  <style>
    #container { width: 100%;  max-width: 750px; text-align: left }
  </style>
</head>
<body>
  <center>
    <div id="container">
      <span style="font-size: 200%; font-weight: bold">No Comment?</span>
      <br />
      <em>Там, где комментариев нет</em>

      <hr style="color: grey" />
      <br />
      <br />


      <div class="article">
      <a class="embedly-card" href="http://#{url}">#{url}</a>
      <script>(function(a){var b="embedly-platform",c="script";if(!a.getElementById(b)){var d=a.createElement(c);d.id=b;d.async=true;d.src=("https:"===document.location.protocol?"https":"http")+"://cdn.embedly.com/widgets/platform.js";var e=document.getElementsByTagName(c)[0];e.parentNode.insertBefore(d,e)}})(document);</script>
      </div>
      <br />

      <div id="hypercomments_widget"></div>
      <a href="http://hypercomments.com" class="hc-link" title="comments widget">комментарии на технологии HyperComments</a>
    </div>
  </center>

  <script type="text/javascript">
  _hcwp = window._hcwp || [];
  var _hc_settings = {
    widget:"Stream", widget_id:18390,
    xid: "#{url}",
    href: "#{url}"
  };
  _hcwp.push(_hc_settings);

  (function() {
   if("HC_LOAD_INIT" in window)return;
   HC_LOAD_INIT = true;
   var lang = (navigator.language || navigator.systemLanguage || navigator.userLanguage || "en").substr(0, 2).toLowerCase();
   var hcc = document.createElement("script"); hcc.type = "text/javascript"; hcc.async = true;
   hcc.src = ("https:" == document.location.protocol ? "https" : "http")+"://w.hypercomments.com/widget/hc/18390/"+lang+"/widget.js";
   var s = document.getElementsByTagName("script")[0];
   s.parentNode.insertBefore(hcc, s.nextSibling);
   })();
  </script>
</body>
</html>

    HTML
  end
end
