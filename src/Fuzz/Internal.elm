module Fuzz.Internal exposing (Exhaustive, Fuzzer(..), generate, maxExhaustiveSize)

{-| This module is here just to hide the `generate` function from the end users
of the library.
-}

import GenResult exposing (GenResult)
import PRNG exposing (PRNG)


maxExhaustiveSize : number
maxExhaustiveSize =
    -- Picked so that maxExhaustiveSize * maxExhaustiveSize is still < 2^53
    2 ^ 26


type alias Exhaustive a =
    { count : Int
    , generate : Int -> Result String a
    , isExhaustive : Bool -- This will be False for types like `Result Bool String` where we have both an exhaustive part [ Err True, Err False ] and a nonexhaustive part [ Ok "..." ]
    }


type Fuzzer a
    = Fuzzer
        { exhaustive : Maybe (Exhaustive a)
        , generate : PRNG -> GenResult a
        }


generate : PRNG -> Fuzzer a -> GenResult a
generate prng (Fuzzer fuzzer) =
    fuzzer.generate prng
