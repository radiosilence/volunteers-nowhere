AccountsTemplates.configure
  defaultLayout: 'userLayout'
  enablePasswordChange: true
  showForgotPasswordLink: true
  # sendVerificationEmail: true
  continuousValidation: true
  # enforceEmailVerification: true
  # privacyUrl: '/s/privacy'
  # forbidClientAccountCreation: true
  # showResendVerificationEmailLink: true
  # postSignUpHook: postSignUpHook
  # onLogoutHook: onSignOut
  # termsUrl: 'terms-of-use'

# unless Settings.findOne().registrationClosed
#   AccountsTemplates.configureRoute 'signUp', { redirect: '/profile' }
#   AccountsTemplates.configure({forbidClientAccountCreation: false})
# else
#   AccountsTemplates.configure({forbidClientAccountCreation: true})

AccountsTemplates.configureRoute 'signIn', {redirect: '/dashboard'}
AccountsTemplates.configureRoute 'changePwd', { redirect: '/dashboard' }
AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'forgotPwd'
AccountsTemplates.configureRoute 'enrollAccount'

AccountsTemplates.addField
  _id: 'language'
  type: 'select'
  displayName: "Language"
  select: [
    { text: 'fr', value: 'fr' },
    { text: 'en', value: 'en' }
  ]

AccountsTemplates.addField
  _id: 'terms'
  type: 'checkbox'
  template: "termsCheckbox"
  errStr: "You must agree to the Terms and Conditions"
  func: (value) -> !value
  negativeValidation: false

# TODO: for later ...
# @setUserLanguage = (userId) ->
#   user = Meteor.users.findOne(userId)
#   if user
#     T9n.setLanguage user.profile.language
#     TAPi18n.setLanguage user.profile.language
#     moment.locale(user.profile.language)


@Volunteers = new VolunteersClass("nowhere2018")

addUsersToRoles = (user) ->
  if userId then Roles.addUsersToRoles userId, 'user', Volunteers.eventName
  # this can be useful
  # if Meteor.users.find().count() == 1
  #   Roles.addUsersToRoles userId, 'super-admin'

postSignUpHook = (userId, info) ->
  if Meteor.isServer then addUsersToRoles userId, 'users', Volunteers.eventName
  # if Meteor.isClient then setUserLanguage userId

Accounts.onLogin (conn) ->
  if Meteor.isServer
    Meteor.users.update conn.user._id, $set: lastLogin: new Date
  # if Meteor.isClient
  #   setUserLanguage Meteor.userId()
