/*
Timbits CSI - v0.6.4
Copyright (c) 2012 Postmedia Network Inc
Written by Edward de Groot (http://mred9.com)
Licensed under the MIT license
https://github.com/Postmedia/timbits
*/
var timbits=timbits||{};timbits.processCSI=function(index,element){var include=$(element),src=include.attr("src");process_this=!0,media=include.attr("media"),media&&window.matchMedia&&(mql=window.matchMedia(media),process_this=mql.matches,mql.matches||mql.addListener(timbits.discoverCSI));if(process_this&&!include.attr("data-loading")){include.attr("data-loading",!0),src+=src.indexOf("?")===-1?"?":"&",src+="callback=?";var _re=/\$\(QUERY_STRING{'(\w+)'}\)/,match;while((match=src.match(_re))!=null)src=src.replace(match[0],timbits.csi_qs_params[match[1]]?timbits.csi_qs_params[match[1]]:"");console.log(src),$.getJSON(src,function(data){include.after(data);var onload=include.attr("onload");onload&&eval(onload),include.remove()})}},timbits.discoverCSI=function(e){console.log("Discovering CSI: "+(e?e.media:"Init")),$("esi\\:include, csi\\:include").each(timbits.processCSI)},$(function(){timbits.csi_qs_params={};var e=/[\?\&](\w+)=([^&]*)/g,t;while((t=e.exec(location.search))!=null)timbits.csi_qs_params[t[1]]=t[2];timbits.discoverCSI()});