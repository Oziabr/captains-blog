_ = require 'lodash'
router    = (require 'express').Router()
uploader  = (require __dirname + '/../api/filetype').uploader()
debug     = (require 'debug') 'post'

module.exports = (db) ->

  router.get '/', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    where = {}
    where.post_id = parseInt req.query.post_id if  req.query.post_id
    where.owner_id = req.user                  if !req.query.post_id
    db.post_rev
    .findAll where: where
    .then (list) ->
      res.render 'post_rev/list', post_revs: list

  router.get '/create', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    db.post.scope method: ['ownedBy', req.user]
    .findById parseInt req.query.post_id
    .then (post) ->
      res.render 'post_rev/create', post: post

  router.post '/create', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    db.post_rev.create _.extend req.body,
      owner_id: req.user
      post_id: parseInt req.query.post_id
    .then (post_rev) ->
      console.log 'post_rev', @.id
      res.redirect "/post_rev/#{post_rev.id}"

  router.get '/:id', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    db.post_rev.scope method: ['ownedBy', req.user]
    .findById parseInt req.params.id
    .then (post_rev) ->
      res.render 'post_rev/show', post_rev: post_rev

  router.post '/:id', (req, res) ->
    return res.redirect '/' if !req.isAuthenticated()
    db.post.scope method: ['ownedBy', req.user]
    .findById parseInt req.params.id
    .then (post) ->
      res.redirect '/post'

  return router
