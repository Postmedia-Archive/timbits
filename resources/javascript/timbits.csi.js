/*
Timbits CSI - v0.6.5
Copyright (c) 2012 Postmedia Network Inc
Written by Edward de Groot (http://mred9.com)
Licensed under the MIT license
https://github.com/Postmedia/timbits
*/

var timbits = timbits || {};

timbits.renderCSI = function(include, data) {
  switch(include.attr('data-mode')) {
    case 'append':
      include.append(data);
      break;
    case 'prepend':
      include.prepend(data);
      break;
    default:
      include.html(data);
  }
  include.trigger('load');
}

timbits.processCSI = function(index, element) {
  var include = jQuery(element);
  var src = include.attr('data-csi');
  var process_this = true;

  // test for optional media query
  media = include.attr('data-media');
  if (media && window.matchMedia) {
    mql = window.matchMedia(media);
    process_this = mql.matches;
    if (!mql.matches)
      mql.addListener(timbits.discoverCSI);
  }

  if (process_this) {
    // remove data-csi attribute to prevent processing more than once
    include.removeAttr('data-csi');
    
    // dynamic QS insertion
    var _re = /{#(\w+)}/;
    var match;
    while ((match = src.match(_re)) != null) {
      src = src.replace(match[0], timbits.csi_qs_params[match[1]] ? timbits.csi_qs_params[match[1]] : '');
    }

    console.log('Processing CSI: ' + src);

    if (src.search(/http:|https:/i) === 0)
    {
      // remote request - add callback parameter
      src += (src.indexOf('?') === -1) ? '?' : '&';
      src += 'callback=?';
      
      // fetch the remote resource and render
      jQuery.getJSON(src, function(data) {
        timbits.renderCSI(include, data);
      });
    } else {
      // fetch the load resource and render
      jQuery.get(src, function(data) {
        timbits.renderCSI(include, data);
      });
    }
  }
}

timbits.discoverCSI = function(mql) {
  console.log("Discovering CSI: " + (mql ? mql.media : 'Init'));
  jQuery('[data-csi]').each(timbits.processCSI); 
}

jQuery( function() {
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