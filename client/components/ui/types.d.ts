export type InputType = "number" | "text"
export type InputValue<T extends InputType> = T extends "number" ? number : T extends "text" ? string : never
