## Limitations
1. This parser requires explicit typing in declarations. 
Example: 
`let x: i32 = 5;`
The following is not accepted and a warning will be thrown.
`let x = 5;`

2. Only explicit returns in the following format are supported:
`return <expr>;`
Implicit returns are not supported.

## Types
- i32
- f64
- String
- bool
- &<`type`>
Note: All Let declarations and Function declarations must be typed explicitly. 