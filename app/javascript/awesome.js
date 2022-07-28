import { config, library, dom } from '@fortawesome/fontawesome-svg-core'

config.mutateApproach = 'sync'

import {
  faSearch
} from '@fortawesome/free-solid-svg-icons'

library.add(
  faSearch
)

dom.watch()
