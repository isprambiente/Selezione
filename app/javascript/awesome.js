import { config, library, dom } from '@fortawesome/fontawesome-svg-core'

config.mutateApproach = 'sync'

import {
  faBarcode,
  faCalendarCheck,
  faCalendarXmark,
  faCircleInfo,
  faChevronLeft,
  faList,
  faSearch,
} from '@fortawesome/free-solid-svg-icons'

library.add(
  faBarcode,
  faCalendarCheck,
  faCalendarXmark,
  faCircleInfo,
  faChevronLeft,
  faList,
  faSearch
)

dom.watch()
