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

    content := strings.split_lines(string(data))
    sum := 0

    temp := [dynamic]int{}
    for line in content {
        clear(&temp)
        for num in strings.split(line, " ") {
            append(&temp, strconv.atoi(num))
        }
        sum += get_extrapolated(temp[:])
    }

    fmt.println("Sum of extrapolated values:", sum)
}

get_extrapolated :: proc(data: []int) -> int {
    all_zero := true
    temp := [dynamic]int{}
    if data[0] != 0 { all_zero = false }
    for value, i in data[1:] {
        if value != 0 { all_zero = false }
        append(&temp, value - data[i])
    }

    if all_zero { return 0 }
    return data[0] - get_extrapolated(temp[:])
}