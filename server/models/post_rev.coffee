_ = require 'lodash'
Promise = require "bluebird"

module.exports = (sequelize, dt) ->
  sequelize.define 'post_rev', {
    title:        dt.STRING
    body:         dt.TEXT
  },
    paranoid: true
    classMethods:
      associate: (models) ->
        @.belongsTo models.profile, as: 'owner'
        @.belongsTo models.post
        return
    instanceMethods: {}
    hooks: {}
    scopes:
      ownedBy: (id) ->
        where: owner_id: id
        include: [ all: true ]
