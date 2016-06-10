_ = require 'lodash'
router    = (require 'express').Router()
uploader  = (require __dirname + '/../api/filetype').uploader()
debug     = (require 'debug') 'post'

module.exports = (db) ->

  router.get '/', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    db.post.scope method: ['ownedBy', req.user]
    #db.post
    .findAll()
    .then (list) ->
      res.render 'post/list', posts: list

  router.get '/create', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    res.render 'post/create'

  router.post '/create', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    db.post.create _.extend {owner_id: req.user}, req.body
    .then (post) ->
      res.redirect '/post'

  router.get '/:id', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    db.post.scope method: ['ownedBy', req.user]
    .findById parseInt req.params.id
    .then (post) ->
      res.render 'post/edit', post: post

  router.post '/:id', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    db.post.scope method: ['ownedBy', req.user]
    .findById parseInt req.params.id
    .then (post) ->
      res.redirect '/post'

  return router
