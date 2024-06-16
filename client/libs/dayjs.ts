import dayjs from "dayjs"
import customParseFormat from "dayjs/plugin/customParseFormat"
import minMax from "dayjs/plugin/minMax"

dayjs.extend(customParseFormat)
dayjs.extend(minMax)

export default dayjs
