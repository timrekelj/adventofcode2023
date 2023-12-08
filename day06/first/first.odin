package first

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

    times: [dynamic]int
    distances: [dynamic]int
    number_of_ways := 1

    for time in strings.split(lines[0], " ") {
        if strconv.atoi(time) != 0 {
            append(&times, strconv.atoi(time))
        }
    }

    for distance in strings.split(lines[1], " ") {
        if strconv.atoi(distance) != 0 {
            append(&distances, strconv.atoi(distance))
        }
    }

    for i in 0..<len(times) {
        number_of_ways *= get_number_of_ways(times[i], distances[i])
    }

    fmt.println("Number of ways:", number_of_ways)
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
