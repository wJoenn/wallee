export type BaseModel = {
  id: number
}

/** @example "1970-01-01" */
export type DateString = string

export type RecursiveRecord = {
  [key: string]: RecursiveRecord | unknown // eslint-disable-line @typescript-eslint/no-redundant-type-constituents
}

/** @example "1970-01-01T00:00:00.000Z" */
export type Timestamp = string
