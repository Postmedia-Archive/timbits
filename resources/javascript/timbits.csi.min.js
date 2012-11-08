/*
Timbits CSI - v0.6.5
Copyright (c) 2012 Postmedia Network Inc
Written by Edward de Groot (http://mred9.com)
Licensed under the MIT license
https://github.com/Postmedia/timbits
*/
var timbits=timbits||{};timbits.renderCSI=function(e,t){switch(e.attr("data-mode")){case"append":e.append(t);break;case"prepend":e.prepend(t);break;default:e.html(t)}e.trigger("load")},timbits.processCSI=function(e,t){var n=jQuery(t),r=n.attr("data-csi"),i=!0;media=n.attr("data-media"),media&&window.matchMedia&&(mql=window.matchMedia(media),i=mql.matches,mql.matches||mql.addListener(timbits.discoverCSI));if(i){n.removeAttr("data-csi");var s=/{#(\w+)}/,o;while((o=r.match(s))!=null)r=r.replace(o[0],timbits.csi_qs_params[o[1]]?timbits.csi_qs_params[o[1]]:"");console.log("Processing CSI: "+r),r.search(/http:|https:/i)===0?(r+=r.indexOf("?")===-1?"?":"&",r+="callback=?",jQuery.getJSON(r,function(e){timbits.renderCSI(n,e)})):jQuery.get(r,function(e){timbits.renderCSI(n,e)})}},timbits.discoverCSI=function(e){console.log("Discovering CSI: "+(e?e.media:"Init")),jQuery("[data-csi]").each(timbits.processCSI)},jQuery(function(){timbits.csi_qs_params={};var e=/[\?\&](\w+)=([^&]*)/g,t;while((t=e.exec(location.search))!=null)timbits.csi_qs_params[t[1]]=t[2];timbits.discoverCSI()});