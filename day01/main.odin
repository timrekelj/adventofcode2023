package main

import "core:os"
import "core:fmt"

import "first"
import "second"

main :: proc() {
    if (len(os.args)) == 1 {
        fmt.println("You need to add argument if you want to run part 1 or part 2")
        return 
    }

    if (os.args[1] == "1") {
        first.main()
    } else if (os.args[1] == "2") {
        second.main()
    }
}