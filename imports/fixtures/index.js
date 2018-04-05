import { createUnits } from './units-fixtures'
// import './duties-fixtures'
import { createShifts } from './shifts-fixtures'
import { createUsers } from './users-fixtures'
import { createForm } from './profile-form'

export const runFixtures = (Volunteers) => {
  // XXX this should be something else. This check is a bit dangerous
  const shouldRun = Volunteers.Collections.Team.find().count() === 0
  if (shouldRun) {
    console.log('Run fixtures')
    createUnits(Volunteers)
    createShifts(Volunteers)
    createForm(Volunteers)
    createUsers(Volunteers)
  }
}
