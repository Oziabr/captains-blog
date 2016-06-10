_ = require 'lodash'
Promise = require "bluebird"
fs = Promise.promisifyAll require "fs"

module.exports = (sequelize, dt) ->
  sequelize.define 'post', {
    title:        dt.STRING
    body:         dt.TEXT
  },
    paranoid: true
    classMethods:
      associate: (models) ->
        @.belongsTo models.profile, as: 'owner'
        @.hasMany models.comment
        @.hasMany models.post_rev
        return
    instanceMethods: {}
    hooks: {}
    scopes:
      ownedBy: (id) ->
        where: owner_id: id
        include: [ all: true ]
