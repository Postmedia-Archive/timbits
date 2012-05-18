function processESI(index, element) {
  var include = $(element);
  var src = include.attr('src');
  
  if (src.indexOf('?') == -1)
    src += '?';
  else
    src += '&';
    
  src += 'callback=?';
  
  $.getJSON(src, function(data) {
    include.after(data);
    include.remove();
  });
}

$( function() {
  $('esi\\:include, csi\\:include').each(processESI)
});