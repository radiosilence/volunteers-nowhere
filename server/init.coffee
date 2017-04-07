Meteor.startup ->
  allRoles = ['manager']
  if Meteor.roles.find().count() < 1
    for role in allRoles
      Roles.createRole role

  defaultUsers = [
    {
      email: 'admin@example.com',
      password: 'apple1'
      profile: {
        role: 'manager'}
    },
  ]

  _.each defaultUsers, (options) ->
    if !Meteor.users.findOne({ "emails.address" : options.email })
      role = options.profile.role
      userId = Accounts.createUser(options)
      Meteor.users.update(userId, {$set: {"emails.0.verified" :true}})
      Roles.addUsersToRoles(userId, role)

# ------------------------------------------------------------------------------

Factory.define('fakeUser', Meteor.users, {
  'profile':
    'firstName': () -> faker.name.firstName(),
    'lastName': () -> faker.name.lastName(),
    'role': () -> 'user'
  'emails': () ->
    [
      'address': faker.internet.email(),
      'verified': true
    ]
  }
).after((user) ->
  Roles.addUsersToRoles(user._id, user.profile.role)
)
_.times(10,() -> Factory.create('fakeUser'))
_.times(2,() -> Factory.create('fakeUser',{'profile.role': 'manager'}))

Factory.define('fakeVolunteersForm',Volunteers.Collections.VolunteerForm,{
  'userId': Factory.get('fakeUser'),
})
_.times(10,() -> Factory.create('fakeVolunteersForm'))

getRandom = (name) -> _.sample(Factory.get(name).collection.find().fetch())

Factory.define('fakeTeam',Volunteers.Collections.Teams,
  {
    'name': () -> faker.company.companyName()
    'visibility': 'public',
    'leads': () -> [ {'userId': getRandom('fakeUser')._id, 'role': 'lead'} ]
    'tags': () -> faker.lorem.words(),
    'parents':[],
  })
_.times(10,() -> Factory.create('fakeTeam'))

Factory.define('fakeTeamShifts',Volunteers.Collections.TeamShifts,
  {
    'teamId': () -> getRandom('fakeTeam')._id
    'title': () -> faker.lorem.sentence()
    'description': () -> faker.lorem.paragraph()
    'visibility': 'public',
    'min': () -> faker.random.number(1,3),
    'max': () -> faker.random.number(4,6),
    'start': () -> faker.date.recent(),
    'end': () -> faker.date.recent(),
  })
_.times(50,() -> Factory.create('fakeTeamShifts'))

Factory.define('fakeTeamTasks',Volunteers.Collections.TeamTasks,
  {
    'teamId': () -> getRandom('fakeTeam')._id
    'title': () -> faker.lorem.sentence()
    'description': () -> faker.lorem.paragraph()
    'visibility': 'public'
    'dueDate': () -> faker.date.recent()
  })
_.times(50,() -> Factory.create('fakeTeamTasks'))
