!function(t,e){t.rails!==e&&t.error("jquery-ujs has already been loaded!");var n,a=t(document);t.rails=n={linkClickSelector:"a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]",buttonClickSelector:"button[data-remote]",inputChangeSelector:"select[data-remote], input[data-remote], textarea[data-remote]",formSubmitSelector:"form",formInputClickSelector:"form input[type=submit], form input[type=image], form button[type=submit], form button:not([type])",disableSelector:"input[data-disable-with], button[data-disable-with], textarea[data-disable-with]",enableSelector:"input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled",requiredInputSelector:"input[name][required]:not([disabled]),textarea[name][required]:not([disabled])",fileInputSelector:"input[type=file]",linkDisableSelector:"a[data-disable-with]",CSRFProtection:function(e){var n=t('meta[name="csrf-token"]').attr("content");n&&e.setRequestHeader("X-CSRF-Token",n)},fire:function(e,n,a){var i=t.Event(n);return e.trigger(i,a),i.result!==!1},confirm:function(t){return confirm(t)},ajax:function(e){return t.ajax(e)},href:function(t){return t.attr("href")},handleRemote:function(a){var i,o,r,s,l,d,c,h;if(n.fire(a,"ajax:before")){if(s=a.data("cross-domain"),l=s===e?null:s,d=a.data("with-credentials")||null,c=a.data("type")||t.ajaxSettings&&t.ajaxSettings.dataType,a.is("form")){i=a.attr("method"),o=a.attr("action"),r=a.serializeArray();var u=a.data("ujs:submit-button");u&&(r.push(u),a.data("ujs:submit-button",null))}else a.is(n.inputChangeSelector)?(i=a.data("method"),o=a.data("url"),r=a.serialize(),a.data("params")&&(r=r+"&"+a.data("params"))):a.is(n.buttonClickSelector)?(i=a.data("method")||"get",o=a.data("url"),r=a.serialize(),a.data("params")&&(r=r+"&"+a.data("params"))):(i=a.data("method"),o=n.href(a),r=a.data("params")||null);h={type:i||"GET",data:r,dataType:c,beforeSend:function(t,i){return i.dataType===e&&t.setRequestHeader("accept","*/*;q=0.5, "+i.accepts.script),n.fire(a,"ajax:beforeSend",[t,i])},success:function(t,e,n){a.trigger("ajax:success",[t,e,n])},complete:function(t,e){a.trigger("ajax:complete",[t,e])},error:function(t,e,n){a.trigger("ajax:error",[t,e,n])},crossDomain:l},d&&(h.xhrFields={withCredentials:d}),o&&(h.url=o);var p=n.ajax(h);return a.trigger("ajax:send",p),p}return!1},handleMethod:function(a){var i=n.href(a),o=a.data("method"),r=a.attr("target"),s=t("meta[name=csrf-token]").attr("content"),l=t("meta[name=csrf-param]").attr("content"),d=t('<form method="post" action="'+i+'"></form>'),c='<input name="_method" value="'+o+'" type="hidden" />';l!==e&&s!==e&&(c+='<input name="'+l+'" value="'+s+'" type="hidden" />'),r&&d.attr("target",r),d.hide().append(c).appendTo("body"),d.submit()},disableFormElements:function(e){e.find(n.disableSelector).each(function(){var e=t(this),n=e.is("button")?"html":"val";e.data("ujs:enable-with",e[n]()),e[n](e.data("disable-with")),e.prop("disabled",!0)})},enableFormElements:function(e){e.find(n.enableSelector).each(function(){var e=t(this),n=e.is("button")?"html":"val";e.data("ujs:enable-with")&&e[n](e.data("ujs:enable-with")),e.prop("disabled",!1)})},allowAction:function(t){var e,a=t.data("confirm"),i=!1;return a?(n.fire(t,"confirm")&&(i=n.confirm(a),e=n.fire(t,"confirm:complete",[i])),i&&e):!0},blankInputs:function(e,n,a){var i,o,r=t(),s=n||"input,textarea",l=e.find(s);return l.each(function(){if(i=t(this),o=i.is("input[type=checkbox],input[type=radio]")?i.is(":checked"):i.val(),!o==!a){if(i.is("input[type=radio]")&&l.filter('input[type=radio]:checked[name="'+i.attr("name")+'"]').length)return!0;r=r.add(i)}}),r.length?r:!1},nonBlankInputs:function(t,e){return n.blankInputs(t,e,!0)},stopEverything:function(e){return t(e.target).trigger("ujs:everythingStopped"),e.stopImmediatePropagation(),!1},disableElement:function(t){t.data("ujs:enable-with",t.html()),t.html(t.data("disable-with")),t.bind("click.railsDisable",function(t){return n.stopEverything(t)})},enableElement:function(t){t.data("ujs:enable-with")!==e&&(t.html(t.data("ujs:enable-with")),t.removeData("ujs:enable-with")),t.unbind("click.railsDisable")}},n.fire(a,"rails:attachBindings")&&(t.ajaxPrefilter(function(t,e,a){t.crossDomain||n.CSRFProtection(a)}),a.delegate(n.linkDisableSelector,"ajax:complete",function(){n.enableElement(t(this))}),a.delegate(n.linkClickSelector,"click.rails",function(a){var i=t(this),o=i.data("method"),r=i.data("params");if(!n.allowAction(i))return n.stopEverything(a);if(i.is(n.linkDisableSelector)&&n.disableElement(i),i.data("remote")!==e){if(!(!a.metaKey&&!a.ctrlKey||o&&"GET"!==o||r))return!0;var s=n.handleRemote(i);return s===!1?n.enableElement(i):s.error(function(){n.enableElement(i)}),!1}return i.data("method")?(n.handleMethod(i),!1):void 0}),a.delegate(n.buttonClickSelector,"click.rails",function(e){var a=t(this);return n.allowAction(a)?(n.handleRemote(a),!1):n.stopEverything(e)}),a.delegate(n.inputChangeSelector,"change.rails",function(e){var a=t(this);return n.allowAction(a)?(n.handleRemote(a),!1):n.stopEverything(e)}),a.delegate(n.formSubmitSelector,"submit.rails",function(a){var i=t(this),o=i.data("remote")!==e,r=n.blankInputs(i,n.requiredInputSelector),s=n.nonBlankInputs(i,n.fileInputSelector);if(!n.allowAction(i))return n.stopEverything(a);if(r&&i.attr("novalidate")==e&&n.fire(i,"ajax:aborted:required",[r]))return n.stopEverything(a);if(o){if(s){setTimeout(function(){n.disableFormElements(i)},13);var l=n.fire(i,"ajax:aborted:file",[s]);return l||setTimeout(function(){n.enableFormElements(i)},13),l}return n.handleRemote(i),!1}setTimeout(function(){n.disableFormElements(i)},13)}),a.delegate(n.formInputClickSelector,"click.rails",function(e){var a=t(this);if(!n.allowAction(a))return n.stopEverything(e);var i=a.attr("name"),o=i?{name:i,value:a.val()}:null;a.closest("form").data("ujs:submit-button",o)}),a.delegate(n.formSubmitSelector,"ajax:beforeSend.rails",function(e){this==e.target&&n.disableFormElements(t(this))}),a.delegate(n.formSubmitSelector,"ajax:complete.rails",function(e){this==e.target&&n.enableFormElements(t(this))}),t(function(){var e=t("meta[name=csrf-token]").attr("content"),n=t("meta[name=csrf-param]").attr("content");t('form input[name="'+n+'"]').val(e)}))}(jQuery),/* =============================================================
 * bootstrap-collapse.js v2.3.1
 * http://twitter.github.com/bootstrap/javascript.html#collapse
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */
!function(t){"use strict";var e=function(e,n){this.$element=t(e),this.options=t.extend({},t.fn.collapse.defaults,n),this.options.parent&&(this.$parent=t(this.options.parent)),this.options.toggle&&this.toggle()};e.prototype={constructor:e,dimension:function(){var t=this.$element.hasClass("width");return t?"width":"height"},show:function(){var e,n,a,i;if(!this.transitioning&&!this.$element.hasClass("in")){if(e=this.dimension(),n=t.camelCase(["scroll",e].join("-")),a=this.$parent&&this.$parent.find("> .accordion-group > .in"),a&&a.length){if(i=a.data("collapse"),i&&i.transitioning)return;a.collapse("hide"),i||a.data("collapse",null)}this.$element[e](0),this.transition("addClass",t.Event("show"),"shown"),t.support.transition&&this.$element[e](this.$element[0][n])}},hide:function(){var e;!this.transitioning&&this.$element.hasClass("in")&&(e=this.dimension(),this.reset(this.$element[e]()),this.transition("removeClass",t.Event("hide"),"hidden"),this.$element[e](0))},reset:function(t){var e=this.dimension();return this.$element.removeClass("collapse")[e](t||"auto")[0].offsetWidth,this.$element[null!==t?"addClass":"removeClass"]("collapse"),this},transition:function(e,n,a){var i=this,o=function(){"show"==n.type&&i.reset(),i.transitioning=0,i.$element.trigger(a)};this.$element.trigger(n),n.isDefaultPrevented()||(this.transitioning=1,this.$element[e]("in"),t.support.transition&&this.$element.hasClass("collapse")?this.$element.one(t.support.transition.end,o):o())},toggle:function(){this[this.$element.hasClass("in")?"hide":"show"]()}};var n=t.fn.collapse;t.fn.collapse=function(n){return this.each(function(){var a=t(this),i=a.data("collapse"),o=t.extend({},t.fn.collapse.defaults,a.data(),"object"==typeof n&&n);i||a.data("collapse",i=new e(this,o)),"string"==typeof n&&i[n]()})},t.fn.collapse.defaults={toggle:!0},t.fn.collapse.Constructor=e,t.fn.collapse.noConflict=function(){return t.fn.collapse=n,this},t(document).on("click.collapse.data-api","[data-toggle=collapse]",function(e){var n,a=t(this),i=a.attr("data-target")||e.preventDefault()||(n=a.attr("href"))&&n.replace(/.*(?=#[^\s]+$)/,""),o=t(i).data("collapse")?"toggle":a.data();a[t(i).hasClass("in")?"addClass":"removeClass"]("collapsed"),t(i).collapse(o)})}(window.jQuery),/* ============================================================
 * bootstrap-dropdown.js v2.3.1
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */
!function(t){"use strict";function e(){t(a).each(function(){n(t(this)).removeClass("open")})}function n(e){var n,a=e.attr("data-target");return a||(a=e.attr("href"),a=a&&/#/.test(a)&&a.replace(/.*(?=#[^\s]*$)/,"")),n=a&&t(a),n&&n.length||(n=e.parent()),n}var a="[data-toggle=dropdown]",i=function(e){var n=t(e).on("click.dropdown.data-api",this.toggle);t("html").on("click.dropdown.data-api",function(){n.parent().removeClass("open")})};i.prototype={constructor:i,toggle:function(){var a,i,o=t(this);if(!o.is(".disabled, :disabled"))return a=n(o),i=a.hasClass("open"),e(),i||a.toggleClass("open"),o.focus(),!1},keydown:function(e){var i,o,r,s,l;if(/(38|40|27)/.test(e.keyCode)&&(i=t(this),e.preventDefault(),e.stopPropagation(),!i.is(".disabled, :disabled"))){if(r=n(i),s=r.hasClass("open"),!s||s&&27==e.keyCode)return 27==e.which&&r.find(a).focus(),i.click();o=t("[role=menu] li:not(.divider):visible a",r),o.length&&(l=o.index(o.filter(":focus")),38==e.keyCode&&l>0&&l--,40==e.keyCode&&l<o.length-1&&l++,~l||(l=0),o.eq(l).focus())}}};var o=t.fn.dropdown;t.fn.dropdown=function(e){return this.each(function(){var n=t(this),a=n.data("dropdown");a||n.data("dropdown",a=new i(this)),"string"==typeof e&&a[e].call(n)})},t.fn.dropdown.Constructor=i,t.fn.dropdown.noConflict=function(){return t.fn.dropdown=o,this},t(document).on("click.dropdown.data-api",e).on("click.dropdown.data-api",".dropdown form",function(t){t.stopPropagation()}).on("click.dropdown-menu",function(t){t.stopPropagation()}).on("click.dropdown.data-api",a,i.prototype.toggle).on("keydown.dropdown.data-api",a+", [role=menu]",i.prototype.keydown)}(window.jQuery),/* =========================================================
 * bootstrap-modal.js v2.3.1
 * http://twitter.github.com/bootstrap/javascript.html#modals
 * =========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */
!function(t){"use strict";var e=function(e,n){this.options=n,this.$element=t(e).delegate('[data-dismiss="modal"]',"click.dismiss.modal",t.proxy(this.hide,this)),this.options.remote&&this.$element.find(".modal-body").load(this.options.remote)};e.prototype={constructor:e,toggle:function(){return this[this.isShown?"hide":"show"]()},show:function(){var e=this,n=t.Event("show");this.$element.trigger(n),this.isShown||n.isDefaultPrevented()||(this.isShown=!0,this.escape(),this.backdrop(function(){var n=t.support.transition&&e.$element.hasClass("fade");e.$element.parent().length||e.$element.appendTo(document.body),e.$element.show(),n&&e.$element[0].offsetWidth,e.$element.addClass("in").attr("aria-hidden",!1),e.enforceFocus(),n?e.$element.one(t.support.transition.end,function(){e.$element.focus().trigger("shown")}):e.$element.focus().trigger("shown")}))},hide:function(e){e&&e.preventDefault();e=t.Event("hide"),this.$element.trigger(e),this.isShown&&!e.isDefaultPrevented()&&(this.isShown=!1,this.escape(),t(document).off("focusin.modal"),this.$element.removeClass("in").attr("aria-hidden",!0),t.support.transition&&this.$element.hasClass("fade")?this.hideWithTransition():this.hideModal())},enforceFocus:function(){var e=this;t(document).on("focusin.modal",function(t){e.$element[0]===t.target||e.$element.has(t.target).length||e.$element.focus()})},escape:function(){var t=this;this.isShown&&this.options.keyboard?this.$element.on("keyup.dismiss.modal",function(e){27==e.which&&t.hide()}):this.isShown||this.$element.off("keyup.dismiss.modal")},hideWithTransition:function(){var e=this,n=setTimeout(function(){e.$element.off(t.support.transition.end),e.hideModal()},500);this.$element.one(t.support.transition.end,function(){clearTimeout(n),e.hideModal()})},hideModal:function(){var t=this;this.$element.hide(),this.backdrop(function(){t.removeBackdrop(),t.$element.trigger("hidden")})},removeBackdrop:function(){this.$backdrop&&this.$backdrop.remove(),this.$backdrop=null},backdrop:function(e){var n=this.$element.hasClass("fade")?"fade":"";if(this.isShown&&this.options.backdrop){var a=t.support.transition&&n;if(this.$backdrop=t('<div class="modal-backdrop '+n+'" />').appendTo(document.body),this.$backdrop.click("static"==this.options.backdrop?t.proxy(this.$element[0].focus,this.$element[0]):t.proxy(this.hide,this)),a&&this.$backdrop[0].offsetWidth,this.$backdrop.addClass("in"),!e)return;a?this.$backdrop.one(t.support.transition.end,e):e()}else!this.isShown&&this.$backdrop?(this.$backdrop.removeClass("in"),t.support.transition&&this.$element.hasClass("fade")?this.$backdrop.one(t.support.transition.end,e):e()):e&&e()}};var n=t.fn.modal;t.fn.modal=function(n){return this.each(function(){var a=t(this),i=a.data("modal"),o=t.extend({},t.fn.modal.defaults,a.data(),"object"==typeof n&&n);i||a.data("modal",i=new e(this,o)),"string"==typeof n?i[n]():o.show&&i.show()})},t.fn.modal.defaults={backdrop:!0,keyboard:!0,show:!0},t.fn.modal.Constructor=e,t.fn.modal.noConflict=function(){return t.fn.modal=n,this},t(document).on("click.modal.data-api",'[data-toggle="modal"]',function(e){var n=t(this),a=n.attr("href"),i=t(n.attr("data-target")||a&&a.replace(/.*(?=#[^\s]+$)/,"")),o=i.data("modal")?"toggle":t.extend({remote:!/#/.test(a)&&a},i.data(),n.data());e.preventDefault(),i.modal(o).one("hide",function(){n.focus()})})}(window.jQuery),function(){}.call(this),function(){window.preview=function(){return $.ajax("/posts/preview",{type:"POST",data:$("#post-change-form").serialize(),dataType:"html",success:function(t){return $("#preview").html(t),$("#preview-accordion").collapse("hide").collapse("show")},error:function(){return $("#preview").html('<div class="alert alert-error"> Preview failed.</div>')}})},window.add_show_more_links=function(){return $(".show-more-link").each(function(){var t,n;return n=$(this),t=n.parent().children(".post-body"),t.height()>140?(t.data("oldHeight",t.height()),t.height(140),t.css("overflow","hidden"),n.html('<br><a href="javascript:void(0)">Expand this post &rarr;</a><br>'),n.children("a").click(function(){return t.height(t.data("oldHeight")),t.css("overflow","visible"),n.html(""),e.preventDefault(),!1})):void 0})}}.call(this),function(){}.call(this);