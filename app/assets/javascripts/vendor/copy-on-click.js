(function($){
  $.fn.copyOnClick = function(options){
    //Initialise opts with defaults and then the provided options
    var opts=$.extend( {}, $.fn.copyOnClick.defaults, options)
    var that=this.filter('['+opts.attrData+']');
    that.off(opts.triggerOn).on(opts.triggerOn,function(e){
      if(!"which" in e||e.which>1) { return; }
      var x=e.pageX; var y=e.pageY; // This gives us the mouse position
      e.preventDefault(); e.stopPropagation();
      var t="";
      var target=$(this);
      switch(opts.copyMode) {
        case "self":
          t=$(this).attr(opts.attrData);
          break;
        case "attr":
        case "attribute":
          target=$($(this).attr(opts.attrData));
          t=target.attr(opts.attrTarget);
          break;
        case "val":
        case "value":
          target=$($(this).attr(opts.attrData));
          t=target.val();
          break;
        case "text":
          target=$($(this).attr(opts.attrData));
          t=target.text();
          break;
        case "html":
          target=$($(this).attr(opts.attrData));
          t=target.html();
          break;
        default:
          if(opts.copyMode.substring(0,5)=="attr:") {
            t=$($(this).attr(opts.attrData))
          }
      }
      if(typeof opts.beforeCopy=="function") { t=opts.beforeCopy(t,target,$(this));}
      $.fn.copyOnClick.copyText(t);
      if(typeof opts.afterCopy=="function") { opts.afterCopy(t,target,$(this));}
      if(opts.confirmShow) {
        opts.confirmPopup(t,target,opts.confirmClass,opts.confirmTime,opts.confirmText,x,y);
      }
    });
    return this;
  };
  $.fn.copyOnClick.defaults = {
    attrData:"data-copy-on-click", // HTML attr containing text or selector to copy
    attrTarget:"data-copy-on-click",
    copyMode:"self",
    triggerOn:"click.copyOnClick",
    confirmShow:true,
    confirmClass:"copy-on-click",
    confirmText:"<b>Copied:</b> %c",
    confirmTime:1.5,
    beforeCopy:null,
    afterCopy:null,
    confirmPopup:function(str,target,c,t,txt,x,y) {
      // replace % codes:
      var s=$.fn.copyOnClick.replaceText(txt,str,target.attr("id"));
      // Remove any existing popups:
      if(typeof $.fn.copyOnClick.copyconf!="undefined") { clearTimeout($.fn.copyOnClick.copyconf);}
      $('.'+c).remove();
      // Add the popup after the target:
      var $pop=$('<div class="'+c+'">'+s+'</div>');
      target.after($pop);
      x=x-Math.round( $pop.outerWidth() / 2);
      y=y-Math.round( $pop.outerHeight() / 2);
      if(typeof x == "number"&&typeof y == "number") {
        // This no longer works correctly, we just use default positioning instead!
        /* $pop.css({
          top:y+"px",
          left:x+"px"
        }); */
      }
      // Set a timeout to make the popup disappear:
      $.fn.copyOnClick.copyconf=setTimeout(function(){$('.'+c).remove();},Math.floor(t*1000.0));
    }
  };
  $.fn.copyOnClick.copyText = function(text) {
    var $temp = $("<input>"); // Create buffer element for copied text
    $("body").append($temp); // Add buffer element to body so it can be selected
    $temp.val(text).select(); // Set buffer content and select it
    document.execCommand("copy"); // Execute copy to clipboard
    $temp.remove(); // Remove the buffer from the body
  };
  $.fn.copyOnClick.replaceText = function(txt,str,id) {
    return txt
      .replace(/^%c|([^\\])%c/g,"$1"+str)
      .replace(/\\%c/g,"%c")
      .replace(/^%i|([^\\])%i/g,"$1"+id)
      .replace(/\\%i/g,"%i");
  }
}(jQuery));

