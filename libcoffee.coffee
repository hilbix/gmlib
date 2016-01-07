#// BE SURE TO EDIT {{{FILENAME}}}
#// Version 0.{{{VERSION}}}
#//
#// Mixins

# see https://arcturo.github.io/library/coffeescript/03_classes.html


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

