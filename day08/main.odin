package main

import "core:os"
import "core:fmt"
import "core:time"

import "first"
import "second"

main :: proc() {
    if (len(os.args)) == 1 {
        fmt.println("Usage:", os.args[0], "<1|2>")
        return 
    }

    start_time := time.now()
    if (os.args[1] == "1") {
        first.main()
    } else if (os.args[1] == "2") {
        second.main()
    }
    fmt.println("Time:", time.since(start_time))
}
