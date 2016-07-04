@ResolveAll = Vue.extend
  data: ->
    comments: CommentsStore.state
    loading: false
  computed:
    resolved: ->
      resolvedCount = 0
      for noteId, resolved of this.comments
        resolvedCount++ if resolved
      resolvedCount
    commentsCount: ->
      Object.keys(this.comments).length
    buttonText: ->
      if this.allResolved then 'Un-resolve all' else 'Resolve all'
    allResolved: ->
      this.resolved is this.commentsCount
  methods:
    updateAll: ->
      ids = CommentsStore.getAllForState(this.allResolved)
      this.$set('loading', true)

      promise = if this.allResolved then ResolveService.resolveAll(ids) else ResolveService.resolveAll(ids)

      promise
        .done =>
          CommentsStore.updateAll(!this.allResolved)
        .always =>
          this.$set('loading', false)
