import { config, library, dom } from '@fortawesome/fontawesome-svg-core'

config.mutateApproach = 'sync'

import {
  faBarcode,
  faCalendarCheck,
  faCalendarXmark,
  faSearch,
} from '@fortawesome/free-solid-svg-icons'

library.add(
  faBarcode,
  faCalendarCheck,
  faCalendarXmark,
  faSearch
)

dom.watch()
