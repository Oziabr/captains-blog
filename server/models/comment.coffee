_ = require 'lodash'
Promise = require "bluebird"
fs = Promise.promisifyAll require "fs"

module.exports = (sequelize, dt) ->
  sequelize.define 'comment', {
    title:        dt.STRING
    description:  dt.TEXT
  },
    paranoid: true
    classMethods:
      associate: (models) ->
        @.belongsTo models.profile, as: 'owner'
        @.belongsTo models.post
        @.belongsTo models.comment, as: 'parent'
        @.hasMany models.comment
        return
    instanceMethods: {}
    hooks: {}

    scopes:
      ownedBy: (id) ->
        where: owner_id: id
        include: [ all: true ]
