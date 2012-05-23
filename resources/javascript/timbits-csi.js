var csi_qs_regex = /[\?\&](\w+)=([^&]*)/g;
var csi_qs_match;
var csi_qs_params = {};

while ((csi_qs_match = csi_qs_regex.exec(location.search)) != null) {
  csi_qs_params[csi_qs_match[1]] = csi_qs_match[2];
}

function processESI(index, element) {
  var include = $(element);
  var src = include.attr('src');
  
  // add callback parameter
  if (src.indexOf('?') == -1)
    src += '?';
  else
    src += '&';
  src += 'callback=?';
  
  // dynamic QS insertion
  var _re = /\$\(QUERY_STRING{'(\w+)'}\)/;
  var match;
  while ((match = src.match(_re)) != null) {
    src = src.replace(match[0], csi_qs_params[match[1]] ? csi_qs_params[match[1]] : '');
  }
  
  $.getJSON(src, function(data) {
    include.after(data);
    var onload = include.attr('onload');
    if (onload) eval(onload);
    include.remove();
  });
}

$( function() {
  $('esi\\:include, csi\\:include').each(processESI)
});