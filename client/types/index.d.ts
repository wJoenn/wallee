export type RecursiveRecord = {
  [key: string]: RecursiveRecord | unknown // eslint-disable-line @typescript-eslint/no-redundant-type-constituents
}
