#// BE SURE TO EDIT {{{FILENAME}}}
#// Version 0.{{{VERSION}}}

@htmlentities = (s) -> String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
#
# log(args..) to console
#
@log = (args...) => console.log(args...)

#
# dump(o,maxlevel,prefix) returns (somewhat) readable string variant of some object
#
@dump = (o,mx=3,pfx='',lv=0) =>
  if o == undefined then return "undefined"
  if o == null then return "null"
  t = typeof(o)
  t = "array" if t == 'object' && Object.prototype.toString.call(o) == '[object Array]'

  switch t
    when 'string' then return '"'+htmlentities(o)+'"'
    when 'number' then return ''+o

  return "("+t+")" if lv>mx

  switch t
    when 'array'  then '[ ' + ([ dump(i, mx, pfx+'['+n+']', lv+1) for i,n in o ].join(", ")) + ' ]'
    when 'object'
      s = '{'
      for k,v of o
        s += '\n'+pfx+'.'+k+': ' + dump(v, mx, pfx+'.'+k, lv+1)
      s + '\n}'
    else
      "("+t+") "+htmlentities(o)


#
# Mixins
# see https://arcturo.github.io/library/coffeescript/03_classes.html
#

@extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin
  obj

@include = (klass, mixin) ->
  extend klass.prototype, mixin

__mixinKeywords = ['extend', 'include']

class @Mixin
  @extend: (obj) ->
    for key, value of obj when key not in __mixinKeywords
      @[key] = value

    obj.extended?.apply(@)
    this

  @include: (obj) ->
    for key, value of obj when key not in __mixinKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    this

