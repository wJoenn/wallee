export type UserErrors = {
  errors: {
    email?: string[]
    password?: string[]
    password_confirmation: string[]
    user?: string[]
  }
}
