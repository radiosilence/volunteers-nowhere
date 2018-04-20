/* eslint-disable meteor/template-names, no-underscore-dangle */
import { Template } from 'meteor/templating'
import { Volunteers } from '../both/init'

Template.header.onCreated(function onCreated() {
  const template = this
  template.subscribe(`${Volunteers.eventName}.Volunteers.organization`)
})

Template.header.helpers({
// XXX : restrict only to those depts and teams leaded by the user, or display all for manager
  departments: () => Volunteers.Collections.Department.find(),
  teams: () => Volunteers.Collections.Team.find(),
  // the TOS is true only if the form was submitted
  hasAgreedTOS() {
    const user = Meteor.user()
    const f = Volunteers.Collections.VolunteerForm.findOne({ userId: user._id })
    const t = user.profile.terms
    return (t && f)
  },
  isManagerOrLead: () => {
    const teams = Volunteers.Collections.Team.find().map(t => t._id)
    return Volunteers.isManagerOrLead(Meteor.userId(), teams)
  },
  isManagerOrMetaLead: () => {
    const departments = Volunteers.Collections.Department.find().map(t => t._id)
    return Volunteers.isManagerOrLead(Meteor.userId(), departments)
  },
  isManager: () => Volunteers.isManager(),
  isNoInfo: () => {
    const noInfo = Volunteers.Collections.Team.findOne({ name: 'NoInfo' })
    return (noInfo != null) && Volunteers.isManagerOrLead(Meteor.userId(), [noInfo._id])
  },
})
