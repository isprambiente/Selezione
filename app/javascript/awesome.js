import { config, library, dom } from '@fortawesome/fontawesome-svg-core'

config.mutateApproach = 'sync'

import {
  faBarcode,
  faBriefcase,
  faCalendarCheck,
  faCalendarXmark,
  faCheck,
  faCheckDouble,
  faCircleInfo,
  faChevronLeft,
  faFlag,
  faFolderPlus,
  faGlobe,
  faGraduationCap,
  faList,
  faPlay,
  faRightFromBracket,
  faRightToBracket,
  faSearch,
  faUser
} from '@fortawesome/free-solid-svg-icons'

library.add(
  faBarcode,
  faBriefcase,
  faCalendarCheck,
  faCalendarXmark,
  faCheck,
  faCheckDouble,
  faCircleInfo,
  faChevronLeft,
  faFlag,
  faFolderPlus,
  faGlobe,
  faGraduationCap,
  faList,
  faPlay,
  faRightFromBracket,
  faRightToBracket,
  faSearch,
  faUser
)

dom.watch()
