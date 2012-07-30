var anchor, breath, exist, leaf, text;

leaf = function(elem) {
  return elem[0].tagName === 'CODE';
};

text = function(elem) {
  return elem.html().replace(/<br>/g, '');
};

exist = function(elem) {
  return elem.length > 0;
};

anchor = {};

breath = function() {
  var add, cal, div, each, get, mul, nes, num, nux, one, raw, read, scope, set, sub;
  $('#cirru div').attr('value', '');
  $('#cirru code').attr('value', '');
  scope = {};
  raw = function(elem) {
    elem.attr('value', ':raw:');
    return text(elem);
  };
  one = function(elem, f) {
    try {
      return f(elem);
    } catch (e) {
      return elem.attr('value', e);
    }
  };
  num = function(elem) {
    return Number(raw(elem));
  };
  nux = function(elem) {
    return num(elem.next());
  };
  nes = function(elem) {
    if (leaf(elem)) {
      return num(elem);
    } else {
      return one(elem, read);
    }
  };
  get = function(elem) {
    return scope[raw(elem.next())];
  };
  set = function(elem) {
    var key, value;
    elem = elem.next();
    key = raw(elem);
    value = nes(elem.next());
    return scope[key] = value;
  };
  cal = function(elem, f) {
    var res;
    res = nes(elem.next());
    elem = elem.next();
    while (exist(elem.next())) {
      elem = elem.next();
      res = f(res, nes(elem));
    }
    return res;
  };
  add = function(elem) {
    return cal(elem, function(x, y) {
      return x + y;
    });
  };
  sub = function(elem) {
    return cal(elem, function(x, y) {
      return x - y;
    });
  };
  mul = function(elem) {
    return cal(elem, function(x, y) {
      return x * y;
    });
  };
  div = function(elem) {
    return cal(elem, function(x, y) {
      return x / y;
    });
  };
  read = function(elem) {
    var head, ret;
    head = elem.children().first();
    head.attr('value', ':fun:');
    ret = (function() {
      switch (text(head)) {
        case 'get':
          return get(head);
        case 'set':
          return set(head);
        case 'add':
          return add(head);
        case 'sub':
          return sub(head);
        case 'num':
          return nux(head);
        case 'mul':
          return mul(head);
        case 'div':
          return div(head);
        default:
          return new Error('$not defined$');
      }
    })();
    head.parent().attr('value', ret);
    return ret;
  };
  each = $('#cirru').children();
  return $.each(each, function(i) {
    return one($(each[i]), read);
  });
};
