export const toEuro = (value?: number) => `${((value ?? 0) / 100).toFixed(2)} €`
