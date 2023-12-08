package second

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    content := string(data)
    lines := strings.split_lines(content)

    time: [dynamic]string
    distance: [dynamic]string

    for t in strings.split(lines[0], " ") {
        if strconv.atoi(t) != 0 {
            append(&time, t)
        }
    }

    for d in strings.split(lines[1], " ") {
        if strconv.atoi(d) != 0 {
            append(&distance, d)
        }
    }
    
    fmt.println("Number of ways:", get_number_of_ways(
        strconv.atoi(strings.join(time[:], "")),
        strconv.atoi(strings.join(distance[:], "")),
    ))
}

get_number_of_ways :: proc(time: int, distance: int) -> int {
    ways := 0
    for i in 1..<time {
        if (time - i) * i > distance {
            ways += 1
        }
    }
    return ways
}
