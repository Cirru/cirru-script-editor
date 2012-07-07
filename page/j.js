// Generated by CoffeeScript 1.3.3
var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

$(function() {
  var click_choose, cursor, ed, editable, empty, focus, in_sight, pop_point, set_point;
  editable = 'contenteditable';
  cursor = "<div class='point' " + editable + "='true'></div>";
  empty = ['', '<br>'];
  ed = $('#editor');
  ed.append(cursor);
  $('.point').focus();
  ed.click(function() {
    return (function() {
      return $('.point').focus();
    })();
  });
  click_choose = function(elems) {
    return elems[0].onclick = function() {
      var old, up, _ref;
      old = $('.point').removeAttr(editable).removeAttr('class');
      click_choose(old);
      if (old.html().length === 0) {
        up = old.parent();
        old.remove();
        while (_ref = up.html(), __indexOf.call(empty, _ref) >= 0) {
          old = up;
          up = up.parent();
          old.remove();
        }
      }
      set_point(elems);
      return false;
    };
  };
  pop_point = function(elems) {
    elems.removeAttr(editable).removeAttr('class');
    click_choose(elems);
    return elems;
  };
  set_point = function(elems) {
    elems.attr(editable, 'true').attr('class', 'point').focus();
    return elems;
  };
  focus = function() {
    var sel;
    sel = window.getSelection();
    sel.collapse($('.point')[0], 1);
    return $('.point').focus();
  };
  in_sight = true;
  $('#editor').bind('focus', function() {
    return in_sight = true;
  });
  $('#editor').bind('blur', function() {
    return in_sight = false;
  });
  $(document).keydown(function(e) {
    var next, old, prev, up, _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
    console.log(e.keyCode);
    if (in_sight) {
      switch (e.keyCode) {
        case 13:
          old = pop_point($('.point'));
          old.after("<section>" + cursor + "</section>");
          focus();
          if (_ref = old.html(), __indexOf.call(empty, _ref) >= 0) {
            old.first().remove();
          }
          break;
        case 9:
          if ($('.point').html().length > 0) {
            if (e.shiftKey) {
              $('.point').before(cursor);
              old = $('.point').last();
            } else {
              $('.point').after(cursor);
              old = $('.point').first();
            }
            pop_point(old);
            focus();
          }
          break;
        case 46:
          if ($('.point').next().length > 0) {
            next = $('.point').next();
            old = pop_point($('.point'));
            old.remove();
            if (next[0].tagName === 'DIV') {
              set_point(next);
            } else if (next[0].tagName === 'SECTION') {
              next.prepend(cursor);
            }
          } else if ($('.point').prev().length > 0) {
            prev = $('.point').prev();
            old = pop_point($('.point'));
            old.remove();
            if (prev[0].tagName === 'DIV') {
              set_point(prev);
            } else {
              prev.append(cursor);
            }
          } else if (_ref1 = $('.point').text(), __indexOf.call(empty, _ref1) < 0) {
            $('.point').text('');
          } else {
            if ($('.point').parent()[0].tagName !== 'SECTION') {
              $('.point').text('');
            } else {
              $('.point').parent()[0].outerHTML = cursor;
            }
          }
          focus();
          break;
        case 38:
          if (_ref2 = $('.point').html(), __indexOf.call(empty, _ref2) < 0) {
            old = pop_point($('.point'));
            old.before(cursor);
          } else if ($('.point').prev().length > 0) {
            prev = $('.point').prev();
            if (prev[0].tagName === 'DIV') {
              set_point($('.point').prev());
            } else if (prev[0].tagName === 'SECTION') {
              prev.append(cursor);
            }
            $('.point')[1].outerHTML = '';
          } else if ($('.point').parent().attr('id') !== 'editor') {
            $('.point').parent().before(cursor);
            old = $('.point').last();
            up = old.parent();
            old.remove();
            if (_ref3 = up.html(), __indexOf.call(empty, _ref3) >= 0) {
              up.remove();
            }
          }
          focus();
          break;
        case 40:
          if (_ref4 = $('.point').html(), __indexOf.call(empty, _ref4) < 0) {
            old = pop_point($('.point'));
            old.after(cursor);
          } else if ($('.point').next().length > 0) {
            next = $('.point').next();
            if (next[0].tagName === 'DIV') {
              set_point($('.point').next());
            } else if (next[0].tagName === 'SECTION') {
              next.prepend(cursor);
            }
            $('.point').first().remove();
          } else if ($('.point').parent().attr('id') !== 'editor') {
            $('.point').parent().after(cursor);
            old = $('.point').first();
            up = old.parent();
            old.remove();
            if (_ref5 = up.html(), __indexOf.call(empty, _ref5) >= 0) {
              up.remove();
            }
          }
          focus();
          break;
        default:
          return true;
      }
      return false;
    }
  });
  return window.parse = function() {
    var map, res;
    map = function(item) {
      var res;
      if (item.tagName === 'DIV') {
        return item.innerText;
      } else if (item.tagName === 'SECTION') {
        console.log(item.children);
        res = $.map(item.children, function(x) {
          return map(x);
        });
        return [res];
      }
    };
    res = $.map($('#editor')[0].children, map);
    return console.log('res:', res);
  };
});
