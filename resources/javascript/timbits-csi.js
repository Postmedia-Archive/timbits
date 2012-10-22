/*
Timbits CSI - v0.6.4
Copyright (c) 2012 Postmedia Network Inc
Written by Edward de Groot (http://mred9.com)
Licensed under the MIT license
https://github.com/Postmedia/timbits
*/

var timbits = timbits || {};

timbits.processCSI = function(index, element) {
  var include = $(element);
  var src = include.attr('src');

  process_this = true;

  // test for optional media query
  media = include.attr('media');
  if (media && window.matchMedia) {
    mql = window.matchMedia(media);
    process_this = mql.matches;
    if (!mql.matches)
      mql.addListener(timbits.discoverCSI);
  }

  if (process_this && !include.attr('data-loading')) {
    // add flag to prevent processing more than once
    include.attr('data-loading', true);
    
    // add callback parameter
    src += (src.indexOf('?') === -1) ? '?' : '&';
    src += 'callback=?';

    // dynamic QS insertion
    var _re = /\$\(QUERY_STRING{'(\w+)'}\)/;
    var match;
    while ((match = src.match(_re)) != null) {
      src = src.replace(match[0], timbits.csi_qs_params[match[1]] ? timbits.csi_qs_params[match[1]] : '');
    }

    console.log('Processing CSI: ' + src);
    
    // fetch the resource and insert
    $.getJSON(src, function(data) {
      include.after(data);
      var onload = include.attr('onload');
      if (onload) eval(onload);
      include.remove();
    });
  }
}

timbits.discoverCSI = function(mql) {
  console.log("Discovering CSI: " + (mql ? mql.media : 'Init'));
  $('esi\\:include, csi\\:include').each(timbits.processCSI);
}

$( function() {
  // parse QS value for optional use within CSI calls
  timbits.csi_qs_params = {};
  
  var csi_qs_regex = /[\?\&](\w+)=([^&]*)/g;
  var csi_qs_match;
  
  while ((csi_qs_match = csi_qs_regex.exec(location.search)) != null) {
    timbits.csi_qs_params[csi_qs_match[1]] = csi_qs_match[2];
  }
  // discover and process CSI calls
  timbits.discoverCSI();
});